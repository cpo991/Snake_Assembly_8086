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

menujogo   db '                        ______                _ ',13,10
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
           db '                         3 - editar molduras',13,10
           db '                         4 - sair ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
           db '                                                carolina oliveira - 21270477  ',13,10
           db '                                                    miguel prates - 21280382  ',13,10
           db ' ',13,10,'$'

menujogoOpt db '                             __ ',13,10
            db '                             \ \  ___   __    ___',13,10
            db '                              \ \/ _ \ / _` |/ _ \ ',13,10
            db '                           /\_/ / (_) | (_| | (_) |',13,10
            db '                           \___/ \___/ \__, |\___/',13,10
            db '                                       |___/',13,10
            db '  ',13,10
            db '  ',13,10
            db '                           1 - Jogar com Moldura Default',13,10
            db '                           2 - Carregar Moludura editada',13,10
            db '                           3 - Sair',13,10
            db '  ',13,10
            db '  ',13,10 
            db '  ',13,10 
            db '  ',13,10 
            db '  ',13,10 
            db '  ',13,10,'$'

menumoldurasconf    db '                 _____             __  _  ',13,10
                    db '                / ____|           / _|(_)',13,10
                    db '               | |     ___  _ __ | |_ _  __ _ _   _ _ __ __ _ _ __',13,10
                    db '               | |    / _ \| `_ \|  _| |/ _` | | | | `__/ _` | `__|',13,10
                    db '               | |___| (_) | | | | | | | (_| | |_| | | | (_| | |',13,10
                    db '                \_____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|_|',13,10
                    db '                                         __/ |',13,10
                    db '                                        |___/',13,10
                    db ' ',13,10
                    db ' ',13,10
                    db '                           1 - Criar Grelha',13,10
                    db '                           2 - Editar Grelha',13,10
                    db '                           3 - Sair',13,10
                    db ' ',13,10,'$' 

menumolduras    db '                          Escolha a sua Moldura',13,10
		        db ' ',13,10
			    db ' ',13,10
				db ' ',13,10
				db ' ',13,10
				db ' ',13,10
				db '                           1 - Moldura 1',13,10
                db '                           2 - Moldura 2',13,10
			    db '                           3 - Moldura 3',13,10
				db '                           4 - Sair',13,10
				db ' ',13,10,'$' 

menudificuldade   db '            ______  _    ___ _             _     _           _ ',13,10
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
                  db '                           4 - falcao (nivel 4)',13,10
                  db '                           5 - sair ',13,10
                  db ' ',13,10,'$' 
           
menustat   db '          _______                                     _ ',13,10
           db '         (_______)       _           _          _   /_/',13,10
           db '          _____    ___ _| |_ _____ _| |_  ___ _| |_ _  ____ _____  ___',13,10
           db '         |  ___)  /___|_   _|____ (_   _)/___|_   _) |/ ___|____ |/___)',13,10
           db '         | |_____|___ | | |_/ ___ | | |_|___ | | |_| ( (___/ ___ |___ |',13,10
           db '         |_______|___/   \__)_____|  \__|___/   \__)_|\____)_____(___/',13,10
           db ' ',13,10
           db ' ',13,10 
           db '                           1 - Historico de jogos',13,10
           db '                           2 - Valores estatisticos',13,10
           db '                           3 - Sair',13,10
           db ' ',13,10,'$'        

sairjogo   db '                              Seseja mesmo sair?',13,10
           db ' ',13,10
           db '                        Sim [1]               Nao [2]',13,10
           db ' ',13,10,'$'

;########################################################################

; cria ficheiro de texto
    fname   db  'pontuacoes.txt',0
    fhandle dw  0
    ; buffer  db  '1 5 6 7 8 9 1 5 7 8 9 2 3 7 8 15 16 18 19 20 3',13,10
    ;         db  '+ - / * * + - - + * / * + - - + * / + - - + * ',13,10
    ;         db  '10 12 14 7 9 11 13 5 10 15 7 8 9 10 13 5 10 11',13,10 
    ;         db  '/ * + - - + * / + - / * * + - - + * * + - - + ',13,10
    ;         db  '3 45 23 11 4 7 14 18 31 27 19 9 6 47 19 9 6 51',13,10
    ;         db  '______________________________________________',13,10
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

; desenha tabuleiro
    
    posy        db  10  ; a linha pode ir de [1 .. 25]
    posx        db  40  ; posx pode ir [1..80]  
    posya       db  5   ; posição anterior de y
    posxa       db  10  ; posição anterior de x
    posxm       db      ? ; posição X maçã
    posym       db      ? ; posição Y maçã
        
    passa_t     dw  0
    passa_t_ant dw  0
    direccao    db  3
        
    centesimos  dw  0
    factor      db  100
    metade_factor   db  ?
    resto       db  0

