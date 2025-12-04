from scheduler.queue_simulator import QueueSimulator

if __name__ == "__main__":
    sim = QueueSimulator(
        arrival_rate=0.3,  # λ requests per second
        run_time=60        # duration in seconds
    )
    sim.simulate()
