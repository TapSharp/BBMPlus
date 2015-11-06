#!/usr/bin/env bash
output_dir=$1
main_strings_file=$(dirname "${BASH_SOURCE[0]}")/strings.txt
strings_file=$(dirname "${BASH_SOURCE[0]}")/strings.temp.txt

cat $main_strings_file > $strings_file

# for i in $(find src/Extensions -name "*.strings"); do
# 	echo " "  >> $strings_file
#     cat "$i"  >> $strings_file
# done

languages=($(twine generate-report "$strings_file" | grep '^\w\+: \d\+$' | sed -E 's/: [[:digit:]]+$//g'))
for language in "${languages[@]}"; do
    mkdir "$output_dir/$language.lproj"
done
twine generate-all-string-files "$strings_file" "$output_dir"
rm $strings_file