;########################################################################

; calculo aleatorio
    ultimo_num_aleat dw 0
    str_num db 5 dup(?),'$'
    linha   db  0   ; define o número da linha que está a ser desenhada
    nlinhas db  0
    Cor3			 db 0
    Car3		 	 db	' '	
    
;########################################################################

; pontuacao e dependencias
textPontos		db		'pontos:',10 dup(' '),'$'
pontos			dw		0
compr			db 		1 ;comprimento da cobra (não funciona ainda)

; coordenadas para imprimir a pontuação
pontosY			byte 	0
pontosX 		byte 	52

; simbolos da maçã/rato
Sverde        byte    'v$'
Svermelha     byte    'V$'
SRato         byte    'r$'

;########################################################################

; legenda editar
Legenda_cls              db      "                               $"
Legenda_colocar_parede   db      "1-Parede$"
Legenda_limpar           db      "0-Apaga$"
Legenda_guardar          db      "S-Guarda$"
Legenda_sair             db      "ESC-sair$"

;########################################################################

; lvariaveis de slots de molduras
Car            db	32
mol            db	'moldura.TXT',0
fhandle1       dw   0
car_m          db   ?
mol1           db	'mol1.TXT',0
handle1        dw   0
car_m1         db   ?
mol2           db	'mol2.TXT',0
handle2        dw   0
car_m2         db   ?
mol3           db	'mol3.TXT',0
handle3        dw   0
car_m3         db   ?
buffer         dw   4000 dup(?)


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
    goto_xy 0,0
    
    lea     dx, menujogo
    mov     ah, 09h
    int     21h
    
    mov     ah, 1
    int     21h
    
    cmp     al, '1'
    jl      mostramenu
    cmp     al,'4'
    jg      mostramenu
    
    cmp     al,'1'
    je      mostramenujogoOpt
    cmp     al,'2'
    je      mostramenustat
    cmp     al,'3'
    je      mostramenumoldurasE
    cmp     al,'4'
    je      fechajogo

;########################################################################       
        
; mostra menu escolher modo de jogo
mostramenujogoOpt: 
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menujogoOpt 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenujogoOpt 
    cmp     al, '3'
    jg      mostramenujogoOpt 
        
    cmp     al, "1"
    je      mostramenudificuldade  
    cmp     al, "2"
    je      mostramenumoldurasJ
    cmp     al, "3"
    je      mostramenu
;########################################################################       
        
; mostra menu configurar jogo
mostramenudificuldade:
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menudificuldade 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenudificuldade 
    cmp     al, '5'
    jg      mostramenudificuldade
        
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
        
; mostra molduras editadas para jogar
mostramenumoldurasJ: 
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menumolduras 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenumoldurasJ 
    cmp     al, '3'
    jg      mostramenumoldurasJ 
        
    cmp     al, "1"
    je      JogarM1
    cmp     al, "2"
    ;je      grelhaJ2
    cmp     al, "3"
    ;je      grelhaJ3
    cmp     al, "4"
    je      mostramenu
;########################################################################       
        
; mostra molduras para editar
mostramenumoldurasE: 
    call apaga_ecran
    goto_xy 0,5
    lea     dx, menumolduras 
    mov     ah, 09h 
    int     21h 
     
    mov     ah, 1 
    int     21h        
    
    cmp     al, '1' 
    jl      mostramenumoldurasE 
    cmp     al, '4'
    jg      mostramenumoldurasE 
        
    cmp     al, "1"
    je      grelhaE1  
    cmp     al, "2"
    ;je      grelhaE2
    cmp     al, "3"
    ;je      grelhaE3
    cmp     al, "4"
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

; Legenda Editar
Legenda   proc
        goto_xy 70,2
        mov     ah,09h
        lea     dx,Legenda_colocar_parede
        int     21h
        goto_xy 70,3
        mov     ah,09h
        lea     dx,Legenda_limpar
        int     21h
        goto_xy 70,4
        mov     ah,09h
        lea     dx,Legenda_guardar 
        int     21h
        goto_xy 70,5
        mov     ah,09h
        lea     dx,Legenda_sair
        int     21h
        ret
Legenda   endp
;########################################################################

; Apagar Legenda
Legendacls   proc
        goto_xy 70,2
        mov     ah,09h
        lea     dx,Legenda_cls
        int     21h
        goto_xy 70,3
        mov     ah,09h
        lea     dx,Legenda_cls
        int     21h
        goto_xy 70,4
        mov     ah,09h
        lea     dx,Legenda_cls
        int     21h
        goto_xy 70,5
        mov     ah,09h
        lea     dx,Legenda_cls
        int     21h
        ret
