#!/bin/sh

cp ./Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface ~/Desktop
rm -rf ./Movistar-sources/Mirada/libraries/library-iris-ios-components
hg pull -u
cp ~/Desktop/library-iris-ios-interface ./Movistar-sources/Mirada/libraries/library-iris-ios-components/lib