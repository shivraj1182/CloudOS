; Memory Management Module for CloudOS
; Optimized for low RAM devices (128MB or less)
; Provides basic memory detection and management

[bits 16]

; Memory constants for low RAM optimization
MEM_DETECT_SUCCESS equ 0
MEM_DETECT_FAIL equ 1
LOW_MEM_THRESHOLD equ 0xA0000    ; 640KB conventional memory
EXTENDED_MEM_START equ 0x100000  ; 1MB mark

; Memory map entry structure (E820)
struc E820Entry
    .base_addr: resq 1    ; Base address
    .length: resq 1       ; Length of memory region
    .type: resd 1         ; Type (1=usable, 2=reserved)
    .acpi: resd 1         ; ACPI attributes
endstruc

; Function: detect_memory
; Detects available system memory using BIOS INT 0x15, E820
; Optimized for systems with limited RAM
; Output: AX = 0 on success, 1 on failure
detect_memory:
    push es
    push di
    push ebx
    
    xor ebx, ebx          ; EBX must be 0 to start
    mov di, 0x8000        ; Destination for memory map
    
.detect_loop:
    mov eax, 0xE820       ; E820 function
    mov ecx, 24           ; Size of entry
    mov edx, 0x534D4150   ; 'SMAP' signature
    int 0x15
    
    jc .detect_fail       ; If carry, detection failed
    
    cmp eax, 0x534D4150   ; Check signature
    jne .detect_fail
    
    ; Entry retrieved successfully
    add di, 24            ; Move to next entry
    
    test ebx, ebx         ; Check if more entries
    jnz .detect_loop
    
    ; Success
    mov ax, MEM_DETECT_SUCCESS
    jmp .done
    
.detect_fail:
    mov ax, MEM_DETECT_FAIL
    
.done:
    pop ebx
    pop di
    pop es
    ret

; Function: get_low_memory
; Gets conventional memory size (below 1MB)
; Output: AX = memory size in KB
get_low_memory:
    push bx
    
    ; Use BIOS INT 0x12 to get conventional memory
    int 0x12
    ; AX now contains memory size in KB
    
    pop bx
    ret

; Function: get_extended_memory
; Gets extended memory size (above 1MB)
; Output: AX = extended memory in KB (may be 0 if < 16MB)
get_extended_memory:
    push bx
    push cx
    
    ; Try INT 0x15, AX=0xE801 first (more accurate)
    mov ax, 0xE801
    int 0x15
    jc .try_legacy
    
    ; Success: AX = memory 1-16MB in 1KB blocks
    ; BX = memory above 16MB in 64KB blocks
    jmp .done
    
.try_legacy:
    ; Fallback to INT 0x15, AH=0x88 (legacy method)
    mov ah, 0x88
    int 0x15
    ; AX now contains extended memory in KB
    
.done:
    pop cx
    pop bx
    ret

; Function: optimize_for_low_ram
; Sets up memory management for devices with 128MB or less
; Minimizes memory footprint
optimize_for_low_ram:
    push ax
    push bx
    
    ; Detect memory first
    call detect_memory
    cmp ax, MEM_DETECT_SUCCESS
    jne .optimization_done
    
    ; Get low memory
    call get_low_memory
    ; AX contains KB, check if < 640KB
    cmp ax, 640
    jl .very_low_memory
    
    ; Get extended memory
    call get_extended_memory
    
    ; Check if total is under 128MB (131072 KB)
    ; For now, just proceed with optimization
    
.very_low_memory:
    ; Enable aggressive memory optimization
    ; Reduce buffer sizes, minimize heap
    
.optimization_done:
    pop bx
    pop ax
    ret

; Function: check_available_memory
; Quickly checks if system has minimum required memory
; Output: AX = 1 if sufficient, 0 if insufficient
check_available_memory:
    push bx
    
    call get_low_memory
    ; Check for at least 512KB conventional memory
    cmp ax, 512
    jl .insufficient
    
    ; Sufficient memory
    mov ax, 1
    jmp .done
    
.insufficient:
    mov ax, 0
    
.done:
    pop bx
    ret

; Memory status messages
mem_sufficient_msg db 'Memory check: OK', 0x0D, 0x0A, 0
mem_low_msg db 'Warning: Low memory detected', 0x0D, 0x0A, 0
mem_critical_msg db 'Critical: Insufficient memory', 0x0D, 0x0A, 0
