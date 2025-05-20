.286
pila segment stack
    db 32 DUP('stack--')  
pila ends

datos segment
    
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
    seleccion db ?  ; Opcion
    var dw ?        ; Conservar CX
datos ends

codigo segment 'code'
    ; Macro posicionar el cursor en pantalla
    POSICIONAR_CURSOR MACRO fila, columna
        mov ah, 02h        
        mov bh, 00h        
        mov dh, fila       
        mov dl, columna    
        int 10h            
    ENDM

    ; Macro imprimir caracter en pantalla
    IMPRIMIR_CARACTER MACRO caracter, cantidad
        mov ah, 0Ah        
        mov al, caracter   
        mov cx, cantidad   
        int 10h            
    ENDM

    main proc far
    assume ss:pila, ds:datos, cs:codigo
    
    ; Segmento de Datos
    push ds
    push 0
    mov ax, datos
    mov ds, ax
    
menu_principal:

    call limpiar_pantalla
    

    call mostrar_menu
    
    ; Leer opcion
    mov ah, 01h        
    int 21h
    mov seleccion, al  
    
    ; Comparar opcion y Saltar
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
    ; Posicionar 
    POSICIONAR_CURSOR 21, 0
    
    mov ah, 09h
    lea dx, continuar
    int 21h
    
    
    mov ah, 01h
    int 21h
    cmp al, 0Dh        
    je menu_principal
    
salir:
    ; Finalizar Programa
    mov ax, 4C00h
    int 21h
    
    main endp
    
    ; Procedimiento = Limpiar Pantalla
    limpiar_pantalla proc near
        mov ax, 0600h      
        mov bh, 4Fh        
        mov cx, 0000h      
        mov dx, 184Fh      
        int 10h
        POSICIONAR_CURSOR 0, 0  
        ret
    limpiar_pantalla endp
    
    ; Procedimiento - Mostrar Mensaje
    mostrar_menu proc near
        mov ah, 09h        
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
    
    ; Procedimiento - Piramide hacia arriba
    dibujar_piramide_arriba proc near
        call limpiar_pantalla
        mov cx, 20         
        mov dh, 19         
        mov dl, 12         
        mov bx, 39         
    ciclo_arriba:
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        add dl, 1          
        sub dh, 1          
        sub bx, 2          
        loop ciclo_arriba
        ret
    dibujar_piramide_arriba endp
    
    ; Procedimiento - Piramide hacia Abajo
    dibujar_piramide_abajo proc near
        call limpiar_pantalla
        mov cx, 20         
        mov dh, 0          
        mov dl, 12         
        mov bx, 39         
    ciclo_abajo:
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        add dl, 1          
        add dh, 1          
        sub bx, 2          
        loop ciclo_abajo
        ret
    dibujar_piramide_abajo endp
    
    ; Procedimiento - Piramide hacia la Izquierda
    dibujar_piramide_izquierda proc near
        call limpiar_pantalla
        mov cx, 10         
        mov dh, 0          
        mov dl, 22         
        mov bx, 1          
    ciclo_izq1:
        mov var, cx        
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        
        sub dl, 1          
        add dh, 1          
        add bx, 1          
        loop ciclo_izq1
        mov cx, 10         
        mov dl, 14         
        sub bx, 2          
    ciclo_izq2:
        mov var, cx        
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        
        add dl, 1          
        add dh, 1          
        sub bx, 1          
        loop ciclo_izq2
        ret
    dibujar_piramide_izquierda endp
    
    ; Procedimiento - Piramide hacia la Derecha
    dibujar_piramide_derecha proc near
        call limpiar_pantalla
        mov cx, 10         
        mov dh, 0          
        mov dl, 10         
        mov bx, 1          
    ciclo_der1:
        mov var, cx        
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        
        add dh, 1          
        add bx, 1          
        loop ciclo_der1
        mov cx, 10         
        mov dl, 10         
        sub bx, 2          
    ciclo_der2:
        mov var, cx        
        POSICIONAR_CURSOR dh, dl
        IMPRIMIR_CARACTER '*', bx
        mov cx, var        
        add dh, 1          
        sub bx, 1          
        loop ciclo_der2
        ret
    dibujar_piramide_derecha endp
    
codigo ends
end main