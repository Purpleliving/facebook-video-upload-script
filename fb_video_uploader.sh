#!/bin/bash

# 
PAGE_ID="your_facebook_page_id"         # Replace with your Facebook Page ID
ACCESS_TOKEN="your_page_access_token"   # Replace with your Facebook Page Access Token

# 
echo "Enter the video URL you want to download and upload to Facebook:"
read VIDEO_URL

# 
echo "Downloading video from $VIDEO_URL..."
yt-dlp -o "downloaded_video.%(ext)s" "$VIDEO_URL"


VIDEO_FILE=$(ls downloaded_video.* | head -n 1)

# Check if the video was downloaded
if [ -f "$VIDEO_FILE" ]; then
    echo "Video downloaded: $VIDEO_FILE"
else
    echo "Failed to download video"
    exit 1
fi


echo "Uploading video to Facebook Page ID: $PAGE_ID..."
UPLOAD_RESPONSE=$(curl -X POST "https://graph.facebook.com/$PAGE_ID/videos" \
    -F "file=@$VIDEO_FILE" \
    -F "description=Reposted video from $VIDEO_URL" \
    -F "access_token=$ACCESS_TOKEN")


echo "Upload response: $UPLOAD_RESPONSE"

# Optional: Clean up downloaded video file
rm "$VIDEO_FILE"