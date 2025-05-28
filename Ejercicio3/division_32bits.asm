section .data
    msg db "Resultado: ", 0
    newline db 10

section .bss
    resultado resb 11    ; Buffer para resultado (hasta 10 digitos + null)

section .text
    global _start

_start:
    ; --- Cargar los numeros (32 bits) ---
    mov eax, 100         ; Dividendo (32 bits)
    mov ebx, 8           ; Divisor  (32 bits)

    ; --- Preparar para division ---
    xor edx, edx         ; Limpiar EDX (parte alta del dividendo)
                         ; DIV usa EDX:EAX como dividendo de 64 bits

    div ebx              ; Divide EDX:EAX entre EBX
                         ; Cociente en EAX, resto en EDX

    ; --- Convertir cociente en EAX a ASCII ---
    mov edi, resultado
    add edi, 10          ; Apuntar al final del buffer
    mov byte [edi], 0    ; Terminar cadena con null

convertir:
    dec edi
    xor edx, edx
    mov ecx, 10
    div ecx              ; Dividir EAX entre 10, cociente en EAX, residuo en EDX
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz convertir

    ; --- Imprimir mensaje "Resultado: " ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 10
    int 0x80

    ; --- Imprimir numero convertido ---
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, resultado
    add edx, 10
    sub edx, ecx
    int 0x80

    ; --- Imprimir salto de linea ---
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; --- Salir del programa ---
    mov eax, 1
    xor ebx, ebx
    int 0x80
