#!/bin/bash
set -euo pipefail

# Create necessary directories
echo "Creating Paperless-NGX directories..."
mkdir -p "${APP_DATA_DIR}/data"
mkdir -p "${APP_DATA_DIR}/media"
mkdir -p "${APP_DATA_DIR}/consume"
mkdir -p "${APP_DATA_DIR}/export"
mkdir -p "${APP_DATA_DIR}/db"
mkdir -p "${APP_DATA_DIR}/redis"
mkdir -p "${APP_DATA_DIR}/ollama"
mkdir -p "${APP_DATA_DIR}/paperless-ai"
mkdir -p "${APP_DATA_DIR}/paperless-gpt/prompts"
mkdir -p "${APP_DATA_DIR}/paperless-gpt/hocr"
mkdir -p "${APP_DATA_DIR}/paperless-gpt/pdf"

# Set proper permissions
echo "Setting permissions..."
chown -R 1000:1000 "${APP_DATA_DIR}"

# Create default prompt files for paperless-gpt
echo "Creating default prompt files..."
cat > "${APP_DATA_DIR}/paperless-gpt/prompts/title.txt" << 'EOF'
Please analyze this document and provide a concise, descriptive title that captures the main purpose and content. The title should be:
- Clear and specific
- Under 100 characters
- Professional and descriptive
- Include relevant dates, companies, or document types where appropriate

Document content: {text}

Title:
EOF

cat > "${APP_DATA_DIR}/paperless-gpt/prompts/tags.txt" << 'EOF'
Analyze this document and suggest relevant tags that would help categorize and find it later. Consider:
- Document type (invoice, contract, receipt, letter, etc.)
- Company/organization names
- Important topics or categories
- Dates or time periods
- Relevant keywords

Please provide tags as a comma-separated list, maximum 10 tags.

Document content: {text}

Tags:
EOF

echo "Installation completed successfully!"
echo ""
echo "🎉 Paperless-NGX has been installed!"
echo ""
echo "📋 Next steps:"
echo "1. The app will be available at your Umbrel's IP address on port ${APP_PAPERLESS_NGX_PORT:-8020}"
echo "2. Wait for all containers to start (this may take a few minutes)"
echo "3. The AI models will be downloaded automatically on first use"
echo "4. Access the web interface to complete setup"
echo ""
echo "🤖 AI Features:"
echo "- Document OCR and text extraction"
echo "- Automatic tagging and categorization"
echo "- Smart document processing"
echo ""
echo "📁 Upload documents to: ${APP_DATA_DIR}/consume"
echo "📤 Export documents from: ${APP_DATA_DIR}/export"