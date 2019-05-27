.8086
.model small
.stack 2048

;########################################################################
; macros
;########################################################################
;>>>>>>>>>>>>>>>>>>>>>>>mover o cursor<<<<<<<<<<<<<<<<<<<<<<<<<
goto_xy macro       posx,posy
    mov ah,02h
    mov bh,0        ; numero da página
    mov dl,posx
    mov dh,posy
    int 10h
endm

;>>>>>>mostra - faz o display de uma string terminada em $<<<<<
mostra macro str 
    mov ah,09h
    lea dx,str 
    int 21h
endm

; fim das macros

;########################################################################

pilha   segment para stack 'stack'
        db 2048 dup(?)
pilha   ends

dados   segment para public 'data'

menujogo   db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ` ',13,10
           db '                        ______                _ ',13,10
           db '                _y_    / _____)              | |',13,10
           db '               /   \  ( (____   ____   _____ | |  _  _____ ',13,10
           db '              { * * }  \____ \ |  _ \ (____ || |_/ )| ___ |    /\ ',13,10
           db '               \___/   _____) )| | | |/ ___ ||  _ ( | ____|   /  \ ',13,10
           db '                |  |  (______/ |_| |_|\_____||_| \_)|_____)  /   / ',13,10
           db '                |   \_______________________________________/   / ',13,10
           db '                 \                                             / ',13,10
           db '                  \___________________________________________/',13,10
           db '  ',13,10
           db '   ',13,10
           db '                         1 - criar novo jogo',13,10
           db '                         2 - consultar elementos estatisticos',13,10
           db '                         3 - sair ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db '                                                carolina oliveira - 21270477  ',13,10
           db '                                                    miguel prates - 21280382  ',13,10
           db ' ',13,10,'$'

menuconf   db ' ',13,10
           db ' ',13,10
           db '            ______  _    ___ _             _     _           _ ',13,10
           db '           (______)(_)  / __|_)           | |   | |         | |',13,10
           db '            _     _ _ _| |__ _  ____ _   _| | __| |_____  __| |_____',13,10
           db '           | |   | | (_   __) |/ ___) | | | |/ _  (____ |/ _  | ___ |',13,10
           db '           | |__/ /| | | |  | ( (___| |_| | ( (_| / ___ ( (_| | ____|',13,10
           db '           |_____/ |_| |_|  |_|\____)____/ \_)____\_____|\____|_____)',13,10
           db ' ',13,10
           db ' ',13,10
           db '                           1 - lesma (nivel 1)',13,10
           db '                           2 - lebre (nivel 2)',13,10
           db '                           3 - chita (nivel 3)',13,10
           db '                           4 - (nivel 4)',13,10
           db '                           5 - sair ',13,10
           db ' ',13,10
           db ' ',13,10,'$' 
           
menustat   db ' ',13,10 
           db ' ',13,10 
           db '          _______                                    _ ',13,10
           db '         (_______)       _           _          _   /_/',13,10
           db '          _____    ___ _| |_ _____ _| |_  ___ _| |_ _  ____ _____  ___',13,10
           db '         |  ___)  /___|_   _|____ (_   _)/___|_   _) |/ ___|____ |/___)',13,10
           db '         | |_____|___ | | |_/ ___ | | |_|___ | | |_| ( (___/ ___ |___ |',13,10
           db '         |_______|___/   \__)_____|  \__|___/   \__)_|\____)_____(___/',13,10
           db ' ',13,10
           db ' ',13,10 
           db '                           1 - historico de jogos',13,10
           db '                           2 - valores estatisticos',13,10
           db '                           3 - sair',13,10
           db ' ',13,10 
           db ' ',13,10 
           db ' ',13,10,'$'        

sairjogo   db ' ',13,10    
           db '                              deseja mesmo sair?',13,10
           db ' ',13,10
           db '                        sim [1]               nao [2]',13,10
           db ' ',13,10
           db ' ',13,10,'$'

;########################################################################

; cria ficheiro de texto
    fname   db  'pontuacoes.txt',0
    fhandle dw  0
    buffer  db  '1 5 6 7 8 9 1 5 7 8 9 2 3 7 8 15 16 18 19 20 3',13,10
            db  '+ - / * * + - - + * / * + - - + * / + - - + * ',13,10
            db  '10 12 14 7 9 11 13 5 10 15 7 8 9 10 13 5 10 11',13,10 
            db  '/ * + - - + * / + - / * * + - - + * * + - - + ',13,10
            db  '3 45 23 11 4 7 14 18 31 27 19 9 6 47 19 9 6 51',13,10
            db  '______________________________________________',13,10
    msgerrorcreate  db  "ocorreu um erro na criacao do ficheiro!$"
    msgerrorwrite   db  "ocorreu um erro na escrita para ficheiro!$"
    msgerrorclose   db  "ocorreu um erro no fecho do ficheiro!$"

;########################################################################

; abre ficheiro de texto
    erro_open       db      'erro ao tentar abrir o ficheiro$'
    erro_ler_msg    db      'erro ao tentar ler do ficheiro$'
    erro_close      db      'erro ao tentar fechar o ficheiro$'
    fich            db      'moldura.txt',0
    handlefich      dw      0
    car_fich        db      ?

;########################################################################

; desenha tabuleiro --- delay.asm
    
    posy    db  10  ; a linha pode ir de [1 .. 25]
    posx    db  40  ; posx pode ir [1..80]  
    posya       db  5   ; posição anterior de y
    posxa       db  10  ; posição anterior de x
        
    passa_t     dw  0
    passa_t_ant dw  0
    direccao    db  3
        
    centesimos  dw  0
    factor      db  100
    metade_factor   db  ?
    resto       db  0

;########################################################################

; cursor
    ultimo_num_aleat dw 0

    str_num db 5 dup(?),'$'
    
    linha   db  0   ; define o número da linha que está a ser desenhada
    nlinhas db  0

    car     db  32  ; guarda um caracter do ecran 
    cor     db  7   ; guarda os atributos de cor do caracter
    car2    db  32  ; guarda um caracter do ecran 
    cor2    db  7   ; guarda os atributos de cor do caracter

;########################################################################

; pontuacao
pontuacao   dw      37
texto       db      'pontuacao:    ',10,'$'
len equ $ - texto 


dados   ends

codigo  segment para    public  'code'
        assume  cs:codigo, ds:dados, ss:pilha
        
inicio:
    mov     ax, dados
    mov     ds, ax
    mov     ax,0b800h
    mov     es,ax



;########################################################################

; mostra menu principal
mostramenu:       
    call apaga_ecran
    ;goto_xy 0,0
    
    lea     dx, menujogo
    mov     ah, 09h
    int     21h
    
    mov     ah, 1
    int     21h
    
    cmp     al, '1'
    jl      mostramenu
    cmp     al,'3'
    jg      mostramenu
    
    cmp     al,'1'
    je      mostramenuconf
    cmp     al,'2'
    je      mostramenustat
    cmp     al,'3'
    je      fechajogo

;########################################################################       
        
; mostra menu configurar jogo
mostramenuconf:
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menuconf 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenuconf 
    cmp     al, '5'
    jg      mostramenuconf
        
    cmp     al, "1"
    je      jogo        ;factor = 100
    cmp     al, "2"
    mov     factor, 50  ;factor = 50
    je      jogo
    cmp     al, "3"
    mov     factor, 25  ;factor = 25
    je      jogo
    cmp     al, "4"
    mov     factor, 10  ;factor = 10
    je      jogo
    cmp     al, "5"
    je      mostramenu
        
;########################################################################       
        
; mostra menu estatisticas
mostramenustat: 
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menustat 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenustat 
    cmp     al, '3'
    jg      mostramenustat 
        
    cmp     al, "1"
    ;je     histjogos   
    cmp     al, "2"
    ;je     valstat
    cmp     al, "3"
    je      mostramenu
    
;########################################################################   
        
; mostra menu sair
fechajogo:
    call apaga_ecran
    goto_xy 0,10
    lea     dx, sairjogo
    mov     ah, 09h
    int     21h
    
    mov     ah, 1
    int     21h
    
    ;goto_xy 0,23
    
    cmp     al,'1'
    jb      fechajogo
    cmp     al,'2'
    jg      fechajogo
    
    cmp     al,'1'
    je      sair
    cmp     al,'2'
    je      mostramenu

;########################################################################

;rotina para apagar ecran
apaga_ecran proc
    push bx
    push ax
    push cx
    push si
    xor bx,bx
    mov cx,24*80
    mov bx,160
    mov si,bx
apaga:  
    mov al,' '
    mov byte ptr es:[bx],al
    mov byte ptr es:[bx+1],7
    inc bx
    inc bx
    inc si
    loop    apaga
    pop si
    pop cx
    pop ax
    pop bx
    ret
apaga_ecran endp

;########################################################################

; funcao sair
sair:
    call apaga_ecran
    mov ah,4ch
    int 21h
    
;########################################################################

; cursor

;########################################################################

; cria ficheiro


;########################################################################

; ler tecla

;********************************************************************************
; leitura de uma tecla do teclado    (alterado)
; le uma tecla  e devolve valor em ah e al
; se ah=0 é uma tecla normal
; se ah=1 é uma tecla extendida
; al devolve o código da tecla premida
; se não foi premida tecla, devolve ah=0 e al = 0
;********************************************************************************
le_tecla_0  proc
    ;   call    trata_horas
    ;call contador
    
    
    mov ah,0bh
    int     21h
    cmp     al,0
    jne com_tecla
    mov ah, 0
    mov al, 0
    jmp sai_tecla
com_tecla:      
    mov ah,08h
    int 21h
    mov ah,0
    cmp al,0
    jne sai_tecla
    mov ah, 08h
    int 21h
    mov ah,1
sai_tecla:  
        ret
le_tecla_0  endp

    
;########################################################################

; abre ficheiro

;########################################################################

; passa tempo
passa_tempo proc    
    
    mov ah, 2ch             ; buscar a horas
    int 21h                 
    
    xor ax,ax
    mov al, dl              ; centesimos de segundo para ax     
    mov centesimos, ax
    
    mov bl, factor      ; define velocidade da snake (100; 50; 33; 25; 20; 10)
    div bl
    mov resto, ah
    mov al, factor
    mov ah, 0
    mov bl, 2
    div bl
    mov metade_factor, al
    mov al, resto
    mov ah, 0
    mov bl, metade_factor   ; deve ficar sempre com metade do valor inicial
    mov ah, 0
    cmp ax, bx
    jbe menor
    mov ax, 1
    mov passa_t, ax 
    jmp fim_passa   
        
menor:
    mov ax,0
    mov passa_t, ax     

fim_passa:   

    ret 
passa_tempo   endp

;########################################################################

; imprimir pontuacao

contador    proc
    pushf
    push ax
    push bx
    push cx
    push dx

    xor ax,ax
    xor bx,bx
    
    inc pontuacao

    mov ax, pontuacao

    mov bl,10
    div bl
    add ah, 30h
    add al, 30h
    mov texto[12], al
    mov texto[13], ah
    mov texto[14],'$'
        
    goto_xy 30,10
    mostra texto

    popf
    pop dx
    pop cx
    pop bx
    pop ax
    ret

contador endp

;########################################################################

; tabuleiro de jogo
imp_fich    proc
;abre ficheiro
    mov     ah,3dh          ; vamos abrir ficheiro para leitura 
    mov     al,0            ; tipo de ficheiro  
    lea     dx,fich         ; nome do ficheiro
    int     21h             ; abre para leitura 
    jc      erro_abrir      ; pode aconter erro a abrir o ficheiro 
    mov     handlefich,ax   ; ax devolve o handle para o ficheiro 
    jmp     ler_ciclo       ; depois de abero vamos ler o ficheiro 
erro_abrir:
    mov     ah,09h
    lea     dx,erro_open
    int     21h
    jmp     sai
ler_ciclo:
    mov     ah,3fh          ; indica que vai ser lido um ficheiro 
    mov     bx,handlefich   ; bx deve conter o handle do ficheiro previamente aberto 
    mov     cx,1            ; numero de bytes a ler 
    lea     dx,car_fich     ; vai ler para o local de memoria apontado por dx (car_fich)
    int     21h             ; faz efectivamente a leitura
    jc      erro_ler        ; se carry é porque aconteceu um erro
    cmp     ax,0            ; eof?  verifica se já estamos no fim do ficheiro 
    je      fecha_ficheiro  ; se eof fecha o ficheiro 
    mov     ah,02h          ; coloca o caracter no ecran
    mov     dl,car_fich     ; este é o caracter a enviar para o ecran
    int     21h             ; imprime no ecran
    jmp     ler_ciclo       ; continua a ler o ficheiro
erro_ler:
    mov     ah,09h
    lea     dx,erro_ler_msg
    int     21h
fecha_ficheiro:                 ; vamos fechar o ficheiro 
    mov     ah,3eh
    mov     bx,handlefich
    int     21h
    jnc     sai
    mov     ah,09h          ; o ficheiro pode não fechar correctamente
    lea     dx,erro_close
    int     21h
sai:      ret
imp_fich    endp

;########################################################################
;             JOGO
;########################################################################
JOGO    PROC
	CALL 	APAGA_ECRAN 
	CALL	IMP_FICH
	CALL 	CONTADOR
	CALL	MOVE_SNAKE
		
	MOV		AH,4CH
	INT		21H
JOGO    ENDP


; move snake
move_snake proc
call contador
ciclo:  
    
    goto_xy     posx,posy   ; vai para nova possição
    mov     ah, 08h ; guarda o caracter que está na posição do cursor
    mov     bh,0        ; numero da página
    int     10h         
    cmp     al, '#' ;  na posição do cursor
    ;guarda pontuação
    ;aparece game over
    je      fim

    goto_xy     posxa,posya     ; vai para a posição anterior do cursor
    mov     ah, 02h
    mov     dl, ' '     ; coloca espaço
    int     21h 

;quando anda coloca espaço atrás
    inc     posxa
    goto_xy     posxa,posya 
    mov     ah, 02h
    mov     dl, ' '     ;  coloca espaço
    int     21h 
    dec     posxa
        
    goto_xy     posx,posy   ; vai para posição do cursor

;incrementa cobra
;incsnake:
    ; goto_xy       posxa,posya     ; vai para a posição anterior do cursor
    ; mov       ah, 02h
    ; cmp ah, ' '
    ; jne incobra
    
;incobra:   
    ; mov       dl, '('     ; coloca espaço
    ; int       21h 

    ; inc       posxa
    ; goto_xy       posxa,posya 
    ; mov       ah, 02h
    ; mov       dl, ')'     ;  coloca espaço
    ; int       21h 
    ; dec   posxa
        
    ; goto_xy       posx,posy   ; vai para posição do cursor

imprime:

; para aumentar a cobra é:
; posição do cursor anterior
; coloca avatar 1
; coloca avatar 2
; guarda

    mov     ah, 02h
    mov     dl, '(' ; coloca avatar1
    int     21h
    
    inc     posx
    goto_xy     posx,posy       
    mov     ah, 02h
    mov     dl, ')' ; coloca avatar2
    int     21h 
    dec     posx
        
    goto_xy     posx,posy   ; vai para posição do cursor
        
    mov     al, posx    ; guarda a posição do cursor
    mov     posxa, al
    mov     al, posy    ; guarda a posição do cursor
    mov     posya, al
        
ler_seta:   
    call    le_tecla_0
    cmp     ah, 1
    je      estend
    cmp     al, 27  ; escape
    je      fim
    cmp     al, '1'
    jne     teste_2
    mov     factor, 100
teste_2:
    cmp     al, '2'
    jne     teste_3
    mov     factor, 50
teste_3:
    cmp     al, '3'
    jne     teste_4
    mov     factor, 25
teste_4:
    cmp     al, '4'
    jne     teste_end
    mov     factor, 10
teste_end:      
    call    passa_tempo
    mov     ax, passa_t_ant
    cmp     ax, passa_t
    je      ler_seta
    mov     ax, passa_t
    mov     passa_t_ant, ax
        
verifica_0: 
    mov     al, direccao
    cmp     al, 0
    jne     verifica_1
    
    inc     posx        ;direita
    inc     posx        ;direita
    jmp     ciclo
        
verifica_1: 
    mov     al, direccao
    cmp     al, 1
    jne     verifica_2
    dec     posy        ;cima
    jmp     ciclo
        
verifica_2: 
    mov     al, direccao
    cmp     al, 2
    jne     verifica_3
    dec     posx        ;esquerda
    dec     posx        ;esquerda
    jmp     ciclo
        
verifica_3: 
    mov     al, direccao
    cmp     al, 3       
    jne     ciclo
    inc     posy        ;baixo      
    jmp     ciclo
        
estend:
    cmp         al,48h
    jne     baixo
    mov     direccao, 1
    jmp     ciclo

baixo:
    cmp     al,50h
    jne     esquerda
    mov     direccao, 3
    jmp     ciclo

esquerda:
    cmp     al,4bh
    jne     direita
    mov     direccao, 2
    jmp     ciclo

direita:
    cmp     al,4dh
    jne     ler_seta 
    mov     direccao, 0 
    jmp     ciclo

fim:
    goto_xy     40,23
    ret

move_snake endp


codigo  ends
end inicio
