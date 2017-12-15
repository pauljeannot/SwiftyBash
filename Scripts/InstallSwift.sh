#!/bin/bash

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
	DIR="$(pwd)"
	cd ..
	export SWIFT_VERSION=swift-4.0.2-RELEASE
    wget https://swift.org/builds/swift-4.0.2-release/ubuntu1404/${SWIFT_VERSION}/${SWIFT_VERSION}-ubuntu14.04.tar.gz
	tar xzf $SWIFT_VERSION-ubuntu16.04.tar.gz
	export PATH="${PWD}/${SWIFT_VERSION}-ubuntu16.04/usr/bin:${PATH}"
	cd "$DIR"
else
	export SWIFT_VERSION=swift-4.0.2-RELEASE
    curl -O https://swift.org/builds/swift-4.0.2-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg
	sudo installer -pkg ${SWIFT_VERSION}-osx.pkg -target /
	export TOOLCHAINS=swift
fi
