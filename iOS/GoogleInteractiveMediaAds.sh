#!/bin/sh

FRAMEWORK_ORIGINAL_PATH=/Users/yeniel.landestoy/Google\ Drive/Proyectos/iOS/Frameworks
FRAMEWORK_PROJECT_PATH=/Users/yeniel.landestoy/workspace/ios/product-iris-mobile/Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface/lib/IMA

rm -rf "$FRAMEWORK_PROJECT_PATH"/GoogleInteractiveMediaAds.framework
unzip "$FRAMEWORK_ORIGINAL_PATH"/GoogleInteractiveMediaAds.framework -d "$FRAMEWORK_PROJECT_PATH"/
rm -rf "$FRAMEWORK_PROJECT_PATH"/__MACOSX