Legendacls   endp











;########################################################################

; Mover cursor
EditaMold  proc
    call    Legenda

    mov	ax, DADOS
    mov	ds,ax
    mov	ax,0B800h
	mov	es,ax
;Obter posicao
	mov     POSy,5
    mov     POSx,10
    goto_xy	POSx,POSy
    goto_xy 0,0
    mov     car,32
CICLO:	

;Imprimir Moldura
IMPRIME:
    mov	ah, 02h
    mov	dl, Car
	int	21H			
	goto_xy	POSx,POSy

    call 	le_tecla_0
	cmp	ah, 1
	je	ESTEND
    cmp     al, 115
    je      LeEcra
	cmp 	al, 23                  ; ESCAPE
	je	mostramenu             

;Tipo de caracteres
ZERO:
    CMP AL, 48             ; Tecla 0
	JNE	UM
	mov	Car, 32                 ; espaço
	jmp	CICLO					
		
UM:
	CMP 	AL, 49             ; Tecla 1
	JNE	Begin
	mov	Car, 35                ; Caracter #
	jmp	CICLO		
Begin:
    cmp     al,63
    jne     Final   
    mov     car,63
    jmp     CICLO
Final:	
    cmp     al,33
    jne     NOVE
    mov     car,33
    jmp	CICLO
NOVE:
    jmp     CICLO

;Direcao cursor
ESTEND:	
    cmp al,48h
	jne	BAIXO
	dec	POSy                    ; cima
COMPC:
    cmp     POSy,1
    je      INCREMy
	jmp	CICLO

BAIXO:	
    cmp	al,50h
	jne	ESQUERDA
	inc 	POSy                ; Baixo
COMPB:
    cmp     POSy,24
    je      DECREMy
	jmp	CICLO

ESQUERDA:
	cmp	al,4Bh
	jne	DIREITA
	dec	POSx                    ; Esquerda
COMPE:
    cmp     POSx,1
    je      INCREMx
	jmp	CICLO

DIREITA:
	cmp	al,4Dh
	jne	CICLO 
	inc	POSx                    ; Direita
COMPD:
    cmp     POSx,70
    je      DECREMx
	jmp	CICLO

DECREMy:
    dec     POSy
    jmp     COMPB

INCREMy:
    inc     POSy
    jmp     COMPC

INCREMx:
    inc     POSx
    jmp     COMPE

DECREMx:
    dec     POSx
    jmp     COMPD
LeEcra:
    call    Legendacls
    mov     ax,0b800h
	mov     es,ax
        
    mov	al,0h
	mov	bx,0
    xor     si,si
    xor     di,di
    mov     cx,4000

cicloLe:   
	mov     ax,es:[di]
    mov     buffer[si],ax
	add     si,2
    add     di,2
    loop    cicloLe
    ret
EditaMold	endp

;########################################################################

; Jogar moldura criada
JogarM1: 
    call    apaga_ecran
    goto_xy 0,0
;abre ficheiro
    mov     ah,3dh			; vamos abrir ficheiro para leitura 
    mov     al,0			; tipo de ficheiro	
    lea     dx,mol1			; nome do ficheiro
    int     21h			; abre para leitura 
    jc      erro_ler1		; pode aconter erro a abrir o ficheiro 
    mov     Handle1,ax		; ax devolve o Handle para o ficheiro 
    jmp     ler_ciclo1		; depois de abero vamos ler o ficheiro 

ler_ciclo1:
    mov     ah,3fh			; indica que vai ser lido um ficheiro 
    mov     bx,Handle1		; bx deve conter o Handle do ficheiro previamente aberto 
    mov     cx,1			; numero de bytes a ler 
    lea     dx,car_m1		; vai ler para o local de memoria apontado por dx (car_fich)
    int     21h			; faz efectivamente a leitura
	jc	erro_ler1		; se carry � porque aconteceu um erro
	cmp	ax,0			; EOF? Verifica se j� estamos no fim do ficheiro 
	je	fecha_ficheiro1         ; se EOF fecha o ficheiro  
    mov     ah,02h			; coloca o caracter no ecran
    mov	dl,car_m1		; este � o caracter a enviar para o ecran
    int	21h			; imprime no ecran
    
    jmp	ler_ciclo1		; continua a ler o ficheiro

