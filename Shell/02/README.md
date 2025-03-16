# Find команда 
## Find \<target\> where | what | how - expression
### Where:
- mindepth - започва от
- maxdepth - завършва на
  find ~ -mindepth 2 -maxdepth 1 - нищо няма да върне
### What:
- type - вид на файла, който търсим
  - l \- symbolic link
  - d \- directory
  - f \- ordinary file
    - find ~ -type f,d == find ~ -type f -o -type d
-perm - permission
  - /222 - поне някое от тях трябва да е изпълнено
  - -222 - всяко от тях трябва да е изпълнено
  - 222 - трябва да е еднакво
- user
- group
- path
- newer
- name
  - \* - цяла дума
  - ? - само един символ
-atime - acessed time
-ctime - changed time
-mtime - modified time
-size
 - 40с - да е с големина 40 символа/байта
 - +40с - да е по-голям от 40 символа/байта
   - not - отрицание
- vim
### How - what to do with the files
- exec \<command\> '{}' ';'
- printf - приема формат
   - find ~ -type f -printf '%i/n'

