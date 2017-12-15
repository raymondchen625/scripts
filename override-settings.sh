#!/bin/bash
# Reads file from current folder and use the settings to 
# replace the ones in the files with the same name in parent folder.
# e.g. if we have setting_a=value_a in file_a.txt in current file, 
# it will look for line which matches "setting_a=" in the 'file_a.txt'
# in parent folder .., and replace the line with 'setting_a=value_a'
# 
IFS=$'\n'
for f in `ls` ; do
	echo -e "\e[35m######## $f \e[0m";
	if [ ! -f ../$f ] ; then
		echo -e "\e[31mFAILURE: ../$f doesn't exist!\e[0m"
	else
		for line in $(cat < "$f"); do
			n=$(echo $line | cut -f1 -d=)
			v=$(echo $line | cut -f2- -d=)
			grep -q $n ../$f
			if [ "$?" == 1 ]; then
				echo -e "\e[31mFAILURE: $line \e[0m"
			else
				# Replace one \ with three \ to get it right
				sedLine=$(echo $line | sed 's/\\/\\\\\\/g')
				sedStr="s/$n=.*/$sedLine/g"
				sed -i "$sedStr" ../$f
				echo -e "\e[32mSUCCESS: $line \e[0m"
			fi
		done
	fi
done
