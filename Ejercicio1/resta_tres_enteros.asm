section .data
    resultado_msg db "Resultado: ", 0 ; Cadena de texto para mostrar antes del numero
    newline db 10                     ; Salto de linea

section .bss
    resultado resb 6     ; Espacio para numero convertido a texto (5 digitos + null)

section .text
    global _start

_start:
    ; -------------------------
    ; Resta de tres enteros
    ; -------------------------
    ; Aqui usamos exclusivamente registros de 16 bits
    mov ax, 100       ; AX = 100 (primer numero)
    mov bx, 30        ; BX = 30  (segundo numero)
    mov cx, 20        ; CX = 20  (tercer numero)

    sub ax, bx        ; AX = 100 - 30 = 70
    sub ax, cx        ; AX = 70 - 20 = 50

    ; -------------------------
    ; Conversion para imprimir
    ; -------------------------
    ; A partir de aqui usamos registros de 32 bits (permitido para imprimir en Linux)
    ; Convertimos el resultado (AX, 16 bits) a EAX (32 bits)
    movzx eax, ax     ; EAX = valor en AX (50), con ceros en los bits superiores

    ; Apuntamos al final del buffer de salida
    mov edi, resultado
    add edi, 5         ; edi = direccion al final del buffer (ultimo byte)
    mov byte [edi], 0  ; Null terminator para el string

convertir:
    ; Este bucle convierte EAX (el numero) en ASCII decimal
    dec edi            ; Retroceder una posicion
    xor edx, edx       ; Limpiar EDX antes de dividir
    mov ebx, 10        ; Para dividir entre 10
    div ebx            ; EAX ÷ 10 → EAX = cociente, EDX = residuo
    add dl, '0'        ; Convertir digito a ASCII
    mov [edi], dl      ; Guardar caracter
    test eax, eax      ; ¿EAX == 0?
    jnz convertir      ; Si no, seguir dividiendo

    ; -------------------------
    ; Imprimir "Resultado: "
    ; -------------------------
    mov eax, 4         ; syscall: write
    mov ebx, 1         ; file descriptor: STDOUT
    mov ecx, resultado_msg
    mov edx, 10        ; longitud del mensaje
    int 0x80

    ; -------------------------
    ; Imprimir numero convertido
    ; -------------------------
    mov eax, 4         ; syscall: write
    mov ebx, 1         ; STDOUT
    mov ecx, edi       ; apuntamos al primer caracter del numero convertido
    mov edx, resultado
    add edx, 5         ; direccion del final del buffer
    sub edx, ecx       ; longitud = fin - inicio
    int 0x80

    ; -------------------------
    ; Imprimir salto de linea
    ; -------------------------
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; -------------------------
    ; Salida del programa
    ; -------------------------
    mov eax, 1         ; syscall: exit
    xor ebx, ebx       ; codigo de salida = 0
    int 0x80
