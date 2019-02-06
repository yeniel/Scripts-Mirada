
#!/bin/sh

defaultRepo="/Users/yeniel.landestoy/workspace/backups/product-iris-mobile/Iris/src"
inspireRepo="/Users/yeniel.landestoy/workspace/ios/product-iris-mobile/Iris/src"

cd $inspireRepo

files=$(find . -type f \( -iname \*.h -o -iname \*.m -o -iname \*.swift -o -iname \*.xib -o -iname \*.storyboard \) | xargs basename)

for fileName in $files; do
	cd $defaultRepo

	defaultFile=$(find . -iname $fileName)

	if [[ ! -z $defaultFile ]]
	then
		echo "Moving $defaultFile"

		filePath=$(dirname $defaultFile)

		cd $inspireRepo

		inspireFile=$(find . -iname $fileName)
		mkdir -p "$filePath/"

		hg mv $inspireFile "$filePath/"
	fi

done
