section .text
	global cmmmc

section .data
    format_edx dd "edx is %d", 10, 10, 0
	format_eax dd "%d",0
	format_ecx dd "ecx is %d\n", 10, 10, 0

extern printf

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b

cmmmc:

	pop esi ; return address
	pop eax ; 1st argument
	pop ecx ; 2nd argument

	; now put them back
	push ecx
	push eax
	push esi

find_gcd:

	cmp ecx, 0 ; compare divider with 0, if true then the cycle ends
	je found_gcd

	xor edx, edx
	div ecx

	; do mov eax, ecx

	push ecx
	pop eax

	; do mov ecx, edx

	push edx
	pop ecx

	jmp find_gcd

found_gcd:

	; gcd is stored in eax

	push eax
	pop esi
	
	; gcd is stored in esi now

	pop edi ; ret address
	pop ecx ; 1st nr
	pop eax ; 2nd nr

	push eax
	push ecx
	push edi

	; do a * b / gcd to find hcf

	mul ecx
	div esi

	ret
