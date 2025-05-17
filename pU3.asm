.286
pila segment stack
    db 32 DUP('stack--')  ; Reserva 32 bytes para la pila
pila ends

datos segment
    ; Mensajes para el men?
    titulo db 13,10,'=== MENU DE PIRAMIDES ===','$'
    opcion1 db 13,10,'1. Piramide Normal (Hacia Arriba)','$'
    opcion2 db 13,10,'2. Piramide Hacia Abajo','$'
    opcion3 db 13,10,'3. Piramide Izquierda','$'
    opcion4 db 13,10,'4. Piramide Derecha','$'
    opcion5 db 13,10,'5. Salir','$'
    prompt db 13,10,'Seleccione una opcion (1-5): ','$'
    continuar db 'Presione Enter para continuar...','$'
    error db 13,10,'Opcion invalida, intente de nuevo.','$'
    salto_linea db 13,10,'$'
    seleccion db ?  ; Variable para almacenar la opci?n del usuario
    var dw ?        ; Variable para preservar CX
datos ends

codigo segment 'code'
    ; Macro para posicionar el cursor en la pantalla
    POSICIONAR_CURSOR MACRO fila, columna
        mov ah, 02h        ; Funci?n para posicionar cursor
        mov bh, 00h        ; P?gina de video 0
        mov dh, fila       ; Fila
        mov dl, columna    ; Columna
        int 10h            ; Interrupci?n de video
    ENDM

    ; Macro para imprimir un car?cter en la pantalla
    IMPRIMIR_CARACTER MACRO caracter, cantidad
        mov ah, 0Ah        ; Funci?n para escribir car?cter
        mov al, caracter   ; Car?cter a imprimir
        mov cx, cantidad   ; N?mero de veces a repetir
        int 10h            ; Interrupci?n de video
    ENDM

    main proc far
    assume ss:pila, ds:datos, cs:codigo
    
    ; Configurar segmento de datos
    push ds
    push 0
    mov ax, datos
    mov ds, ax
    
menu_principal:
    ; Limpiar pantalla
    call limpiar_pantalla
    
    ; Mostrar men?
    call mostrar_menu
    
    ; Leer opci?n del usuario
    mov ah, 01h        ; Funci?n para leer car?cter
    int 21h
    mov seleccion, al  ; Guardar opci?n
    
    ; Comparar opci?n y saltar al procedimiento correspondiente
    cmp seleccion, '1'
    je piramide_arriba
    cmp seleccion, '2'
    je piramide_abajo
    cmp seleccion, '3'
    je piramide_izquierda
    cmp seleccion, '4'
    je piramide_derecha
    cmp seleccion, '5'
    je salir
    jmp opcion_invalida
    
piramide_arriba:
    call dibujar_piramide_arriba
    jmp esperar_continuar
    
piramide_abajo:
    call dibujar_piramide_abajo
    jmp esperar_continuar
    
piramide_izquierda:
    call dibujar_piramide_izquierda
    jmp esperar_continuar
    
piramide_derecha:
    call dibujar_piramide_derecha
    jmp esperar_continuar
    
opcion_invalida:
    mov ah, 09h
    lea dx, error
    int 21h
    jmp esperar_continuar
    
esperar_continuar:
    ; Posicionar cursor en una fila segura para evitar sobreposici?n
    POSICIONAR_CURSOR 21, 0
    ; Mostrar mensaje de continuar
    mov ah, 09h
    lea dx, continuar
    int 21h
    
    ; Esperar Enter
    mov ah, 01h
    int 21h
    cmp al, 0Dh        ; Comparar con retorno de carro
    je menu_principal
    
