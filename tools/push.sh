#!/usr/bin/bash
echo "Pushing origin..."
git push origin main # TODO: Check which branch contains the game source
if [ $? -ne 0 ]; then
	echo "Error: git push failed!"
	exit 1
fi

echo "Done!"
