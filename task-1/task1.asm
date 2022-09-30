section .text
	global sort



; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list



sort:
	enter 0, 0
    
    mov ecx, [ebp + 8] ; number of nodes
    
    xor edx, edx ; here we will store the beginning address
   
    xor esi, esi ; here we will store the address of the prev linked element
                 ; init with 0 so we know who is first element
    
    xor edi, edi ; element to search for and link the prev one to it

; while not all nodes have been tested
sort_nodes: 
    inc edi ; pass to next element

    mov edx, [ebp + 12] 

    ; now we have the beginning of the array in edx
    ; and we search for element equal to edi in the whole array

search_element:
    cmp [edx], edi
    je found_element
    jmp find_next ; if not found then we search the next address

found_element:
    cmp esi, 0 ; check if esi is uninitialised
    je found_first_element

    ; we have found an element that is not the first
    ; so we link it 

    add esi, 4 ; go to pointer (struct node*) in the prev node
    mov [esi], edx ; make it point to current node
    mov esi, edx ; and remember it as the prev node's address

    jmp done_link

found_first_element:
    mov eax, edx ; address to return 
    mov esi, edx ; remember it as the next's prev elem address
    jmp done_link

find_next:
    add edx, 8 
    jmp search_element

done_link:

loop sort_nodes

	leave
	ret
