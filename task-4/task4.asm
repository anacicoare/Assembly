section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

section .data
	id_string dd 0
	print_string dd "string is %s", 10, 0
	print_int db "int is %d", 10, 0
	intel_vendor db "GenuineIntel"
	amd_vendor db "AuthenticAMD"

extern printf
extern strcat
extern strcmp
extern strstr

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	
	mov eax, 0
	pusha
	
	cpuid

	mov esi, [ebp + 8]
	mov dword [esi], ebx
	add esi, 4
	mov dword [esi], edx
	add esi, 4
	mov dword [esi], ecx
	add esi, 4
	mov byte [esi], 0

	popa
	leave
	ret

;; void features(int *apic, int *rdrand, int *mpx, int *svm)
;
;  checks whether apic, rdrand and mpx / svm are supported by the CPU
;  MPX should be checked only for Intel CPUs; otherwise, the mpx variable
;  should have the value -1
;  SVM should be checked only for AMD CPUs; otherwise, the svm variable
;  should have the value -1
features:
	enter 	0, 0

	; [ebp + 8] - apic
	; [ebp + 12] - rdrand
	; [ebp + 16] - mpx (only for intel!!!)
	; [ebp + 20] - svm (only for amd!!!)

	pusha
	
	; for apic
	
	mov dword eax, 1
	cpuid
	mov esi, [ebp + 8]
	; the 9th byte in edx represents whether or not we have apic	
	and edx, 512 ; get the 9th bit	
	shr edx, 9   ; divide it by 512
	mov dword [esi], edx

	; for rdrand
	
	mov dword eax, 1
	cpuid
	mov esi, [ebp + 12]
	mov edx, 1
	shl edx, 30 ; compute 2^30
	and ecx, edx
	shr ecx, 30
	mov dword [esi], ecx

	popa

	; now check for mpx (intel) and svm (amd)

	pusha 

	push id_string
	call cpu_manufact_id
	add esp, 4

	; found manufacturer id, now we check whether it is intel or amd

	push id_string
	push intel_vendor
	call strcmp
	add esp, 8

	cmp eax, 0
	je is_intel
	
is_intel:
	mov eax, 07h
	xor ecx, ecx
	cpuid
	; now 14th bit in ebx is whether it supports mpx or not
	mov edx, 1
	shl edx, 14 ; compute 2^14
	and ebx, edx
	shr ebx, 14
	mov esi, [ebp + 16]
	mov dword [esi], ebx
	jmp end_task

is_amd:
	mov eax, 1
	cpuid
	; now the 2nd bit in ecx is whether it supports mpx or not
	and ecx, 4
	shr ecx, 2
	mov esi, [ebp + 20]
	mov dword [esi], ecx

end_task:

	; now to find cache line

	popa


	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	
	pusha

	mov eax, 80000006H
	cpuid
	; the first 8 bits in ecx represent the cache size
	and ecx, 255
	mov esi, [ebp + 8]
	mov [esi], ecx

	popa


	leave
	ret
