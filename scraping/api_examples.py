#!/usr/bin/env python3
"""
Examples of using the Snitch.com API for various purposes
"""

import requests
import json
from collections import Counter

class SnitchAPIExamples:
    def __init__(self):
        self.base_url = "https://mxemjhp3rt.ap-south-1.awsapprunner.com"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json',
            'Referer': 'https://www.snitch.com/'
        })
    
    def get_filters(self, product_type="Shirts,Overshirt"):
        """Get all available filters for a product type"""
        url = f"{self.base_url}/products/filters/v2"
        params = {'product_type': product_type}
        response = self.session.get(url, params=params)
        return response.json()
    
    def get_filter_chips(self, product_type="Shirts,Overshirt"):
        """Get quick filter chips"""
        url = f"{self.base_url}/products/chips/v3"
        params = {'product_type': product_type}
        response = self.session.get(url, params=params)
        return response.json()
    
    def get_products(self, product_type="Shirts,Overshirt", page=1, limit=100):
        """Get products"""
        url = f"{self.base_url}/products/plp/v2"
        params = {
            'page': page,
            'limit': limit,
            'product_type': product_type
        }
        response = self.session.get(url, params=params)
        return response.json()
    
    def analyze_product_distribution(self, product_type="Shirts,Overshirt"):
        """Analyze product distribution by various attributes"""
        print(f"\n📊 Analyzing product distribution for: {product_type}")
        print("=" * 60)
        
        filters = self.get_filters(product_type)
        if 'data' in filters:
            data = filters['data']
            
            # Analyze colors
            if 'color' in data:
                print("\n🎨 Top Colors:")
                for color in data['color'][:10]:
                    print(f"  {color['attribute_value']}: {color['count']} products")
            
            # Analyze fits
            if 'fit' in data:
                print("\n👔 Top Fits:")
                for fit in data['fit'][:5]:
                    print(f"  {fit['attribute_value']}: {fit['count']} products")
            
            # Analyze patterns
            if 'pattern' in data:
                print("\n🎨 Top Patterns:")
                for pattern in data['pattern'][:5]:
                    print(f"  {pattern['attribute_value']}: {pattern['count']} products")
            
            # Analyze materials
            if 'material' in data:
                print("\n🧵 Top Materials:")
                for material in data['material'][:5]:
                    print(f"  {material['attribute_value']}: {material['count']} products")
    
    def find_products_by_price_range(self, product_type="Shirts,Overshirt", min_price=0, max_price=1000):
        """Find products within a price range"""
        print(f"\n💰 Finding products between ₹{min_price} - ₹{max_price}")
        print("=" * 60)
        
        products = self.get_products(product_type, page=1, limit=100)
        if 'data' in products and 'products' in products['data']:
            matching = []
            for product in products['data']['products']:
                price = product.get('selling_price', 0)
                if min_price <= price <= max_price:
                    matching.append({
                        'name': product.get('title', ''),
                        'price': price,
                        'rating': product.get('average_rating', 0)
                    })
            
            print(f"\nFound {len(matching)} products in price range")
            for p in matching[:10]:
                print(f"  {p['name']}: ₹{p['price']} (⭐ {p['rating']})")
    
    def find_best_rated_products(self, product_type="Shirts,Overshirt", min_rating=4.5, min_reviews=100):
        """Find highly rated products with many reviews"""
        print(f"\n⭐ Finding best rated products (rating ≥ {min_rating}, reviews ≥ {min_reviews})")
        print("=" * 60)
        
        products = self.get_products(product_type, page=1, limit=100)
        if 'data' in products and 'products' in products['data']:
            best = []
            for product in products['data']['products']:
                rating = product.get('average_rating', 0)
                reviews = product.get('total_ratings_count', 0)
                if rating >= min_rating and reviews >= min_reviews:
                    best.append({
                        'name': product.get('title', ''),
                        'rating': rating,
                        'reviews': reviews,
                        'price': product.get('selling_price', 0)
                    })
            
            # Sort by rating
            best.sort(key=lambda x: x['rating'], reverse=True)
            
            print(f"\nFound {len(best)} highly rated products:")
            for p in best[:10]:
                print(f"  {p['name']}: ⭐ {p['rating']} ({p['reviews']} reviews) - ₹{p['price']}")
    
    def get_new_arrivals(self, product_type="Shirts,Overshirt", days=30):
        """Get recently added products"""
        print(f"\n🆕 Finding new arrivals (last {days} days)")
        print("=" * 60)
        
        products = self.get_products(product_type, page=1, limit=100)
        if 'data' in products and 'products' in products['data']:
            # Note: You'd need to parse dates properly in a real implementation
            print("Note: Date filtering would require parsing 'created_at' or 'published_at' fields")
            print(f"Total products available: {len(products['data']['products'])}")
    
    def get_quick_filters(self, product_type="Shirts,Overshirt"):
        """Show available quick filter options"""
        print(f"\n🔍 Quick Filter Options for: {product_type}")
        print("=" * 60)
        
        chips = self.get_filter_chips(product_type)
        if 'data' in chips:
            print("\nAvailable Quick Filters:")
            for chip in chips['data']:
                print(f"  {chip['attribute_label']} ({chip['attribute_name']}: {chip['attribute_value']})")
    
    def compare_product_types(self, product_types=["Shirts,Overshirt", "Jeans"]):
        """Compare different product categories"""
        print(f"\n📈 Comparing Product Categories")
        print("=" * 60)
        
        for ptype in product_types:
            products = self.get_products(ptype, page=1, limit=100)
            if 'data' in products and 'products' in products['data']:
                product_list = products['data']['products']
                avg_price = sum(p.get('selling_price', 0) for p in product_list) / len(product_list) if product_list else 0
                avg_rating = sum(p.get('average_rating', 0) for p in product_list) / len(product_list) if product_list else 0
                
                print(f"\n{ptype}:")
                print(f"  Products: {len(product_list)}")
                print(f"  Avg Price: ₹{avg_price:.2f}")
                print(f"  Avg Rating: {avg_rating:.2f}")


def main():
    api = SnitchAPIExamples()
    
    print("🚀 Snitch.com API Examples")
    print("=" * 60)
    
    # Example 1: Analyze product distribution
    api.analyze_product_distribution("Shirts,Overshirt")
    
    # Example 2: Find products by price
    api.find_products_by_price_range("Shirts,Overshirt", min_price=500, max_price=1000)
    
    # Example 3: Find best rated products
    api.find_best_rated_products("Shirts,Overshirt", min_rating=4.5, min_reviews=100)
    
    # Example 4: Get quick filters
    api.get_quick_filters("Shirts,Overshirt")
    
    # Example 5: Compare categories
    api.compare_product_types(["Shirts,Overshirt", "Jeans"])
    
    print("\n" + "=" * 60)
    print("✅ Examples completed!")
    print("\n💡 You can use these patterns to:")
    print("  - Build price tracking systems")
    print("  - Create recommendation engines")
    print("  - Analyze market trends")
    print("  - Build custom search/filter UIs")
    print("  - Monitor inventory and new arrivals")


if __name__ == "__main__":
    main()

