#!/usr/bin/bash
# Made with Vim on Arch Linux ^^
echo "Pushing origin..."
git push origin main # TODO: Check which branch contains the game source
if [ $? -ne 0 ]; then
	echo "Error: git push failed!" # TODO: Show more details
	exit 1
fi

echo "Done!"
