from app import demo
import os

concurrency_limit = 3
MCP_SERVER = os.getenv('GRADIO_MCP_SERVER', 'False') == 'True'

if __name__ == "__main__":
    demo.queue(
        api_open=True,
        max_size=concurrency_limit,
        default_concurrency_limit=concurrency_limit,
    )
    demo.launch(max_threads=concurrency_limit, mcp_server=MCP_SERVER)
