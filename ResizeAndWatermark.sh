#!/bin/bash
# Script location ex:
# 		/mnt/c/Users/kinga/OneDrive/Desktop/PaintingsResize/ResizeAndWatermark.sh

# Resizes an image, looks for a watermark.png image in the folder and applies it to image.
# Asks the user to resize the images to a certain width.
# Requires https://imagemagick.org/script/download.php

# Instructions:
#  - Drag script in folder containing images and watermark.png.
#  - Run the script
#  - Let the script watermark your images


# Path of the folder containing the script:
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

	RESIZED=$DIR"/Resized"
	DEPOSIT=$DIR"/Originals"
	WATERMARK=$DIR"/Watermark"
	WATERMARKED=$DIR"/Watermarked"
	
# Create resize folder if needed.
read -t 10 -p "Resize images before watermarking? [Y/N]" RESIZE
	RESIZE=${RESIZE:-Y}
	
case $RESIZE in
Y)
echo "Resizing and watermarking" 
if [ ! -d $RESIZED ]; then
mkdir -p $RESIZED;
fi
;;
*)
echo "Watermarking at original size"
;;
esac

# Create folder to place the original images
	if [ ! -d $DEPOSIT ]; then
	  mkdir -p $DEPOSIT;
	fi
# Create folder to place the original images
	if [ ! -d $WATERMARK ]; then
	  mkdir -p $WATERMARK;
	fi
	
# Create folder to place the watermarked images.
	if [ ! -d $WATERMARKED ]; then
	  mkdir -p $WATERMARKED;
	fi

# Move original images to Deposit folder.
	find $DIR -maxdepth 1 -type f  \( -name "watermark.png" \) -exec mv {} $WATERMARK \;
	find $DIR -maxdepth 1 -type f  \( -name "*.png" -o -name "*.gif" -o -name "*.jpg" -o -name "*.JPG" \) -exec mv {} $DEPOSIT \;
	
# Copy original files to destination folder
		echo "Copying images to watermarked folder..."
		find $DEPOSIT -maxdepth 1 -type f \( -name "*.png" -o -name "*.PNG" -o -name "*.jpg" -o -name "*.JPG" \) -exec cp {} $WATERMARKED \;
		
		if [ -d "$RESIZED" ]; then
			echo "Copying images to resized folder..."
			find $DEPOSIT -maxdepth 1 -type f  \( -name "*.png" -o -name "*.PNG" -o -name "*.jpg" -o -name "*.JPG" \) -exec cp {} $RESIZED \;
		fi
		if [ -d "$RESIZED" ]; then
		echo "Resizing images and adding watermarks..."
		else
		echo "Adding watermarks...."
		fi
		for thumbnail in $DEPOSIT/*; do
			IMAGENAME=$(basename $thumbnail)
			if [ "watermark.png" != $IMAGENAME ];then
				WATERMARKIMG=$WATERMARK"/watermark.png"
				WATERMARKRESIZE=$WATERMARK"/watermark.png"
				RESIZEDIMAGE=$RESIZED"/"$IMAGENAME
				WATERMARKEDIMAGE=$WATERMARKED"/"$IMAGENAME
				if [ -d "$RESIZED" ]; then
					echo "Applying watermark: -> "$IMAGENAME
					composite -dissolve 15% -gravity center $WATERMARKIMG $thumbnail $RESIZEDIMAGE
					convert $RESIZEDIMAGE'[640000@]' $RESIZEDIMAGE
					composite -dissolve 30% -gravity center $WATERMARKIMG $thumbnail $WATERMARKEDIMAGE
				else
					echo "Applying watermark: -> "$IMAGENAME
					composite -dissolve 30% -gravity center $WATERMARKIMG $thumbnail $WATERMARKEDIMAGE
				fi
			fi
		done
		echo "Done!"
	
exit 0