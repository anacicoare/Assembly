section .text
	global par

section .data
	print_int db "int is %d", 10, 0
	print_char db "char is %c", 10, 0
	print_string db "string is %s", 10, 0

global printf 

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	
	; suppose sequence is correct
	push dword 1
	pop eax
	
	; get the parameters of the function

	pop edi ; return address
	pop ecx ; parameter 1 (str_len)
	pop esi ; parameter 2 (the string)

	push esi
	push ecx
	push edi

	xor edx, edx ; nr. of paratheses that remain on stack

	; ascii 40 is for '(' and 41 for ')' 

check_parantheses:

	; if a new set of parantheses begins with ')'
	test edx, edx
	je first_element

	; now we are for sure not on the first element
	; and that means we can "pop" a parantheses

	cmp byte [esi], 40
	je open_parantheses
	jmp closed_parantheses

open_parantheses:
	inc esi
	inc edx
	jmp continue_loop

closed_parantheses:
	inc esi
	sub edx, 1
	jmp continue_loop

first_element:
	cmp byte [esi], 41
	je not_sequence 
	inc esi
	inc edx

continue_loop:
	loop check_parantheses

	; if this line executes then the loop completed and 
	; every parantheses had its pair 

	jmp is_sequence

not_sequence:
	push dword 0
	pop eax
	xor ecx, ecx

is_sequence:

	ret
