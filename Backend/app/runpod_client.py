import requests, time

#API_KEY = #
#ENDPOINT_ID = # SDXL-turbo (Stable Diffusion XL turbo) 1.1.1
#ENDPOINT_ID =  # BK-SDM-Base # BK-SDM-Base
RUN_URL = f"https://api.runpod.ai/v2/{ENDPOINT_ID}/run"
STATUS_URL = f"https://api.runpod.ai/v2/{ENDPOINT_ID}/status"

headers = {
    "Content-Type": "application/json",
    "Authorization": API_KEY
}


def runpod_prompt(prompt_text="Hello"):
    data = {"input": {"prompt": prompt_text}}

    # submit job
    resp = requests.post(RUN_URL, headers=headers, json=data).json()
    job_id = resp["id"]

    # poll until complete
    while True:
        status = requests.get(f"{STATUS_URL}/{job_id}", headers=headers).json()
        if status["status"] == "COMPLETED":
            return status["output"]
        elif status["status"] in ("FAILED", "CANCELLED"):
            raise RuntimeError(status)
        time.sleep(2)
