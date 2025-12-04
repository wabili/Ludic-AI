1. Ludic-AI Mobile Application
Purpose
The app displays an infinite feed of AI-generated funny images with captions.
Every image is generated on-demand, meaning nothing is pre-stored — this reduces cost and ensures each image is new.

1.1 Technology Stack
Frontend: Flutter (Dart)
Backend: FastAPI (Python)
AI Models:
LLaMA-3.1-8B for captions
SDXL-Turbo for image generation
BK-SDM-Base as a lightweight alternative model
Image format: Uint8List returned from the API

1.2 Frontend Explanation
System Components
App Wrapper
Provides a warm gradient background for a playful UI.
Feed Screen
Stateful widget
Holds scroll controller, image list, and loading state
Fetches first image in initState
Infinite Scroll Loader
A scroll listener loads a new image once the user nears the end of the feed.
Image Card Widget
Displays:
AI-generated image
Caption overlay
Buttons: Like, Comment, Share
API Service
Asynchronously fetches images from backend as bytes.
Design Philosophy
Clean and fun UI using gradients, padding, shadows
Familiar interaction mechanics like social media apps
Real-time loading spinner while images are fetched

2. Backend System
Your backend runs on FastAPI and orchestrates three AI components:

2.1 Caption Generator
Model: LLaMA-3.1-8B Instruct (hosted on Groq)
Purpose: generate a short funny caption (~20 words).
Highlights:
Decoder-only transformer
8B parameters
Efficient and suitable for low-cost inference
Your documentation includes:
Architecture specifications
VRAM requirement ≈ 17 GB
Latency ~1–2 seconds per caption

2.2 Image Generator
Model: SDXL-Turbo 1.1.1 (hosted on RunPod, GPU A5000)
Used because:
One-step inference (extremely fast)
High image quality
Efficient for real-time apps
Architecture overview:
Latent diffusion model
Text encoder (CLIP-like)
UNet with Turbo sampling
~3.5B parameters
Performance:
VRAM ≈ 10.6 GB
Latency ≈ 1–3 seconds per 512×512 image

2.3 Caption Renderer
Uses PIL to overlay the caption onto the generated image to create a meme-style output.

3. Simulation Framework
You also built a scientific evaluation system to measure:
Latency
Queue build-up
Wait times
Generation times
Image quality via CLIP similarity

3.1 Architecture of Simulation
3.1.1 API Client
Simple HTTP GET request to generate an image.

3.1.2 Queue Simulator
Models a real system where users send requests:
Uses Poisson arrivals (rate λ)
One server = M/G/1 queue
Records:
Wait time W
Service time S
Queue length Q
When arrival rate exceeds the service rate, congestion forms.

3.1.3 Metrics Logging
Results saved to CSV:
Wait time
Service time
Queue length
CLIP similarity score

3.1.4 Quality Evaluation
Uses a CLIP model to compute self-similarity for semantic stability.

3.2 Experiments and Results
You ran experiments comparing SDXL-Turbo and BK-SDM-Base, each deployed on an A5000 GPU.
You produced graphs for:
Total latency over time
Queue length over time
Wait time distribution
Generation time
Image quality stability
Your tables summarize statistics for each model (mean, std, min, max).
General findings:
SDXL-Turbo has higher latency but better quality
BK-SDM-Base is faster but slightly lower quality
Queue length impacts wait time significantly
CLIP similarity stays very high (~98–110)

4. Overall Summary of the Project
Your project is a complete end-to-end real-time AI image generation system consisting of:
✔ A Flutter frontend with infinite AI image feed
✔ A FastAPI backend connecting caption and image models
✔ A simulation framework for scientific evaluation
✔ Two AI pipelines tested and benchmarked
✔ Real-time generation with real GPUs (A5000, 24GB)

It blends:
Mobile app design
Deep learning
GPU inference
Queueing theory

Performance evaluation
Visualization and analysis
This is a well-rounded academic and engineering project.
