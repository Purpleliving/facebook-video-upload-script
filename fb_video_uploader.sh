#!/bin/bash

# Source the configuration file
source "config.sh"

# Prompt the user to input the video URL
echo "Enter the video URL you want to download and upload to Facebook:"
read VIDEO_URL

# Prompt the user to input a custom caption
echo "Enter the caption for the video:"
read VIDEO_CAPTION

# Step 1: Download the video
echo "Downloading video from $VIDEO_URL..."
yt-dlp -o "downloaded_video.%(ext)s" "$VIDEO_URL"

# Find the downloaded file
VIDEO_FILE=$(ls downloaded_video.* | head -n 1)

# Check if the video was downloaded
if [ -f "$VIDEO_FILE" ]; then
    echo "Video downloaded: $VIDEO_FILE"
else
    echo "Failed to download video"
    exit 1
fi

# Step 2: Upload the video to Facebook
echo "Uploading video to Facebook Page ID: $PAGE_ID..."
UPLOAD_RESPONSE=$(curl -X POST "https://graph.facebook.com/$PAGE_ID/videos" \
    -F "file=@$VIDEO_FILE" \
    -F "description=$VIDEO_CAPTION" \
    -F "access_token=$ACCESS_TOKEN")

# Output the response from Facebook API
echo "Upload response: $UPLOAD_RESPONSE"

# Optional: Clean up downloaded video file
rm "$VIDEO_FILE"
