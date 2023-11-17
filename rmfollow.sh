#!/bin/sh

deleteEmptyDirs(){

cd "$1"

cd ..

	if [ "$(find "$1" -mindepth 1)" = "" ]; then
		printf "Deleting empty directory: $1\n"
		rmdir "$1"
		deleteEmptyDirs "$PWD"
	fi

}

rmfollow(){

	if [ -L "$1" ]; then
		thepwd="$PWD"
		i="$(readlink "$1")"

		cd "$(dirname $1)"

		todelete="$(realpath -s "$i")"

		cd "$thepwd"

		printf "Deleting $1\n"

		tocheck="$(dirname "$1")"

		rm -f "$1"

		thepwd="$PWD"
		if [ -d "$1" ]; then
			deleteEmptyDirs "$(realpath "$1")"
		else
			deleteEmptyDirs "$(dirname "$1")"
		fi
		cd "$thepwd"

		rmfollow "$todelete"


	elif [ -f "$1" ]; then
		printf "Deleting $1\n"

		tocheck="$(dirname "$1")"

		rm -f "$1"

		thepwd="$PWD"
		if [ -d "$1" ]; then
			deleteEmptyDirs "$(realpath "$1")"
		else
			deleteEmptyDirs "$(dirname "$1")"
		fi

		cd "$thepwd"
	fi
}

rmfollow "$(realpath -s "$1")"