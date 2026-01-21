; VGA Text Mode Driver for CloudOS
; Provides basic VGA display functionality
; Author: Shivraj Suman

[bits 16]

; VGA Constants
VGA_WIDTH equ 80
VGA_HEIGHT equ 25
VGA_MEMORY equ 0xB8000

; Color constants
COLOR_BLACK equ 0x0
COLOR_BLUE equ 0x1
COLOR_GREEN equ 0x2
COLOR_CYAN equ 0x3
COLOR_RED equ 0x4
COLOR_MAGENTA equ 0x5
COLOR_BROWN equ 0x6
COLOR_LIGHT_GRAY equ 0x7
COLOR_DARK_GRAY equ 0x8
COLOR_LIGHT_BLUE equ 0x9
COLOR_LIGHT_GREEN equ 0xA
COLOR_LIGHT_CYAN equ 0xB
COLOR_LIGHT_RED equ 0xC
COLOR_LIGHT_MAGENTA equ 0xD
COLOR_YELLOW equ 0xE
COLOR_WHITE equ 0xF

; Function: vga_clear_screen
; Clears the entire VGA screen with a specific color
; Input: AL = background color
vga_clear_screen:
    push ax
    push cx
    push di
    push es
    
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ah, COLOR_BLACK
    mov al, ' '
    mov cx, VGA_WIDTH * VGA_HEIGHT
    rep stosw
    
    pop es
    pop di
    pop cx
    pop ax
    ret

; Function: vga_putchar
; Writes a character to VGA memory at current cursor position
; Input: AL = character, AH = attribute (color)
vga_putchar:
    push bx
    push es
    
    mov bx, 0xB800
    mov es, bx
    ; Additional implementation would go here
    
    pop es
    pop bx
    ret

; Function: vga_set_cursor
; Sets the hardware cursor position
; Input: DH = row, DL = column
vga_set_cursor:
    push ax
    push bx
    push dx
    
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    
    pop dx
    pop bx
    pop ax
    ret

; Function: vga_get_cursor
; Gets the current cursor position
; Output: DH = row, DL = column
vga_get_cursor:
    push ax
    push bx
    
    mov ah, 0x03
    mov bh, 0x00
    int 0x10
    
    pop bx
    pop ax
    ret
