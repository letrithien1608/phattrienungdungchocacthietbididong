import urllib.request
import os

images = [
    "main_banner.jpg", "product_new_1.jpg", "product_new_2.jpg", "product_new_3.jpg",
    "banner_street.jpg", "product_sale_1.jpg", "product_sale_2.jpg", "product_sale_3.jpg",
    "banner_new_collection.jpg", "banner_mens_hoodies.jpg", "banner_black.jpg"
]

os.makedirs("assets/images", exist_ok=True)

for img in images:
    print(f"Downloading {img}...")
    try:
        urllib.request.urlretrieve("https://picsum.photos/400/400", f"assets/images/{img}")
        print(f"Success: {img}")
    except Exception as e:
        print(f"Failed {img}: {e}")
