import requests
from PIL import Image
import io

class APIClient:
    def __init__(self, url="http://127.0.0.1:8000/generate"):
        self.url = url

    def generate(self):
        """Call local API and return PIL image."""
        response = requests.get(self.url)

        if response.status_code != 200:
            raise RuntimeError(f"API error: {response.text}")

        img = Image.open(io.BytesIO(response.content)).convert("RGB")
        return img
