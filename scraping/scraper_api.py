#!/usr/bin/env python3
"""
API-based scraper for Snitch.com men's shirts
Uses the discovered API endpoint for more reliable data extraction
"""

import requests
import json
import os
from urllib.parse import urljoin

class SnitchAPIScraper:
    def __init__(self):
        self.base_url = "https://mxemjhp3rt.ap-south-1.awsapprunner.com"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json',
            'Referer': 'https://www.snitch.com/'
        })
        self.products = []
    
    def fetch_products(self, product_type="Shirts,Overshirt", page=1, limit=100):
        """Fetch products from the API"""
        url = f"{self.base_url}/products/plp/v2"
        params = {
            'page': page,
            'limit': limit,
            'product_type': product_type
        }
        
        try:
            print(f"Fetching products from API (page {page}, limit {limit})...")
            response = self.session.get(url, params=params, timeout=30)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error fetching from API: {e}")
            return None
    
    def extract_product_data(self, api_data):
        """Extract and format product data from API response"""
        products = []
        
        if not api_data:
            return products
        
        # The API structure: {"data": {"products": [...]}}
        items = []
        
        if isinstance(api_data, dict):
            if 'data' in api_data and isinstance(api_data['data'], dict):
                if 'products' in api_data['data']:
                    items = api_data['data']['products']
                elif isinstance(api_data['data'], list):
                    items = api_data['data']
            elif 'products' in api_data:
                items = api_data['products']
            elif 'items' in api_data:
                items = api_data['items']
            elif 'results' in api_data:
                items = api_data['results']
        elif isinstance(api_data, list):
            items = api_data
        
        if not isinstance(items, list):
            return products
        
        for item in items:
            if not isinstance(item, dict):
                continue
            # Calculate discount if both prices are available
            selling_price = item.get('selling_price') or item.get('price', 0)
            mrp = item.get('mrp') or item.get('original_price', 0)
            discount = None
            if mrp > 0 and selling_price < mrp:
                discount = round(((mrp - selling_price) / mrp) * 100, 1)
            
            product = {
                'id': item.get('shopify_product_id') or item.get('id') or item.get('product_id', ''),
                'name': item.get('title') or item.get('name') or item.get('product_name', ''),
                'price': selling_price,
                'original_price': mrp if mrp > 0 else None,
                'discount_percentage': discount,
                'product_url': f"https://www.snitch.com/products/{item.get('handle', '')}" if item.get('handle') else (item.get('url') or item.get('product_url') or ''),
                'handle': item.get('handle', ''),
                'images': [],
                'preview_image': item.get('preview_image', ''),
                'description': item.get('short_description') or item.get('description', ''),
                'brand': item.get('brand') or item.get('vendor', 'Snitch'),
                'category': item.get('shopify_product_type') or item.get('category') or item.get('product_type', ''),
                'fit': item.get('fit', ''),
                'collar': item.get('collar', ''),
                'sleeves': item.get('sleeves', ''),
                'material': item.get('material', ''),
                'pattern': item.get('pattern', ''),
                'colors': item.get('colors', []),
                'color_variants_count': item.get('color_variants_count', 0),
                'average_rating': item.get('average_rating'),
                'total_ratings_count': item.get('total_ratings_count', 0),
                'model_info': item.get('model_info', ''),
                'occassion': item.get('occassion', ''),
            }
            
            # Extract images - API provides images as array of URLs
            images = item.get('images', [])
            if isinstance(images, list):
                for img in images:
                    if isinstance(img, str) and img:
                        # Add quality parameter if not present
                        if 'quality=' not in img:
                            img = img + ('&' if '?' in img else '?') + 'quality=80'
                        product['images'].append(img)
            
            # Add preview image if not already in images list
            if product.get('preview_image') and product['preview_image'] not in product['images']:
                preview = product['preview_image']
                if 'quality=' not in preview:
                    preview = preview + ('&' if '?' in preview else '?') + 'quality=80'
                product['images'].insert(0, preview)
            
            # Clean up None and empty string fields (but keep 0 values for prices, etc.)
            product = {k: v for k, v in product.items() if v is not None and v != ''}
            
            products.append(product)
        
        return products
    
    def scrape_all_pages(self, product_type="Shirts,Overshirt", max_pages=10):
        """Scrape all available pages"""
        all_products = []
        
        for page in range(1, max_pages + 1):
            api_data = self.fetch_products(product_type, page=page, limit=100)
            products = self.extract_product_data(api_data)
            
            if not products:
                print(f"No more products found at page {page}")
                break
            
            all_products.extend(products)
            print(f"Page {page}: Found {len(products)} products (Total: {len(all_products)})")
            
            # If we got fewer products than the limit, we've reached the end
            if len(products) < 100:
                break
        
        return all_products
    
    def save_results(self, products, filename='scraped_data_api.json'):
        """Save scraped data to JSON file"""
        data = {
            'total_products': len(products),
            'products': products
        }
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"\nData saved to {filename}")
        
        # Also save a summary
        summary = {
            'total_products': len(products),
            'products_with_images': sum(1 for p in products if p.get('images')),
            'products_with_prices': sum(1 for p in products if p.get('price')),
            'sample_products': products[:5]
        }
        
        with open('scraped_summary.json', 'w', encoding='utf-8') as f:
            json.dump(summary, f, indent=2, ensure_ascii=False)
        print(f"Summary saved to scraped_summary.json")
    
    def download_images(self, products, output_dir='images'):
        """Download product images"""
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        print(f"\nDownloading images to {output_dir}/...")
        downloaded = 0
        
        for i, product in enumerate(products):
            if not product.get('images'):
                continue
            
            product_name = product.get('name', f'product_{i}').replace('/', '_').replace('\\', '_')[:50]
            product_id = product.get('id', i)
            
            for j, img_url in enumerate(product['images'][:3]):  # Download first 3 images per product
                try:
                    response = self.session.get(img_url, timeout=30)
                    response.raise_for_status()
                    
                    # Determine file extension
                    ext = '.jpg'
                    if '.png' in img_url.lower():
                        ext = '.png'
                    elif '.webp' in img_url.lower():
                        ext = '.webp'
                    
                    filename = f"{output_dir}/{product_id}_{j}{ext}"
                    with open(filename, 'wb') as f:
                        f.write(response.content)
                    downloaded += 1
                except Exception as e:
                    print(f"Error downloading image {img_url}: {e}")
        
        print(f"Downloaded {downloaded} images")


def main():
    scraper = SnitchAPIScraper()
    
    # Scrape products
    products = scraper.scrape_all_pages(product_type="Shirts,Overshirt", max_pages=5)
    
    if products:
        print(f"\n✓ Successfully scraped {len(products)} products")
        
        # Show sample
        print("\nSample products:")
        for i, product in enumerate(products[:3], 1):
            print(f"\nProduct {i}:")
            print(f"  Name: {product.get('name', 'N/A')}")
            print(f"  Price: {product.get('price', 'N/A')}")
            print(f"  Images: {len(product.get('images', []))}")
            if product.get('images'):
                print(f"  First image: {product['images'][0][:80]}...")
        
        # Save results
        scraper.save_results(products)
        
        # Optionally download images (uncomment if needed)
        # scraper.download_images(products)
    else:
        print("No products found")


if __name__ == "__main__":
    main()

