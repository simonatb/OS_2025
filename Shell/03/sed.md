### sed ###
Stream EDitor - чете текст, променя го по някакво
правило, и го извежда; има собствен език за изразяване на трансформации (изразите,
написани на този език, ще наричаме sed изрази)
- Най-често ще използваме трансформацията “замяна на текст”

```
$ echo 'the quick brown fox' | sed 's/quick/fast/'
the fast brown fox
```
- s from **S**ubstitute

### оператори при замяна ###
Операторът /g на края на израз за замяна кара замяната да се извърши за
всички срещания в рамките на всеки ред, а не само за първото:
```
$ echo 'quick, quick, quick!' | sed 's/quick/fast/'
fast, quick, quick!
$ echo 'quick, quick, quick!' | sed 's/quick/fast/g'
fast, fast, fast!
```
### екраниране и разделители ###
sed поддържа различни разделители, в случаите, в които искаме да
заменяме низове, съдържащи специални символи:

```
$ echo 'my home dir is /home/human' \
| sed 's:home/human:home/baba:g'
my home dir is /home/baba
```
Също така, можем да екранираме разделителя с \\:
```
$ echo 'my home dir is /home/human' \
| sed 's/home\/human/home\/baba/g'
my home dir is /home/baba
```

### regex ###
sed поддържа регулярни изрази и рефериране на групи (backreferences):
```
$ cat file
Parenthesis allow you to store matched
patterns.

$ cat file | sed -E 's/[^aouei]{2,}/_/g'
Pare_esi_a_o_ou_o_ore_a_ed
pa_e_

$ cat file | sed -E 's/(.)\1/\[\1\1\]/g'
Parenthesis a[ll]ow you to store matched
pa[tt]erns.
```
### inplace ###
Опцията -i на sed позволява да модифицираме файл in-place
```
sed -i 's/baba/dyado/g' foo.txt
  //заменя всички срещания на baba с dyado, презаписвайки foo.txt
sed -i 's/baba/dyado/g' /etc/*.conf
  //заменя всички срещания на baba с dyado, презаписвайки всички файлове в /etc, чиито имена
завършват с .conf
