Зад. 17 2016-SE-01 Напишете shell скрипт, който по подаден един позиционен параметър, ако този параметър
е директория, намира всички symlink-ове в нея и под-директориите ѝ с несъществуващ destination.

#!/bin/bash

[[ -d "${1}" ]] || { echo "wrong argument, not my problem" >&2; exit 2;}

broken=0

while read -r filename; do
var="$(basename "${filename}")"
   if [[ -L "$filename" ]]; then
   target=$(readlink "$filename")
   if [[ -e "$filename" ]]; then
       echo "$var -> $target"
   else
        echo "$var -> $target (broken)"
       ((broken++))
   fi
   fi
done < <(find "${1}" -maxdepth 1 -type l)

