org 100h

calc_mod:
	cmp ax,bx ; if ax < bx then return
	jb calc_mod_exit

calc_mod_loop:
	sub ax,bx
	jae calc_mod_loop

calc_mod_exit:
	ret
