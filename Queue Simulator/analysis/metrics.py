import csv
import os

class MetricsTracker:
    def __init__(self):
        os.makedirs("data/metrics", exist_ok=True)
        self.latency_file = "data/metrics/latency.csv"
        self.quality_file = "data/metrics/quality.csv"
        self.all_file = "data/metrics/all_metrics.csv"

        self.latency_logs = []
        self.quality_logs = []

    def log_latency(self, wait_time, service_time, queue_length):
        self.latency_logs.append({
            "wait_time": wait_time,
            "generation_time": service_time,
            "queue_length": queue_length,
        })

    def log_quality(self, clip_self):
        self.quality_logs.append({
            "clip_self_similarity": clip_self
        })

    def save_all(self):
        self._save_csv(self.latency_file, self.latency_logs)
        self._save_csv(self.quality_file, self.quality_logs)

        merged = []
        for i in range(len(self.latency_logs)):
            merged_row = dict(self.latency_logs[i])
            if i < len(self.quality_logs):
                merged_row.update(self.quality_logs[i])
            merged.append(merged_row)

        self._save_csv(self.all_file, merged)

    def _save_csv(self, path, rows):
        if not rows:
            return
        keys = rows[0].keys()
        with open(path, "w", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=keys)
            writer.writeheader()
            writer.writerows(rows)
