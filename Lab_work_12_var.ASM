;Кудряшов Никита ПМИ-22БО
;Задание 12
format PE console
include 'win32ax.inc'

.data
; первые две это числа, остальные строки. Строки хранятся как указатель на первый символ строки
num dd 0
lenum DD 0
newChar db ' ', 0
endlinestr DB '', 10, 13, 0
endstr DB 'Press any key...',0


; Макрос вывода в консоль
macro outstr text,num
{
push STD_OUTPUT_HANDLE    ; в этой переменной будет хранится указатель на консоль для вывода
call [GetStdHandle]       ; вызываем процедуру, для получения указателя на консоль
                          ; дальше передаем аргументы для уже собственно вывода
push 0
push lenum                ; кол-во символов, которые по факту будут выведены (сюда запишится после работы процедуры)
push num                  ; кол-во символов, которые мы хотим вывести
push text                 ; символы для вывода
push eax
call [WriteConsole]       ; процедура, которая выводит в консоль
}

; Макрос считывания из консоли
macro instr text,num
{
push STD_INPUT_HANDLE   ; в этой переменной будет хранится указатель на консоль для считывания
call [GetStdHandle]
                        ; дальше передаем аргументы для уже собственно вывода
push 0
push lenum              ; кол-во символов, которые по факту будут считаны(сюда запишится после работы процедуры)
push num                ; кол-во символов, которые мы хотим считать
push text               ; переменная в которую запишется результат считывания
push eax
call [ReadConsole]      ; это процедура, которая считывает из консоли
}

; Программа стартует отсюда
.code
_start:
; наш главный цикл (мы постоянно прыгаем на метки, так циклы и работают)
mainloop:
instr newChar,1              ; считываем ОДИН символ из консоли (мы посимвольно читаем строку, потому что не знаем ее размера)

cmp [newChar],10            ; 10-сивол перехода на новую строку (энтер нажали). Поэтому как только мы его встретил - ввод закончился, прыгаем в конец
                            ; прыгаем мы на метки при помощи безусловных переходов (jmp), и условных (все остальные)

jz endmainloop

cmp [newChar],'a'           ; чтобы сравнивать значение переменной, ее нужно разименовать (квадратные скобки)

jb output
cmp [newChar],'z'
ja cmprussian1
sub [newChar],32           ; sub - вычитание из первого второго
jmp output

cmprussian1:               ; секция для первого участка русских букв
cmp [newChar],160
jb output
cmp [newChar],175
ja cmprussian2
sub [newChar],32
jmp output

cmprussian2:              ; секция для первого участка русских букв
cmp [newChar],224
jb output
cmp [newChar],239
ja cmprussian3
sub [newChar],80
jmp output

cmprussian3:
cmp [newChar],241
jnz output
sub [newChar],1
jmp output

output:
outstr newChar,1
jmp mainloop

endmainloop:
outstr endlinestr,2

outstr endstr,16         ; выводим сообщение о завершении работы проги

push STD_INPUT_HANDLE   ; magic-code чтобы консоль не закрывалась сразу (просто ждем нажатие любой клавиши - вызвали процедуру считывания одного символа)
call [GetStdHandle]
push 0
push eax
call [SetConsoleMode]
instr newChar,1

invoke ExitProcess,0   ; аналог "return 0"
.end _start