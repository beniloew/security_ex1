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

is_prime:
	push bx
	push cx
	cmp ax,1
	jbe is_not_prime
	mov cx,ax ; save the original ax, because ax will be used as argument and ret value for calc_mod
	mov bx,ax ; bx - the counter, counts downwise
	sar bx,1 ; divide the counter by 2 - bigger numbers than that are'nt relevant
is_prime_loop:
	cmp bx,1
	je is_prime_indeed
	mov ax,cx
	call calc_mod
	cmp ax,0
	je is_prime_exit ; ax is 0 - that means that the original ax isn't a prime
	dec bx
	jmp is_prime_loop

is_prime_exit:
	pop cx
	pop bx
	ret

is_prime_indeed:
	mov ax,1
	jmp is_prime_exit

is_not_prime:
	mov ax,0
	jmp is_prime_exit
