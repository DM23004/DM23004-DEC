section .data
    msg db "Resultado: ", 0    ; Mensaje para imprimir antes del resultado
    newline db 10              ; Codigo ASCII para salto de linea

section .bss
    resultado resb 6           ; Buffer para resultado como texto (5 digitos + null)

section .text
    global _start

_start:
    ; --- Multiplicacion de dos numeros usando registros de 8 bits ---
    mov al, 5                 ; Cargar primer numero en AL (registro 8 bits)
    mov bl, 4                 ; Cargar segundo numero en BL (registro 8 bits)
    mul bl                    ; Multiplica AL * BL, resultado en AX (16 bits)

    ; Convertimos AX (16 bits) a EAX (32 bits) para preparar la impresion
    movzx eax, ax             ; Extiende AX a EAX llenando con ceros los bits altos

    ; --- Convertir el resultado en EAX a ASCII decimal ---
    mov edi, resultado        ; EDI apunta al inicio del buffer resultado
    add edi, 5                ; Apuntar al final del buffer para llenar hacia atras
    mov byte [edi], 0         ; Terminar cadena con null (0)

convertir:
    dec edi                   ; Retroceder una posicion para colocar digito
    xor edx, edx              ; Limpiar EDX (division usa EDX:EAX)
    mov ebx, 10               ; Divisor decimal para obtener digitos
    div ebx                   ; Dividir EAX entre 10, cociente en EAX, residuo en EDX
    add dl, '0'               ; Convertir residuo a caracter ASCII
    mov [edi], dl             ; Guardar digito ASCII en buffer
    test eax, eax             ; Verificar si el cociente es 0
    jnz convertir             ; Si no es 0, seguir dividiendo

    ; --- Imprimir mensaje "Resultado: " ---
    mov eax, 4                ; Codigo syscall para sys_write
    mov ebx, 1                ; Descriptor stdout
    mov ecx, msg              ; Mensaje a imprimir
    mov edx, 10               ; Longitud del mensaje
    int 0x80                  ; Llamar al kernel

    ; --- Imprimir numero convertido ---
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, edi              ; Inicio del numero ASCII convertido
    mov edx, resultado        ; Apuntar al buffer resultado
    add edx, 5                ; Fin del buffer
    sub edx, ecx              ; Calcular longitud del numero
    int 0x80                  ; Llamar al kernel

    ; --- Imprimir salto de linea ---
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, newline          ; Salto de linea
    mov edx, 1                ; Un caracter
    int 0x80                  ; Llamar al kernel

    ; --- Salir del programa ---
    mov eax, 1                ; Codigo syscall para exit
    xor ebx, ebx              ; Codigo de salida 0
    int 0x80                  ; Llamar al kernel para salir
