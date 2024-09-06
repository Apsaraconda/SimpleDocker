#!/bin/bash

OSname=$(uname -s | grep -oc "Linux")
if [ $OSname -eq 1 ]; then
	Dockle=$(dpkg -s dockle | grep -oc "Status:\ install\ ok")
	if [ $Dockle -eq 0 ]; then
		echo "Dockle is not installed:"
		echo "Do you want to try to install it (\"sudo\" required)?"
		echo "(Y/N):"
		read answer
		if [[ $answer = "y" || $answer = "Y" ]]; then
			VERSION=$(
      curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
      grep '"tag_name":' | \
      sed -E 's/.*"v([^"]+)".*/\1/' \
      ) && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb
      sudo dpkg -i dockle.deb && rm dockle.deb
		fi
	fi
fi

echo "Start checking the image: gigantag:1.0 ..."
sudo dockle gigantag:1.0
echo "Done!"