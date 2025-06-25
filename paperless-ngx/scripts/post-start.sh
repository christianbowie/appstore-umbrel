#!/bin/bash
set -euo pipefail

echo "Starting Paperless-NGX post-installation setup..."

# Wait for Ollama to be ready
echo "Waiting for Ollama service to be ready..."
timeout=300
counter=0
while ! docker exec "${APP_ID}_ollama_1" ollama list > /dev/null 2>&1; do
    if [ $counter -ge $timeout ]; then
        echo "Warning: Ollama service did not start within $timeout seconds"
        break
    fi
    sleep 2
    counter=$((counter + 2))
done

# Pull required AI models
if docker exec "${APP_ID}_ollama_1" ollama list > /dev/null 2>&1; then
    echo "Downloading AI models (this may take several minutes)..."
    
    # Check if models already exist
    if ! docker exec "${APP_ID}_ollama_1" ollama list | grep -q "llama3.2"; then
        echo "Pulling Llama 3.2 model..."
        docker exec "${APP_ID}_ollama_1" ollama pull llama3.2 || echo "Warning: Failed to pull llama3.2 model"
    fi
    
    if ! docker exec "${APP_ID}_ollama_1" ollama list | grep -q "minicpm-v"; then
        echo "Pulling MiniCPM-V model for vision..."
        docker exec "${APP_ID}_ollama_1" ollama pull minicpm-v || echo "Warning: Failed to pull minicpm-v model"
    fi
    
    echo "AI models setup completed!"
else
    echo "Warning: Could not connect to Ollama service. Models will be downloaded on first use."
fi

# Wait for main Paperless service to be ready
echo "Waiting for Paperless-NGX service to be ready..."
timeout=180
counter=0
while ! curl -f "http://localhost:8000/api/" > /dev/null 2>&1; do
    if [ $counter -ge $timeout ]; then
        echo "Warning: Paperless-NGX service did not start within $timeout seconds"
        break
    fi
    sleep 5
    counter=$((counter + 5))
done

echo "Paperless-NGX post-start setup completed!"
echo ""
echo "🎉 Setup complete! You can now:"
echo "1. Access Paperless-NGX at http://[YOUR_UMBREL_IP]:${APP_PAPERLESS_NGX_PORT:-8020}"
echo "2. Upload documents to the consume folder"
echo "3. The AI features will process documents automatically"
echo ""
echo "📚 Useful information:"
echo "- Default admin username: ${DEVICE_HOSTNAME}"
echo "- Check the logs if you encounter any issues"
echo "- Documents placed in the consume folder will be processed automatically"