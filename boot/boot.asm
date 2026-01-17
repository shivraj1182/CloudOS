; Simple bootloader for CloudOS
; Loads at 0x7C00 and prints a boot message

[org 0x7C00]
[bits 16]

start:
    ; Clear screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    
    ; Print boot message
    mov si, boot_msg
    call print_string
    
    ; Load kernel message
    mov si, kernel_msg
    call print_string
    
    ; Hang system
    jmp $

; Function to print string
print_string:
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

boot_msg db 'CloudOS Bootloader v0.1', 0x0D, 0x0A, 0
kernel_msg db 'Loading kernel...', 0x0D, 0x0A, 0

; Boot signature
times 510-($-$$) db 0
dw 0xAA55
