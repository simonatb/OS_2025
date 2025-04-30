### Имаме два варианта за типа на функцията main:
```
int main(void) {
// ...
}

int main(int argc, char* argv[]) {
// the program has argc number of arguments
// argv[0] is a pointer to the 0th argument
// (the executable path)
// argv[1] is a pointer to the 1st argument
// argv[2] is a pointer to the 2nd argument
// ...
}
```
### Exit status-ът на една програма е числото, върнато от функцията main:
```
int main(void) {
    return 42; // exit status 42
}
```

### Библиотеки:
- stdint.h - целочислени типове
- string.h - низове с терминираща нула
- glibc - syscall wrappers
- stdio.h - printf
- unistd.h - getuid,geteuid
- sys/types.h - uid_t
- fcntl.h - open
- err.h - err
- errno.h - errno

### Структури
Като отделен типов синоним
```
typedef struct {
char name[20];
uint8_t age;
} person_t;

person_t ivan;
```
Като запис в таблицата от структури
```
struct person{
char name[20];
uint8_t age;
};

struct person ivan;
```
Двете едновременно
```
struct person{
char name[20];
uint8_t age;
};
typedef struct person person_t;

struct person ivan;
person_t pesho;
```
### Динамична памет алокираме с malloc(3) и деалокираме с free(3) :
```
person_t* people = malloc(num_people * sizeof(person_t));
// ...
people[42].age = 26;
// ...
free(people);
```
## Системни извиквания 
Връзката между един процес и (ядрото на) операционната система се
извършва чрез операции, наречени системни извиквания (system calls
или syscalls)
# Syscall wrapper 
- Копира аргументите на системното извикване и неговия номер в
специфични процесорни регистри
- Изпълнява процесорна инструкция, която предизвиква хардуерно
прекъсване
- Вади резултата от въпросния процесорен регистър и го връща
```
int main(void) {
uid_t me = getuid();
uid_t pretending = geteuid();
printf("uid: %d euid: %d\n", me, pretending);
return 0; // exit status 0
}
```

### _exit() - прекратява изпълнението на процеса, независимо от текущата функция
### exit() - вътрешно вика _exit(2) , но финализира и някои други неща преди това (Използвайте нея, когато искате да прекратите програмата)

## Обработване на грешки при системни извиквания
- По конвенция, повечето системни извиквания връщат резултат от
числов тип, който е отрицателно число, ако извикването е било
неуспешно

### errno
при неуспех системните извиквания записват число (код на
грешка) в глобалната променлива errno; 
Можем да използваме errno, за да разберем каква е била грешката:
```
#include <fcntl.h> // open
#include <errno.h> // errno
#include <stdlib.h> // exit

int main() {
int result = open("/tmp/some_file", O_RDONLY);
if (result < 0) {
switch (errno) {
case 2: tell_user("no such file\n"); break; // 2 -ENOENT
case 13: tell_user("permission denied\n"); break; // 13 - EACCES
// ...
  }
exit(1);
}

tell_user("opened /tmp/some_file successfully\n");
}
```
### err.h

Ако просто искаме да изведем съобщение за грешка до потребителя и да
прекратим програмата, най-добре е да използваме функцията err() от
err(3) , която изписва форматирано съобщение за грешка (вътрешно гледа
променливата errno).
Първият аргумент на err() е exit status, с който да прекрати програмата.
```
#include <fcntl.h> // open
#include <err.h> // err

int main() {
int result = open("/tmp/some_file", O_RDONLY);
if (result < 0) {
err(1, "could not open file");
}

tell_user("opened /tmp/some_file successfully\n");
}
```
Всъщност, err.h задава 4 полезни функции, изписващи съобщение на
stderr. Всички варианти са полезни:
- void err(int eval, const char* fmt, ...)
   - изписва грешката от errno
   - прекратява програмата с подадения статус
- void errx(int eval, const char* fmt, ...)
   - не изписва грешката от errno
   - прекратява програмата с подадения статус
- void warn(const char* fmt, ...)
   - изписва грешката от errno
   - не прекратява програмата
- void warnx(const char* fmt, ...)
   - не изписва грешката от errno
   - не прекратява програмата

## Файлови дескриптори
- За да работим с файл, трябва да го отворим – това става със системното
извикване open(); open() връща число, което е номер на файлов дескриптор;
При отваряне на файл, ядрото създава системна структура, наречена
файлов дескриптор, която съдържа:
   - Указател към самия файл
   - Текуща позиция (индекс на байт) във файла
   - И други
- За всеки процес ядрото алокира таблица от файлови дескриптори:
номерът на файлов дескриптор, върнат от open(), е индекс в тази таблица.

### open() може да приема 2 или 3 аргумента:
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);

flags:
- O_WRONLY, O_RDONLY - отваряне за писане или за четене
- O_RDWR - отваряне за четене и писане едновременно
- O_CREAT - ако файлът не съществува, го създава преди да го отвори
- O_TRUNC - ако файлът съществува, зачиства съдържанието му преди да го отвори
- O_APPEND - ако файлът съществува, началната позиция е в края му вместо в началото
mode (only with O_CREAT):


