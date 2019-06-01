;------------------------------------------------------------------------
;
;	Base para TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;   
;	ANO LECTIVO 2018/2019
;
;
;	
;
;		press ESC to exit
;------------------------------------------------------------------------
; MACROS
;------------------------------------------------------------------------
;MACRO GOTO_XY
; COLOCA O CURSOR NA POSIÇÃO POSX,POSY
;	POSX -> COLUNA
;	POSY -> LINHA
;------------------------------------------------------------------------
GOTO_XY		MACRO	POSX,POSY
			MOV	AH,02H
			MOV	BH,0
			MOV	DL,POSX
			MOV	DH,POSY
			INT	10H
ENDM

; MOSTRA - Faz o display de uma string terminada em $
;---------------------------------------------------------------------------
MOSTRA MACRO STR 
MOV AH,09H
LEA DX,STR 
INT 21H
ENDM
; FIM DAS MACROS


;---------------------------------------------------------------------------


.8086
.model small
.stack 2048h

PILHA	SEGMENT PARA STACK 'STACK'
		db 2048 dup(?)
PILHA	ENDS
	

DSEG    SEGMENT PARA PUBLIC 'DATA'

		POSy	db	10	; a linha pode ir de [1 .. 25]
		POSx	db	40	; POSx pode ir [1..80]	
		POSya		db	100	dup(0); Posição anterior de y
		POSxa		db	100	dup(10); Posição anterior de x
		tam		dw		1			;numero de segmentos
		pontos  dw 		0
		pl		db		0			;assinala se há crescimento
	
	
		PASSA_T		dw	0
		PASSA_T_ant	dw	0
		direccao	db	3
		
		Centesimos	dw 	0
		FACTOR		db	200
		metade_FACTOR	db	?
		resto		db	0
						
		Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
		Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
		Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
		Fich         	db      'moldura.TXT',0
		score			db		'SCORE: $'
		HandleFich      dw      0
		car_fich        db      ?
		MENUDIF db 'SNAKE',13,10
				db 'DIFICULDADE:',13,10
				db '1 - LENTO',13,10
				db '2 - MEDIO',13,10
				db '3 - RAPIDO$',13,10
		MENUI	db 'SNAKE',13,10
				db '1-JOGO',13,10
				db '2-ESTATISTICA',13,10
				db '3-SAIR$',13,10
DSEG    ENDS

CSEG    SEGMENT PARA PUBLIC 'CODE'
	ASSUME  CS:CSEG, DS:DSEG, SS:PILHA
	


;********************************************************************************
PONTUACAO PROC
goto_xy 38,24
	push bx
	push ax
	push dx
	mov bx,10
	     mov    ax, pontos
         mov    cx, 5        ;  digit count to generate
loop1:  xor dx,dx 
		div bx
         add    dx, 30h
         push   dx
         loop loop1
         mov    cx, 5        ;  digit count to print
loop2:   pop    dx
         mov ah,02h
		 int 21h
         loop loop2
	pop dx
	pop ax
	pop bx
PONTUACAO ENDP


PASSA_TEMPO PROC	
 
		
		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H                 
		
 		XOR AX,AX
		MOV AL, DL              ; centesimos de segundo para ax		
		mov Centesimos, AX
	
		mov bl, factor		; define velocidade da snake (100; 50; 33; 25; 20; 10)
		div bl
		mov resto, AH
		mov AL, FACTOR
		mov AH, 0
		mov bl, 2
		div bl
		mov metade_FACTOR, AL
		mov AL, resto
		mov AH, 0
		mov BL, metade_FACTOR	; deve ficar sempre com metade do valor inicial
		mov AH, 0
		cmp AX, BX
		jbe Menor
		mov AX, 1
		mov PASSA_T, AX	
		jmp fim_passa	
		
Menor:		mov AX,0
		mov PASSA_T, AX		

fim_passa:	 

 		RET 
PASSA_TEMPO   ENDP 




;********************************************************************************	



