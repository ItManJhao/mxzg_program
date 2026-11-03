#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
echo $basepath

protos_path=$basepath"/proto_file"
cd $protos_path

out_path=$basepath"/../client/idle/src/net/protos2/"
files=""

for file in ./*.proto
do
    if test -f $file
    then
    	echo $file

        files=$files" "$file
    fi
done

echo $files
echo $(pwd)
if [ ! -w "$out_path" ]; then
  mkdir "$out_path"
fi

protoc --lua_out=$out_path $files 