Даден е текстов файл с име philip-j-fry.txt. Напишете shell script и/или серия от команди, които извеждат броя редове, съдържащи поне една четна цифра и несъдържащи малка латинска
буква от a до w.

count=$(grep -E '[02468]' philip-j-fry.txt | grep -Ev '[a-w]' | wc -l)
echo "$count"
