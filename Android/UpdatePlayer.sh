#!/bin/sh

echo "Remove zip folder"
rm -rf zip/*

echo "Unzip NexPlayer"
unzip -q $1 -d zip

echo "Copy assets folder"
cp -R zip/Sample/NexPlayerSample_for_Android/assets/* ~/workspace/android/product-iris-android-inspire/library-3rd-android-nexplayer/src/main/assets

echo "Copy libs folder"
cp -R zip/Sample/NexPlayerSample_for_Android/libs/* ~/workspace/android/product-iris-android-inspire/library-3rd-android-nexplayer/src/main/jniLibs

echo "Copy nexplayerengine folder"
cp -R zip/Sample/NexPlayerSample_for_Android/src/com/nexstreaming/nexplayerengine/* ~/workspace/android/product-iris-android-inspire/library-3rd-android-nexplayer/src/main/java/com/nexstreaming/nexplayerengine

