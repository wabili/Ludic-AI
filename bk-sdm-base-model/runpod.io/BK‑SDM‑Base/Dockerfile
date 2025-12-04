# CUDA + PyTorch preinstalled → avoids 8GB install
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

ENV PYTHONUNBUFFERED=1

# Create workdir
WORKDIR /app

# Copy only code first (better caching)
COPY server.py requirements.txt model_index.json test_input.json /app/

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgl1 \
        libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Python libs (torch is already included → keeps size small)
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copy your **local model folders**
COPY scheduler/ /app/scheduler/
COPY text_encoder/ /app/text_encoder/
COPY tokenizer/ /app/tokenizer/
COPY unet/ /app/unet/
COPY vae/ /app/vae/

# Expose for local debugging
EXPOSE 8000

# Start server
CMD ["python3", "server.py"]
