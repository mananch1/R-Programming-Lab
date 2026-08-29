from ddgs import DDGS
import requests
import os

def download_images(query, prefix, count=15):
    os.makedirs("Dataset", exist_ok=True)
    
    with DDGS() as ddgs:
        results = ddgs.images(query, max_results=count)
        
        for i, result in enumerate(results, start=1):
            try:
                url = result["image"]
                response = requests.get(url, timeout=10)
                response.raise_for_status()
                
                filename = f"Dataset/{prefix}{i}.jpg"
                with open(filename, "wb") as f:
                    f.write(response.content)
                
                print(f"Saved {filename}")
            
            except Exception as e:
                print(f"Failed to download {prefix}{i}: {e}")

# Download plane images
download_images("airplane", "p", 15)

# Download car images
download_images("car", "c", 15)