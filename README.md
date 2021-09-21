# BatchWatermark
Shell script that applies a watermark to a batch of images.

## Description:
Resizes images, looks for a watermark.png image in the folder and applies it to all images.
Asks the user if he wants to resize the images to a certain width, in which case a new folder will be created with the resized images.

## Instructions:
  - Drag script in folder containing images and watermark.png.
  - Run the script, I use the Windows Subsystem for Linux (WSL) command prompt.
  - Let the script watermark your images.

## Parameters:

  - -l: Watermark location. Possible values: https://imagemagick.org/script/command-line-options.php#gravity

## Dependencies:
Requires Imagemagick https://imagemagick.org/script/download.php
