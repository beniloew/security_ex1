org 100h

mov ax,3
mov bx,4

jmp calc_mod
mov dx,ax
mov ah,9
int 21h
mov ah,4Ch
int 21h

calc_mod:
	cmp ax,bx ; if ax < bx then return
	jb calc_mod_exit

calc_mod_loop:
	sub ax,bx
	jae calc_mod_loop

calc_mod_exit:
	ret
