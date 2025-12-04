import io
import base64
import torch
from diffusers import StableDiffusionPipeline
import runpod

MODEL_DIR = "/app"  # your model folders live here

# Load pipeline
pipe = StableDiffusionPipeline.from_pretrained(
    MODEL_DIR,
    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
    safety_checker=None
).to("cuda" if torch.cuda.is_available() else "cpu")

# RunPod handler
def handler(event):
    # RunPod wraps inputs in event["input"]
    inputs = event.get("input", {})
    prompt = inputs.get("prompt", None)

    if not prompt:
        return {"error": "No prompt provided"}

    # Run inference
    result = pipe(prompt, num_inference_steps=30)
    image = result.images[0]

    # Convert to base64
    buf = io.BytesIO()
    image.save(buf, format="PNG")
    img_str = base64.b64encode(buf.getvalue()).decode()

    return {"image": img_str}

# Start serverless worker
runpod.serverless.start({"handler": handler})
