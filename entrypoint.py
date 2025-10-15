from app import demo

concurrency_limit = 3

if __name__ == "__main__":
    demo.queue(
        api_open=True,
        max_size=concurrency_limit,
        default_concurrency_limit=concurrency_limit,
    )
    demo.launch(
        show_api=True,
        max_threads=concurrency_limit,
    )
