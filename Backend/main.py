from fastapi import FastAPI, Response
from app.runpod_client import runpod_prompt
from app.captioner import add_bottom_caption
from groq import Groq
import base64
from PIL import Image
import io
import os

#API_KEY = 
#ENDPOINT_ID = ""

app = FastAPI()

client = Groq(api_key="")


def auto_caption():
    response = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=[
            {"role": "system",
             "content": (
                    "Generate a NEW funny caption under 20 words. "
                    "Use a wide variety of topics, not just animals. "
                    "Do NOT repeat previous themes. No questions."
                )}
        ],
        max_tokens=50,
        temperature=1.1,
    )
    return response.choices[0].message.content.strip()


@app.get("/generate")
def generate_image():
    # 1) Create caption
    caption = auto_caption()

    # 2) Send to RunPod
    output = runpod_prompt(caption)

    # 3) Decode received image
    #img_b64 = output["images"][0]["image"] # SDXL-turbo (Stable Diffusion XL turbo) 1.1.1
    img_b64 = output["image"] # BK-SDM-Base
    img_bytes = base64.b64decode(img_b64)
    img = Image.open(io.BytesIO(img_bytes))

    # 4) Apply caption
    final_img = add_bottom_caption(img, caption)

    # 5) Convert to PNG bytes
    buffer = io.BytesIO()
    final_img.save(buffer, format="PNG")
    buffer.seek(0)

    return Response(buffer.read(), media_type="image/png")
