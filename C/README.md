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