ler_comeco1:
    push    ax
    push    bx
    push    dx
    mov     bh,0
    mov     ah,03h
    int     10h
    dec     dl                      ; identa��o da leitura "puxa" o eixo X para a esquerda
    dec     dh                      ; identa��o da leitura "puxa" o eixo Y para baixo
    mov     posx,dl
    mov     posy,dh
    pop     dx
    pop     bx
    pop     ax
    jmp     ler_ciclo1

erro_ler1:
    mov     ah,09h
    lea     dx,Erro_Ler_Msg
    int     21h 

fecha_ficheiro1:			; vamos fechar o ficheiro 
    mov     ah,3eh
    mov     bx,Handle1
    int     21h
    jmp     JogaMolduras

JogaMolduras:
    goto_xy 40,10
    call move_snake


;########################################################################

; Editar moldura
grelhaE1:
       call apaga_ecran
;abre ficheiro
    mov     ah,3dh			; vamos abrir ficheiro para leitura 
    mov     al,0			; tipo de ficheiro	
    lea     dx,mol1			; nome do ficheiro
    int     21h			; abre para leitura 
    jc      erro_ler1		; pode aconter erro a abrir o ficheiro 
    mov     Handle1,ax		; ax devolve o Handle para o ficheiro 
    jmp     ler_ciclo1b		; depois de abero vamos ler o ficheiro 

ler_ciclo1b:
    mov     ah,3fh			; indica que vai ser lido um ficheiro 
    mov     bx,Handle1		; bx deve conter o Handle do ficheiro previamente aberto 
    mov     cx,1			; numero de bytes a ler 
    lea     dx,car_m1		; vai ler para o local de memoria apontado por dx (car_fich)
    int     21h			; faz efectivamente a leitura
	jc	erro_ler1		; se carry � porque aconteceu um erro
	cmp	ax,0			; EOF? Verifica se j� estamos no fim do ficheiro 
	je	fecha_ficheiro1b	; se EOF fecha o ficheiro 
    mov     ah,02h			; coloca o caracter no ecran
    mov	dl,car_m1		; este � o caracter a enviar para o ecran
    int	21h			; imprime no ecran
    jmp	ler_ciclo1b		; continua a ler o ficheiro

fecha_ficheiro1b:			; vamos fechar o ficheiro 
    mov     ah,3eh
    mov     bx,Handle1
    int     21h
     
    call    EditaMold
    call    GuardaM1

;########################################################################

; Guardar Molduras
GuardaM1:  
	mov	ah, 3ch			; abrir ficheiro para escrita 
	mov	cx, 00H			; tipo de ficheiro
	lea	dx, mol1		; dx contem endereco do nome do ficheiro 
	int	21h			    ; abre efectivamente e AX vai ficar com o Handle do ficheiro 
	jnc	escreve			; se n�o acontecer erro vamos escrever
	
	mov	ah, 09h			; Aconteceu erro na leitura
	lea	dx, msgErrorCreate
	int	21h
	
	jmp	sair

escreve:
	mov	bx, ax			; para escrever BX deve conter o Handle 
	mov	ah, 40h			; indica que vamos escrever 
    	
	lea	dx, buffer		; Vamos escrever o que estiver no endere�o DX
	mov	cx, 4000		; vamos escrever multiplos bytes duma vez s�
	int	21h			; faz a escrita 
	jnc	close			; se n�o acontecer erro fecha o ficheiro 
	
	mov	ah, 09h
	lea	dx, msgErrorWrite
	int	21h
close:
	mov	ah,3eh			; indica que vamos fechar
	int	21h
        call apaga_ecran		; fecha mesmo
	jnc	mostramenu		; se não acontecer erro termina
	
	mov	ah, 09h
	lea	dx, msgErrorClose
	int	21h
        jmp mostramenu


















;########################################################################

; funcao sair
sair:
    call apaga_ecran
    mov ah,4ch
    int 21h
    
;########################################################################

; cria ficheiro



;########################################################################


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

    
;#######################################################################
; Calculo aleatório
;#######################################################################

CalcAleat proc near

	sub	sp, 2
	push	bp
	mov	bp, sp
	push	ax
	push	cx
	push	dx	
	mov	ax,[bp+4]
	mov	[bp+2],ax

	mov	ah,00h
	int	1ah

	add	dx,ultimo_num_aleat	; vai buscar o aleatório anterior
	add	cx,dx	
	mov	ax,65521
	push	dx
	mul	cx			
	pop	dx			 
	xchg	dl,dh
	add	dx,32749
	add	dx,ax

	mov	ultimo_num_aleat,dx	; guarda o novo numero aleatório  

	mov	[BP+4],dx		; o aleatório é passado por pilha

	pop	dx
	pop	cx
	pop	ax
	pop	bp
	ret
