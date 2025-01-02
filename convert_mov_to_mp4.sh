#!/bin/bash

cd ./posts

# Loop through all .mov files in the current directory
for file in *.mov; do
  # Generate new file name with .mp4 extension
  newfile="${file%%.mov}.mp4"
  
  # Convert .mov to .mp4 using FFmpeg with settings for maximum compatibility
  # Includes downscaling bit depth to 8 bits
  ffmpeg -i "$file" -vf "scale=1280:720" -pix_fmt yuv420p -vcodec libx264 -profile:v baseline -level 3.0 -acodec aac -b:a 128k "$newfile"
  
  # Check if the conversion was successful
  if [ $? -eq 0 ]; then
    echo "Conversion successful: $file -> $newfile"
    # Delete the original .mov file
    rm "$file"
  else
    echo "Conversion failed for $file"
  fi
done