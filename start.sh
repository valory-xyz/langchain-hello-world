#!/bin/bash

# --frozen --no-sync: the image already has the resolved venv baked in
# at build time, so skip uv's re-check / re-sync at container start
# (avoids network access and keeps the runtime hermetic).
uv run --frozen --no-sync python -m langchain_hello_world.main
