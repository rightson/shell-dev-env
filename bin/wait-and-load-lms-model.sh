#!/bin/bash

# Default model name, can be overridden by LMS_DEFAULT_MODEL environment variable
MODEL_NAME="${LMS_DEFAULT_MODEL:-qwen3-next-80b-a3b-instruct-mlx}"

echo "Waiting for model '$MODEL_NAME' to be available..."

# Loop until the model is found
while true; do
    if lms ls | grep -q "$MODEL_NAME"; then
        echo "Model '$MODEL_NAME' found! Loading..."
        lms load "$MODEL_NAME"
        break
    else
        waitsec=3
        echo "Model not found yet, checking again in $waitsec seconds..."
        sleep $waitsec
    fi
done