Imp_Fich	PROC

;abre ficheiro

        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,Fich			; nome do ficheiro
        int     21h			; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de abero vamos ler o ficheiro 

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai

ler_ciclo:
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,1			; numero de bytes a ler 
        lea     dx,car_fich		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h			; faz efectivamente a leitura
	jc	    erro_ler		; se carry é porque aconteceu um erro
	cmp	    ax,0		;EOF?	verifica se já estamos no fim do ficheiro 
	je	    fecha_ficheiro	; se EOF fecha o ficheiro 
        mov     ah,02h			; coloca o caracter no ecran
	mov	    dl,car_fich		; este é o caracter a enviar para o ecran
	int	    21h			; imprime no ecran
	jmp	    ler_ciclo		; continua a ler o ficheiro

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h			; o ficheiro pode não fechar correctamente
        lea     dx,Erro_Close
        Int     21h
sai:	  RET
Imp_Fich	endp

;########################################################################

;********************************************************************************
;ROTINA PARA APAGAR ECRAN

APAGA_ECRAN	PROC
		PUSH BX
		PUSH AX
		PUSH CX
		PUSH SI
		XOR	BX,BX
		MOV	CX,25*80
		MOV SI,BX
APAGA:	
		MOV	AL,' '
		MOV	BYTE PTR ES:[BX],AL
		MOV	BYTE PTR ES:[BX+1],7
		INC	BX
		INC BX
		LOOP	APAGA
		POP SI
		POP CX
		POP AX
		POP BX
		RET
APAGA_ECRAN	ENDP

;********************************************************************************
; LEITURA DE UMA TECLA DO TECLADO    (ALTERADO)
; LE UMA TECLA	E DEVOLVE VALOR EM AH E AL
; SE ah=0 É UMA TECLA NORMAL
; SE ah=1 É UMA TECLA EXTENDIDA
; AL DEVOLVE O CÓDIGO DA TECLA PREMIDA
; Se não foi premida tecla, devolve ah=0 e al = 0
;********************************************************************************
LE_TECLA_0	PROC

		MOV	AH,0BH
		INT 	21h
		cmp 	AL,0
		jne	com_tecla
		mov	AH, 0
		mov	AL, 0
		jmp	SAI_TECLA
com_tecla:		
		MOV	AH,08H
		INT	21H
		MOV	AH,0
		CMP	AL,0
		JNE	SAI_TECLA
		MOV	AH, 08H
		INT	21H
		MOV	AH,1
SAI_TECLA:	
		RET
LE_TECLA_0	ENDP


DIFICULDADE PROC		;seleciona velocidade
		goto_xy 0,0 	
		call APAGA_ECRAN
		mov     ah,09h
        lea     dx,MENUDIF
        int     21h
CI:	    mov ah,08h
		mov al,0
		int 21h
		cmp al,31h
		jne T1
		mov FACTOR,100
		RET
	T1:	cmp al,32h
		jne T2
		mov FACTOR,50
		RET
	T2:	cmp al,33h
		jne CI
		mov FACTOR,25
		RET
DIFICULDADE ENDP

INICIO PROC		;menu inicial
		goto_xy 0,0 	
		mov     ah,09h
        lea     dx,MENUI
        int     21h
CI:	    mov ah,08h
		mov al,0
		int 21h
		cmp al,31h
		jne T1
		call DIFICULDADE
		RET
	T1:	cmp al,32h
		jne T2
		RET
	T2:	cmp al,33h
		jne CI
		mov ah,4Ch
		int 21h
INICIO ENDP


;#############################################################################
move_snake PROC
LER_SETA:	call 		LE_TECLA_0
		mov pl,0					;flag a 0 (sem crescimento)
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	; ESCAPE
		JE		FIM
		
		CALL		PASSA_TEMPO
		mov		AX, PASSA_T_ant
		CMP		AX, PASSA_T
		je		LER_SETA
		mov		AX, PASSA_T
		mov		PASSA_T_ant, AX
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		mov 	bx,tam
		mov		al, POSx	; guarda posição atual no elemento tam do vetor
		mov		POSxa[bx], al
		mov		al, POSy	
		mov 	POSya[bx], al
		
