#!/bin/bash
# This script splits a big YAML files with '---' as delimiter.
# It saves the files to individual files in path $output_dir/$kind/$name.yaml
output_dir=split-yamls
kind=""
content=""
name=""
IFS=""
while read -r line
do
  if [ "---" = "$line" ]; then
    if [ "" != "$content" -a "" != "$kind" ]; then
       echo "Output $kind - $name to $output_dir/$kind/$name.yaml"
       echo -e $content > $output_dir/$kind/$name.yaml
       kind=""
       name=""
       content=""
    fi
  fi
if [ "" = "$content" ]; then
  content="${line}"
else
  content="${content}\n${line}"
fi
if [ "kind" = "$(echo $line | awk -F : '{print $1}')" ]; then
  kind="$(echo $line | awk '{print $2}')"
  mkdir -p $output_dir/$kind
fi
if [ "  name" = "$(echo $line | awk -F : '{print $1}')" ]; then
  name="$(echo $line | awk '{print $2}' | awk -F '"' '{print $2}')"
fi
done < "${1:-/dev/stdin}"