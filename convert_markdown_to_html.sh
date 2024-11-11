#!/bin/bash

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
  echo "Pandoc is required but not installed. Install it and try again."
  exit 1
fi

# Loop through all markdown files in the repo except README.md
find . -name "*.md" ! -name "README.md" | while read -r markdown_file; do
  # Define the output HTML file path (same path, with .html extension)
  output_file="${markdown_file%.md}.html"

  # Calculate the relative path to styles.css based on the file's depth
  # Subtract one from depth so root files don't add "../" at all
  depth=$(( $(echo "$output_file" | tr -cd '/' | wc -c) - 1 ))

  # Start with the base file name
  css_path="styles.css"
  # Add "../" for each level of depth
  for ((i = 0; i < depth; i++)); do
    css_path="../$css_path"
  done    

  # Extract the first header of the markdown for the <title>
  title=$(grep -m 1 '^# ' "$markdown_file" | sed 's/^# //')

  # Convert title to a valid CSS class name (lowercase and underscores)
  body_class=$(basename "${markdown_file%.md}" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

  # Convert markdown to HTML content (body only)
  html_content=$(pandoc "$markdown_file" -f markdown -t html)

  # Create the HTML template with the content, title, and dynamic CSS path
  cat <<EOF > "$output_file"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${css_path}" />
    <title>${title:-"Untitled"}</title>
  </head>

  <body class="${body_class}">
    <div class="markdown">
      ${html_content}
    </div>
  </body>
</html>
EOF

  echo "Converted $markdown_file to $output_file"
done
