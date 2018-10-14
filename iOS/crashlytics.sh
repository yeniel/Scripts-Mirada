#!/bin/sh

find . -name "Crash*" | head -n 1 | xargs rm -r
cp -r ~/Google\ Drive/Proyectos/Iris\ iPhone/Frameworks/Crashlytics/Crashlytics.framework ./Movistar-sources/Mirada/Movistar/src/Movistar/
