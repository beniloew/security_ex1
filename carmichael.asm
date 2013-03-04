org 100h

mov ax,[test_val]
call is_carmichael
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

is_carmichael:
	pusha
	cmp ax,1
	jbe is_not_carmichael_exit
	mov dx,ax ; save the original ax
	call is_prime
	cmp ax,1
	je is_not_carmichael_exit ; prime number cannot be a carmichael number
	mov ax,dx ; restore after prime check
	mov cx,2
	mov bx,ax
	sar bx,1 ; we will check dividers till bx(ax / 2), no sense to check further
is_carmichael_loop:
	mov ax,cx
	call is_prime
	cmp ax,0
	je is_carmichael_loop_step
	mov ax,dx
	call korselts_divider_check
	cmp ax,0
	je is_not_carmichael_exit

is_carmichael_loop_step:
	inc cx
	cmp cx,bx
	jbe is_carmichael_loop

; is_carmichael_exit ; (label not needed)
	popa
	mov ax,1
	ret

is_not_carmichael_exit:
	popa
	mov ax,0
	ret


; This function checks a single prime diviser against the korselts criterion ;
; ax & dx - the number checked against, cx - the prime divider				 ;
; returns 1 in ax if passed the test, 0 otherwise							 ;
korselts_divider_check:
	push bx ; we will use bx in this function - so save it
	mov bx,cx
	call calc_mod
	cmp ax,0 ; equal if cx is a divisor of ax
	jne korselts_divider_passed

	mov ax,dx ; restore original ax
 	push dx ; we will change dx for dividing - so save it
	xor dx,dx ; need to reset dx for proper dividing
	div cx
	pop dx

	call calc_mod
	cmp ax,0 ; equal if cx is a square divisor of ax
	je korselts_divider_failed
	mov ax,dx
	dec ax
	mov bx,cx
	dec bx
	call calc_mod
	cmp ax,0
	jne korselts_divider_failed

korselts_divider_passed:
	mov ax,1
	pop bx
	ret

korselts_divider_failed:
	mov ax,0
	pop bx
	ret

test_val dw 1729
