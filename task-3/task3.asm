global get_words
global compare_func
global sort

section .data
    delimiters db " .,!?", 10

extern printf
extern strtok
extern strlen
extern strcmp
extern qsort

section .text

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix

; the compare functions used by qsort
compare_function:
    enter 0,0

    pusha

    mov eax, [ebp + 8] ; 1st number
    mov eax, [eax]

    ; compute 1st word's lenght

    push eax
    call strlen
    add esp, 4

    push eax ; now we have the 1st word's len on stack

    mov eax, [ebp + 12] ; 2nd number
    mov eax, [eax]

    ; compute 2nd word's len

    push eax
    call strlen
    add esp, 4

    push eax ; 2nd word's len on stack

    pop eax ; 2nd word's len
    pop ecx ; 1st word's len

    sub ecx, eax
    mov eax, ecx

    test eax, eax
    jnz finally

    ; if this part below executes, then the words have the same len
    ; and we have to use strcmp to sort them

    ; get the strings
    mov eax, [ebp + 8]
    mov eax, [eax]
    mov ecx, [ebp + 12]
    mov ecx, [ecx]

    push ecx
    push eax
    call strcmp
    add esp, 8

finally:

    popa

    leave

    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix

sort:
    enter 0, 0

    pusha

    push ebx
    push edi
    push esi

    mov edx, [ebp + 8] ; 1st param
    mov eax, [ebp + 12] ; 2nd param
    mov ecx, [ebp + 16] ; 3rd param

    push compare_function
    push ecx
    push eax
    push edx
    call qsort
    add esp, 16

    pop esi
    pop edi
    pop ebx

    popa

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
;  max word len = 100

get_words:
    enter 0, 0

    pusha

    mov eax, [ebp + 8]  ; beginning address of the string

    ; begin string separation into words 
    ; next line is like "char *p = strtok(s, delimiters)"
   
    push delimiters
    push eax
    call strtok
    add esp, 8

    ; now we have the first word in eax
    ; and will put in in the array of words
    
    mov edx, [ebp + 12] ; beginning address of char** words

    push ebx    ; save it so the task does not crash

    xor ebx, ebx
    mov [edx], eax
    inc ebx

separate_string:

    ; next line is equivalent to "p = strtok(NULL, delimiters)"

    push delimiters
    push 0
    call strtok
    add esp, 8

    ; proceed with putting the result in the array
    mov edx, [ebp + 12]
    mov [edx + 4 * ebx], eax

    inc ebx

    ; if done the specified number of words then exit
    mov ecx, [ebp + 16]
    cmp ebx, ecx
    je exit_loop

    jmp separate_string

exit_loop:

    popa

    leave
    ret
