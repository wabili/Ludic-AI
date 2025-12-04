import time
import queue
import numpy as np

from client.api_client import APIClient
from analysis.metrics import MetricsTracker
from analysis.fid_clip import QualityEvaluator


class QueueSimulator:
    def __init__(self, arrival_rate, run_time=60):
        self.arrival_rate = arrival_rate
        self.run_time = run_time

        self.q = queue.Queue()
        self.api = APIClient()
        self.metrics = MetricsTracker()
        self.quality = QualityEvaluator()

        self.processing = False
        self.processing_end_time = 0

    def simulate(self):
        start = time.time()
        next_arrival = np.random.exponential(1 / self.arrival_rate)

        print("Simulation started...")

        while (time.time() - start) < self.run_time:
            now = time.time() - start

            # --- Request arrival ---
            if now >= next_arrival:
                self.q.put({"arrival_time": now})
                next_arrival += np.random.exponential(1 / self.arrival_rate)

            # --- Process request if API is free ---
            if not self.processing and not self.q.empty():
                req = self.q.get()
                wait_time = now - req["arrival_time"]

                self.processing = True
                service_start = time.time()
                image = self.api.generate()
                service_time = time.time() - service_start
                self.processing_end_time = now + service_time

                # Compute CLIP metric
                clip_self = self.quality.compute_clip_self(image)

                # Log metrics
                self.metrics.log_latency(
                    wait_time=wait_time,
                    service_time=service_time,
                    queue_length=self.q.qsize()
                )
                self.metrics.log_quality(clip_self=clip_self)

            # --- Check if processing finished ---
            if self.processing and now >= self.processing_end_time:
                self.processing = False

            # prevent busy loop
            time.sleep(0.01)

        self.metrics.save_all()
        print("Simulation complete. Metrics saved.")
