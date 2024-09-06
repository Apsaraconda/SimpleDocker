#!/bin/bash

search_image_name=$(sudo docker images | awk '{print $1}' | grep -nw 'gigantag' | awk -F: '{print $1}')

search_image_tag=$(sudo docker images | awk '{print $2}' | grep -nw '1.0' | awk -F: '{print $1}')

if [ "$search_image_name" != "" ] && [ $search_image_tag != "" ]; then
  if [ $search_image_name -gt 0 ] && [ $search_image_tag -gt 0 ] && [ $search_image_name -gt 0 ] && [ $search_image_tag -eq $search_image_name ]; then
    search_image_ID=$(sudo docker images | awk '{print $3}' | head -$search_image_tag | tail -1)
    echo "Image gigantag:1.0 (ID = $search_image_ID) found! Removing $search_image_ID ..."
    sudo docker rmi -f $search_image_ID
  fi
fi
echo "Start building ..."
export DOCKER_CONTENT_TRUST=1
sudo docker build -t gigantag:1.0 .
sudo docker run -p 80:81 -v ./nginx/nginx.conf:/etc/nginx/nginx.conf gigantag:1.0