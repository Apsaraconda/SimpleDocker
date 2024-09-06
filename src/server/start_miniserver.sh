#!/bin/bash

OSname=$(uname -s | grep -oc "Linux")
if [ $OSname -eq 1 ]; then
	libfcgi=$(dpkg -s libfcgi-dev | grep -oc "Status:\ install\ ok")
	spawn=$(dpkg -s spawn-fcgi | grep -oc "Status:\ install\ ok")
	nginx=$(dpkg -s nginx | grep -oc "Status:\ install\ ok")
	if [ $libfcgi -eq 0 ] || [ $spawn -eq 0 ] || [ $nginx -eq 0 ]; then
		echo "Some required packages are not installed:"
		if [ $libfcgi -eq 0 ]; then
			echo libfcgi-dev
		fi
		if [ $spawn -eq 0 ]; then
			echo spawn-fcgi
		fi
		if [ $nginx -eq 0 ]; then
			echo nginx
		fi
		echo "Do you want to try to install it (\"sudo\" required)?"
		echo "(Y/N):"
		read answer
		if [[ $answer = "y" || $answer = "Y" ]]; then
			sudo apt update
			if [ $libfcgi -eq 0 ]; then
				sudo apt install libfcgi-dev
			fi
			if [ $spawn -eq 0 ]; then
				sudo apt install spawn-fcgi
			fi
			if [ $nginx -eq 0 ]; then
				sudo apt install nginx
			fi
		fi
	fi
fi


if [ -e ../nginx/nginx.conf ]; then
	echo "Copying ../nginx/nginx.conf to /etc/nginx/nginx.conf ..."
	sudo cp ../nginx/nginx.conf /etc/nginx/nginx.conf
	username=$(whoami)
	sedcmd=(sudo sed -i 's/user  nginx/user  $username/' /etc/nginx/nginx.conf)
	sedcmd[3]="s/user  nginx/user  $username/"
	$("${sedcmd[@]}")
else 
	echo "File ../nginx/nginx.conf not found"
fi

nginx -s reload

service nginx start

if [ -e ./miniserver.fcgi ]; then
	echo "File miniserver.fcgi found"
	rm -rf miniserver.fcgi
	if ! [ -e ./miniserver.fcgi ]; then
		echo "File miniserver.fcgi removed"
	fi
fi
echo "Start compiling miniserver.fcgi ..."
gcc -std=c11 -Wall -Werror -Wextra -o miniserver.fcgi mini_server.c -lfcgi
if [ -e ./miniserver.fcgi ]; then
	echo -e "Done! \nFile miniserver.fcgi exists\nStarting miniserver ..."
fi

spawn-fcgi -p 8080 -n miniserver.fcgi