salir:
    ; Terminar programa
    mov ax, 4C00h
    int 21h
    
    main endp
    
    ; Procedimiento para limpiar la pantalla
    limpiar_pantalla proc near
        mov ax, 0600h      ; Funci?n para desplazar pantalla (limpiar)
        mov bh, 07h        ; Atributo: blanco sobre negro
        mov cx, 0000h      ; Esquina superior izquierda
        mov dx, 184Fh      ; Esquina inferior derecha (24,79)
        int 10h
        POSICIONAR_CURSOR 0, 0  ; Reposicionar cursor
        ret
    limpiar_pantalla endp
    
    ; Procedimiento para mostrar el men?
    mostrar_menu proc near
        mov ah, 09h        ; Funci?n para imprimir cadena
        lea dx, titulo
        int 21h
        lea dx, opcion1
        int 21h
        lea dx, opcion2
        int 21h
        lea dx, opcion3
        int 21h
        lea dx, opcion4
        int 21h
        lea dx, opcion5
        int 21h
        lea dx, prompt
        int 21h
        ret
    mostrar_menu endp
    
    ; Procedimiento para dibujar pir?mide hacia arriba
    dibujar_piramide_arriba proc near
        call limpiar_pantalla
        mov cx, 20         ; N?mero de filas
        mov dh, 19         ; Fila inicial (abajo)
        mov dl, 12         ; Columna inicial
        mov bx, 39         ; Cantidad inicial de asteriscos
    ciclo_arriba:
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        add dl, 1          ; Mover columna a la derecha
        sub dh, 1          ; Subir una fila
        sub bx, 2          ; Reducir asteriscos
        loop ciclo_arriba
        ret
    dibujar_piramide_arriba endp
    
    ; Procedimiento para dibujar pir?mide hacia abajo
    dibujar_piramide_abajo proc near
        call limpiar_pantalla
        mov cx, 20         ; N?mero de filas
        mov dh, 0          ; Fila inicial (arriba)
        mov dl, 12         ; Columna inicial
        mov bx, 39         ; Cantidad inicial de asteriscos
    ciclo_abajo:
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        add dl, 1          ; Mover columna a la derecha
        add dh, 1          ; Bajar una fila
        sub bx, 2          ; Reducir asteriscos
        loop ciclo_abajo
        ret
    dibujar_piramide_abajo endp
    
    ; Procedimiento para dibujar pir?mide izquierda
    dibujar_piramide_izquierda proc near
        call limpiar_pantalla
        mov cx, 10         ; Primer ciclo: crecimiento
        mov dh, 0          ; Fila inicial
        mov dl, 22         ; Columna inicial (16h = 22)
        mov bx, 1          ; Cantidad inicial de asteriscos
    ciclo_izq1:
        mov var, cx        ; Preservar CX
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        ; Restaurar CX
        sub dl, 1          ; Mover columna a la izquierda
        add dh, 1          ; Bajar una fila
        add bx, 1          ; Aumentar asteriscos
        loop ciclo_izq1
        mov cx, 10         ; Segundo ciclo: decrecimiento
        mov dl, 14         ; Nueva columna inicial (0Bh + 03h = 14)
        sub bx, 2          ; Ajustar asteriscos
    ciclo_izq2:
        mov var, cx        ; Preservar CX
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        ; Restaurar CX
        add dl, 1          ; Mover columna a la derecha
        add dh, 1          ; Bajar una fila
        sub bx, 1          ; Reducir asteriscos
        loop ciclo_izq2
        ret
    dibujar_piramide_izquierda endp
    
    ; Procedimiento para dibujar pir?mide derecha
    dibujar_piramide_derecha proc near
        call limpiar_pantalla
        mov cx, 10         ; Primer ciclo: crecimiento
        mov dh, 0          ; Fila inicial
        mov dl, 10         ; Columna inicial (0Ah = 10)
        mov bx, 1          ; Cantidad inicial de asteriscos
    ciclo_der1:
        mov var, cx        ; Preservar CX
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        ; Restaurar CX
        add dh, 1          ; Bajar una fila
        add bx, 1          ; Aumentar asteriscos
        loop ciclo_der1
        mov cx, 10         ; Segundo ciclo: decrecimiento
        mov dl, 10         ; Mantener columna inicial
        sub bx, 2          ; Ajustar asteriscos
    ciclo_der2:
        mov var, cx        ; Preservar CX
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        ; Restaurar CX
        add dh, 1          ; Bajar una fila
        sub bx, 1          ; Reducir asteriscos
        loop ciclo_der2
        ret
    dibujar_piramide_derecha endp
    
codigo ends
end main