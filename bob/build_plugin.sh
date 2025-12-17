#!/usr/bin/env bash


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	PLATFORM=x86_64-linux
	BUILDDIR=x86_64-linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
	PLATFORM=x86_64-darwin
	BUILDDIR=x86_64-osx
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
	PLATFORM=x86_64-win32
	BUILDDIR=x86_64-win32
else
	echo "Unknown host OS $OSTYPE"
	exit 1
fi
echo ${PLATFORM}
cd ../
java -jar bob/bob.jar --platform=${PLATFORM} --verbose --build-artifacts=plugins clean build

cp build/${BUILDDIR}/resourceencryption/pluginCustomResourceEncryption.jar native/resourceencryption/plugins/share
cp build/${BUILDDIR}/prometheus/pluginPrometheus.jar native/prometheus/plugins/share