CalcAleat endp

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
	CALL	MOVE_SNAKE
		
	MOV		AH,4CH
	INT		21H
JOGO    ENDP


;########################################################################
;             Converte a pontuação para texto.
;########################################################################

converte proc
    
    PUSHF
    PUSH AX
    PUSH BX
    PUSH DX
    
    add    di, 15
    mov    bx, 10
    
    mov    ax,[SI]
    
ciclo:
    xor    dx,dx
    div    bx
    add    dl,48
    mov    [di],dl
    dec    di
    cmp    ax,0
    jne ciclo
    
    POP AX
    POP BX
    POP DX
    POPF
    
    ret
    
converte endp


; move snake
move_snake proc
CICLO:	
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 	ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov		bh,0		; numero da página
		int		10h			
		cmp 	al, '#'	;  na posição do Cursor
		je		fim
		cmp		al, 'v'
		je		verde
		cmp		al, 'V'
		je 		vermelho
		cmp 	al, 'r'
		je 		rato
		
        inc POSx
        
        goto_xy	POSx,POSy	; Vai para nova possição
		mov 	ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov		bh,0		; numero da página
		int		10h	
		dec   POSx
		cmp 	al, '#'	;  na posição do Cursor
		je		fim
		cmp		al, 'v'
		je		verde
		cmp		al, 'V'
		je 		vermelho
		cmp 	al, 'r'
		je 		rato
        
;#######################################################################
; trail é código experimental para crescer, provavelmente é para apagar
;#######################################################################

trail:

	lea si,pontos ;meter o ponteiro do espaço de memoria que tem um valor igual ao o que esta em pontos e copiar esse ponteiro para si
	lea di,textPontos ;meter o ponteiro do espaço de memoria que tem um valor igual ao o que esta em textPontos e copiar esse ponteiro para di
	call converte ;chama a funçao que converte os numeros em texto

;########################################################################
; Escreve no jogo a pontuação com coordenadas X e Y
;########################################################################

JogoEscreve:
goto_xy pontosX, pontosY
        mov     ah,09h
        lea     dx,textPontos
        int     21h



apagatrail:

		goto_xy		POSxa,POSya		; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, ' ' 	; Coloca ESPAÇO
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, ' '		;  Coloca ESPAÇO
		int		21H	
		dec 	POSxa
		inc 	cl
		
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
jmp IMPRIME

;######################################################################
; maçãs verdes
;######################################################################

verde:
	add pontos,1
	add compr,1
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,60
	div    BX
	
	ADD     DL,5
	mov    posxm,DL
	
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,15
	div    BX
	
	ADD     DL,3
	mov    posym,DL
	
	goto_xy posxm,posym
    mov     ah,09h
        lea     dx,Sverde
        int     21h
	jmp trail
	
;######################################################################
; maçãs vermelhas
;######################################################################

vermelho:
	add pontos,2
	add compr,2
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,60
	div    BX
	
	ADD     DL,5
	mov    posxm,DL
	
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,15
	div    BX
	
	ADD     DL,3
	mov    posym,DL
	
	goto_xy posxm,posym
    mov     ah,09h
        lea     dx,Svermelha
        int     21h
	jmp trail

;######################################################################
; rato
;######################################################################

rato:

    cmp pontos,3
    jl  resetscore
	sub pontos,3
continuarato:
	cmp compr, 6
	jl lower
	sub compr,5
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,60
	div    BX
	
	ADD     DL,5
	mov    posxm,DL
	
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,15
	div    BX
	
	ADD     DL,3
	mov    posym,DL
	
	goto_xy posxm,posym
    mov     ah,09h
        lea     dx,SRato
        int     21h
	jmp trail
lower:
	mov compr,1

	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,60
	div    BX
	
	ADD     DL,5
	mov    posxm,DL
	
	call CalcAleat
	POP    AX
	
	XOR    DX,DX
	MOV    BX,15
	div    BX
	
	ADD     DL,3
	mov    posym,DL
	
	goto_xy posxm,posym
    mov     ah,09h
        lea     dx,SRato
        int     21h
	jmp trail

;######################################################################
; quando se come o rato, apaga pontos
;######################################################################

resetscore:
        mov pontos,0
        jmp continuarato


;######################################################################
; imprime o avatar
;######################################################################

imprime:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al
		
ler_seta:	call 		LE_TECLA_0
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	; ESCAPE
		JE		FIM
		CMP		AL, '1'
		JNE		TESTE_2
		MOV		FACTOR, 100
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
    call apaga_ecran
    goto_xy     40,23
    ret

move_snake endp


codigo  ends
end inicio
