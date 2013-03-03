org 100h

call calc_mod
mov ah,4Ch
int 21h

calc_mod:
	cmp ax,bx ; if ax < bx then return
	jb calc_mod_exit
	sub ax,bx
	jmp calc_mod

calc_mod_exit:
	ret
