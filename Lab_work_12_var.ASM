;�������� ������ ���-22��
;������� 12
format PE console
include 'win32ax.inc'

.data
; ������ ��� ��� �����, ��������� ������. ������ �������� ��� ��������� �� ������ ������ ������
num dd 0
lenum DD 0
newChar db ' ', 0
endlinestr DB '', 10, 13, 0
endstr DB 'Press any key...',0


; ������ ������ � �������
macro outstr text,num
{
push STD_OUTPUT_HANDLE    ; � ���� ���������� ����� �������� ��������� �� ������� ��� ������
call [GetStdHandle]       ; �������� ���������, ��� ��������� ��������� �� �������
                          ; ������ �������� ��������� ��� ��� ���������� ������
push 0
push lenum                ; ���-�� ��������, ������� �� ����� ����� �������� (���� ��������� ����� ������ ���������)
push num                  ; ���-�� ��������, ������� �� ����� �������
push text                 ; ������� ��� ������
push eax
call [WriteConsole]       ; ���������, ������� ������� � �������
}

; ������ ���������� �� �������
macro instr text,num
{
push STD_INPUT_HANDLE   ; � ���� ���������� ����� �������� ��������� �� ������� ��� ����������
call [GetStdHandle]
                        ; ������ �������� ��������� ��� ��� ���������� ������
push 0
push lenum              ; ���-�� ��������, ������� �� ����� ����� �������(���� ��������� ����� ������ ���������)
push num                ; ���-�� ��������, ������� �� ����� �������
push text               ; ���������� � ������� ��������� ��������� ����������
push eax
call [ReadConsole]      ; ��� ���������, ������� ��������� �� �������
}

; ��������� �������� ������
.code
_start:
; ��� ������� ���� (�� ��������� ������� �� �����, ��� ����� � ��������)
mainloop:
instr newChar,1              ; ��������� ���� ������ �� ������� (�� ����������� ������ ������, ������ ��� �� ����� �� �������)

cmp [newChar],10            ; 10-����� �������� �� ����� ������ (����� ������). ������� ��� ������ �� ��� �������� - ���� ����������, ������� � �����
                            ; ������� �� �� ����� ��� ������ ����������� ��������� (jmp), � �������� (��� ���������)

jz endmainloop

cmp [newChar],'a'           ; ����� ���������� �������� ����������, �� ����� ������������ (���������� ������)

jb output
cmp [newChar],'z'
ja cmprussian1
sub [newChar],32           ; sub - ��������� �� ������� �������
jmp output

cmprussian1:               ; ������ ��� ������� ������� ������� ����
cmp [newChar],160
jb output
cmp [newChar],175
ja cmprussian2
sub [newChar],32
jmp output

cmprussian2:              ; ������ ��� ������� ������� ������� ����
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

outstr endstr,16         ; ������� ��������� � ���������� ������ �����

push STD_INPUT_HANDLE   ; magic-code ����� ������� �� ����������� ����� (������ ���� ������� ����� ������� - ������� ��������� ���������� ������ �������)
call [GetStdHandle]
push 0
push eax
call [SetConsoleMode]
instr newChar,1

invoke ExitProcess,0   ; ������ "return 0"
.end _start