verifica_0:	mov		al, direccao
		cmp 		al, 0
		jne		verifica_1
		inc		POSx		;Direita
		jmp		CICLO
		
verifica_1:	mov 		al, direccao
		cmp		al, 1
		jne		verifica_2
		dec		POSy		;cima
		jmp		CICLO
		
verifica_2:	mov 		al, direccao
		cmp		al, 2
		jne		verifica_3
		dec		POSx		;Esquerda
		jmp		CICLO
		
verifica_3:	mov 		al, direccao
		cmp		al, 3		
		jne		CICLO
		inc		POSy		;BAIXO		
		jmp		CICLO
		
ESTEND:		cmp 		al,48h
		jne		BAIXO
		mov		direccao, 1
		jmp		CICLO
		

BAIXO:		cmp		al,50h
		jne		ESQUERDA
		mov		direccao, 3
		jmp		CICLO
		

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		mov		direccao, 2
		jmp		CICLO
		

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		mov		direccao, 0	
		jmp		CICLO
CICLO:	
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov		bh,0		; numero da página
		int		10h			
		cmp 		al,'#'	;  verificações de acontecimentos
		je		fim
		cmp 		al,'X'
		je 		fim
		cmp			al,'A'
		jne IMPRIME
		add tam,1
		mov pl,1				;assinalar que houve crescimento
		add pontos,1
		call PONTUACAO
		
		
		
	
	
		
IMPRIME:goto_xy		POSx,POSy	; Vai para posição do cursor	

		mov		ah, 02h
		mov		dl, '*'	; escreve a cabeça
		int		21H
		cmp pl,0			;se a flag estiver a 1, adicionar um elemento ao lado da cabeça e manter o resto
		je spo
		goto_xy		POSxa[bx],POSya[bx]	;	
		mov		ah,02h
		mov		dl,'X'
		int 21h
		goto_xy POSx,POSy
		jmp LER_SETA
		
spo:		mov bx,0		;index a 0 e loop com tam para atualizar posições, cada elemento fica com a posição do próximo
		mov cx,tam
coo:	mov al,POSxa[bx+1]
		mov POSxa[bx],al
		mov al,POSya[bx+1]
		mov POSya[bx],al
		add bx,1
		loop coo
		
		mov bx,tam		;index a tam (onde está o início da cauda) e loop que reescreve a cauda
		mov cx,tam

co2:	goto_xy		POSxa[bx],POSya[bx]		
		mov		ah, 02h
		mov		dl, 'X'
		int 21h
		sub bx,1
		loop co2
	
		goto_xy		POSxa[bx],POSya[bx]	;	;apaga o fim da cauda
		mov		ah,02h
		mov		dl,' '
		int 21h

		
		goto_xy		POSx,POSy
		
		jmp LER_SETA
		
		
		;PROBLEMAS
		;O último elemento apaga quando a cobra muda de sentido e só aparece quando completar essa curva
		;A cobra só ganha o segmento de uma maça depois do último elemento atual chegar ao sítio da maça
	

fim:		goto_xy		40,23
		RET

move_snake ENDP

;#############################################################################
;             MAIN
;#############################################################################
MENU    Proc
		MOV     	AX,DSEG
		MOV     	DS,AX
		MOV		AX,0B800H
		MOV		ES,AX		; ES indica segmento de memória de VIDEO
		CALL 		APAGA_ECRAN
		CALL 		INICIO
		call 		APAGA_ECRAN
		CALL		Imp_Fich
		goto_xy		30,24
		mov     ah,09h
        lea     dx,score
        int     21h
		call		move_snake
		
		FIM:MOV		AH,4Ch
		INT		21h
MENU    endp
cseg	ends
end	MENU