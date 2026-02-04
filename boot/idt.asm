; ========================================
; Interrupt Descriptor Table (IDT) for CloudOS
; ========================================
; This module provides interrupt handling capabilities
; Essential for keyboard input, timers, and exception handling

[bits 32]

section .data

; IDT structure - 256 entries, each 8 bytes
IDT_SIZE equ 256 * 8

idt_start:
    times IDT_SIZE db 0
idt_end:

idt_descriptor:
    dw IDT_SIZE - 1        ; IDT limit (size - 1)
    dd idt_start           ; IDT base address

section .text

global idt_init
global idt_set_gate

; ========================================
; Initialize the IDT
; Sets up basic exception handlers
; ========================================
idt_init:
    push ebp
    mov ebp, esp
    pushad

    ; Load IDT descriptor
    lidt [idt_descriptor]

    ; Set up basic exception handlers (0-31)
    ; Division by zero (INT 0)
    push 0x08           ; Kernel code segment
    push exception_0    ; Handler address
    push 0              ; Interrupt number
    call idt_set_gate
    add esp, 12

    ; General Protection Fault (INT 13)
    push 0x08
    push exception_13
    push 13
    call idt_set_gate
    add esp, 12

    ; Page Fault (INT 14)
    push 0x08
    push exception_14
    push 14
    call idt_set_gate
    add esp, 12

    popad
    mov esp, ebp
    pop ebp
    ret

; ========================================
; Set an IDT gate
; Parameters (pushed on stack):
;   - interrupt number (0-255)
;   - handler address
;   - selector (code segment)
; ========================================
idt_set_gate:
    push ebp
    mov ebp, esp
    pushad

    mov eax, [ebp + 8]     ; Interrupt number
    mov ebx, [ebp + 12]    ; Handler address
    mov cx, [ebp + 16]     ; Code segment selector

    ; Calculate IDT entry address
    shl eax, 3             ; Multiply by 8 (each entry is 8 bytes)
    add eax, idt_start

    ; Set low 16 bits of handler address
    mov word [eax], bx

    ; Set segment selector
    mov word [eax + 2], cx

    ; Set flags: Present, DPL=0, 32-bit interrupt gate
    mov byte [eax + 5], 0x8E

    ; Set high 16 bits of handler address
    shr ebx, 16
    mov word [eax + 6], bx

    popad
    mov esp, ebp
    pop ebp
    ret

; ========================================
; Exception Handlers
; ========================================

exception_0:
    push 0              ; Error code (dummy)
    push 0              ; Exception number
    jmp exception_handler

exception_13:
    ; Error code already pushed by CPU
    push 13
    jmp exception_handler

exception_14:
    ; Error code already pushed by CPU
    push 14
    jmp exception_handler

; Generic exception handler
exception_handler:
    pushad
    
    ; Get exception number from stack
    mov eax, [esp + 32]    ; Exception number
    
    ; Display error message (requires VGA driver)
    ; For now, just halt
    
    popad
    add esp, 8             ; Remove error code and exception number
    iret                   ; Return from interrupt

; ========================================
; Interrupt Request Handlers (IRQs)
; These will be expanded for hardware interrupts
; ========================================

global irq0_handler
global irq1_handler

; Timer interrupt (IRQ0)
irq0_handler:
    push eax
    push ebx
    
    ; Send End of Interrupt (EOI) to PIC
    mov al, 0x20
    out 0x20, al
    
    pop ebx
    pop eax
    iret

; Keyboard interrupt (IRQ1)
irq1_handler:
    push eax
    push ebx
    
    ; Read keyboard scancode
    in al, 0x60
    ; Process scancode (to be implemented)
    
    ; Send EOI
    mov al, 0x20
    out 0x20, al
    
    pop ebx
    pop eax
    iret
