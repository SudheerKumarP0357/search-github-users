#!/bin/sh
set -e

# Define env.js file path
ENV_JS_FILE="/usr/share/nginx/html/env.js"
TEMPLATE_FILE="/usr/share/nginx/html/env.template.js"

# Ensure the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: env.template.js not found! Exiting..."
  exit 1
fi

# Generate env.js dynamically from env.template.js
echo "Generating env.js with environment variables..."
envsubst < "$TEMPLATE_FILE" > "$ENV_JS_FILE"

# Debugging: Print env.js content to verify it was updated
echo "Updated env.js content:"
cat "$ENV_JS_FILE"

# Replace placeholder with actual environment variable
sed -i "s|REPLACE_WITH_ENV|${VITE_GITHUB_TOKEN}|g" "$ENV_JS_FILE"

# Start Nginx
exec nginx -g "daemon off;"
