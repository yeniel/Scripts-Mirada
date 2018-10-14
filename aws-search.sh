#!/bin/sh

# Examples

# ./aws-search.sh EPSD0447262360003665 201802061103 201802061106 izzi

echo "\n"

if [ -z "$1" ]; then
    echo "Falta la cadena a buscar"
    exit
fi

if [ -z "$2" ]; then
    echo "Falta la fecha de inicio"
    exit
fi

if [ -z "$3" ]; then
    echo "Falta la fecha de fin"
    exit
fi

if [ -z "$4" ]; then
    S3_URL=tvmetrix-televisa
    PROFILE=mirada
else
    PROFILE=$4
    S3_URL=izzitelecom
fi

##### Parameters

stringToSearch=$1
start=$2
end=$3

##### Constants

AWS_FOLDER=~/workspace/backups/aws

##### Variables

s3Path=$(date -j -f "%Y%m%d%H%M" $start +'%Y-%m-%d/%H/')


rm -rf $AWS_FOLDER/*

echo "aws s3 ls s3://$S3_URL/raw/$s3Path --profile $PROFILE"

files=$(aws s3 ls s3://$S3_URL/raw/$s3Path --profile $PROFILE | awk '{ print $4; }' | cut -d"_" -f1 | sort)

include="--exclude '*'"
firstFileBeforeStart=""
firstFileAfterEndIncluded=false
firstFileBeforeStartIncluded=false

for file in $files; do
    if [[ "$file" -ge $start && "$file" -le $end ]]; then
        if [[ $include != *"$file"* ]]; then
            include="$include --include '$file*'"
        fi

        if [ "$firstFileBeforeStartIncluded" = false ]; then
            firstFileBeforeStartIncluded=true
            include="$include --include '$firstFileBeforeStart*'"
        fi

        firstFileAfterEndIncluded=true
    elif [ "$firstFileAfterEndIncluded" = true ]; then
        firstFileAfterEndIncluded=false
        include="$include --include '$file*'"
    else
        firstFileBeforeStart=$file
    fi

done

awsSync="aws s3 sync s3://$S3_URL/raw/$s3Path $AWS_FOLDER $include --profile $PROFILE --quiet"
echo $awsSync
eval "$awsSync"

gunzip $AWS_FOLDER/*.gz --quiet

grep -h $stringToSearch $AWS_FOLDER/*.json | while read -r line ; do
    echo "\n\n$line"
done

echo "\n"
