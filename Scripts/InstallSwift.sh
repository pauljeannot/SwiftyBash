#!/bin/bash

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
	DIR="$(pwd)"
	cd ..
	export SWIFT_VERSION=swift-4.1
    wget https://swift.org/builds/${SWIFT_VERSION}-release/ubuntu1604/${SWIFT_VERSION}-RELEASE/${SWIFT_VERSION}-RELEASE-ubuntu16.04.tar.gz
	tar xzf $SWIFT_VERSION-RELEASE-ubuntu16.04.tar.gz
	export PATH="${PWD}/${SWIFT_VERSION}-RELEASE-ubuntu16.04/usr/bin:${PATH}"
	cd "$DIR"
else
	export SWIFT_VERSION=swift-4.0.3
    curl -O https://swift.org/builds/${SWIFT_VERSION}-release/xcode/${SWIFT_VERSION}-RELEASE/${SWIFT_VERSION}-RELEASE-osx.pkg
	sudo installer -pkg ${SWIFT_VERSION}-RELEASE-osx.pkg -target /
	export TOOLCHAINS=swift
fi
