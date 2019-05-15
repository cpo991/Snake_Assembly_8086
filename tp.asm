.8086
.MODEL SMALL
.STACK 2048

;########################################################################
; MACROS
;########################################################################
;>>>>>>>>>>>>>>>>>>>>>>>MOVER O CURSOR<<<<<<<<<<<<<<<<<<<<<<<<<
GOTO_XY	MACRO		POSX,POSY
	MOV AH,02H
	MOV BH,0		; NUMERO DA PÁGINA
	MOV DL,POSX
	MOV DH,POSY
	INT 10H
ENDM

;>>>>>>MOSTRA - FAZ O DISPLAY DE UMA STRING TERMINADA EM $<<<<<
MOSTRA MACRO STR 
	MOV AH,09H
	LEA DX,STR 
	INT 21H
ENDM

; FIM DAS MACROS

;########################################################################

PILHA	SEGMENT PARA STACK 'STACK'
		DB 2048 DUP(?)
PILHA	ENDS

DADOS	SEGMENT PARA PUBLIC 'DATA'

MENUJOGO   DB '                                                                          ',13,10
		   DB '###############################################################################',13,10
           DB '#                       ______                _                               #',13,10
           DB '#               _Y_    / _____)              | |                              #',13,10
           DB '#              /   \  ( (____   ____   _____ | |  _  _____                    #',13,10
           DB '#             { * * }  \____ \ |  _ \ (____ || |_/ )| ___ |    /\             #',13,10
           DB '#              \___/   _____) )| | | |/ ___ ||  _ ( | ____|   /  \            #',13,10
           DB '#               |  |  (______/ |_| |_|\_____||_| \_)|_____)  /   /            #',13,10
		   DB '#               |   \_______________________________________/   /             #',13,10
	 	   DB '#                \                                             /              #',13,10
           DB '#                 \___________________________________________/               #',13,10
           DB '#                                                                             #',13,10
	 	   DB '#                                                                             #',13,10
           DB '#                                                                             #',13,10
           DB '#                                               CAROLINA OLIVEIRA - 21270477  #',13,10
           DB '#                                                   MIGUEL PRATES - 21280382  #',13,10
           DB '###############################################################################',13,10
           DB '#                                                                             #',13,10
           DB '#                                                                             #',13,10
           DB '#                           1 - CRIAR NOVO JOGO                               #',13,10
           DB '#                           2 - CONSULTAR ELEMENTOS ESTATISTICOS              #',13,10
           DB '#                           3 - SAIR                                          #',13,10
           DB '#                                                                             #',13,10
           DB '#                                                                             #',13,10
           DB '###############################################################################',13,10,'$'

MENUCONF   DB '###############################################################################',13,10
           DB '#                                                                             #',13,10
           DB '#           ______  _    ___ _             _     _           _                #',13,10
		   DB '#          (______)(_)  / __|_)           | |   | |         | |               #',13,10
		   DB '#           _     _ _ _| |__ _  ____ _   _| | __| |_____  __| |_____          #',13,10
		   DB '#          | |   | | (_   __) |/ ___) | | | |/ _  (____ |/ _  | ___ |         #',13,10
		   DB '#          | |__/ /| | | |  | ( (___| |_| | ( (_| / ___ ( (_| | ____|         #',13,10
		   DB '#          |_____/ |_| |_|  |_|\____)____/ \_)____\_____|\____|_____)         #',13,10
		   DB '#                                                                             #',13,10
		   DB '#                          1 - LESMA (NIVEL 1)                                #',13,10
           DB '#                          2 - LEBRE (NIVEL 2)                                #',13,10
           DB '#                          3 - CHITA (NIVEL 3)                                #',13,10
           DB '#                          4 - (NIVEL 4)		                                 #',13,10
		   DB '#                          5 - SAIR                                           #',13,10
           DB '#                                                                             #',13,10
           DB '###############################################################################',13,10,'$'	
		   
MENUSTAT   DB '###############################################################################',13,10
           DB '#                                                                             #',13,10
           DB '#         _______                                    _                        #',13,10
		   DB '#        (_______)       _           _          _   /_/                       #',13,10
		   DB '#         _____    ___ _| |_ _____ _| |_  ___ _| |_ _  ____ _____  ___        #',13,10
		   DB '#        |  ___)  /___|_   _|____ (_   _)/___|_   _) |/ ___|____ |/___)       #',13,10
		   DB '#        | |_____|___ | | |_/ ___ | | |_|___ | | |_| ( (___/ ___ |___ |       #',13,10
		   DB '#        |_______|___/   \__)_____|  \__|___/   \__)_|\____)_____(___/        #',13,10
		   DB '#                                                                             #',13,10
		   DB '#                                                                             #',13,10
		   DB '#                          1 - HISTORICO DE JOGOS                             #',13,10
           DB '#                          2 - VALORES ESTATISTICOS                           #',13,10
           DB '#                          3 - SAIR                                           #',13,10
           DB '#                                                                             #',13,10
           DB '#                                                                             #',13,10
           DB '###############################################################################',13,10,'$'		   

SAIRJOGO   DB '###############################################################################',13,10
           DB '#                                                                             #',13,10		   
		   DB '#                             DESEJA MESMO SAIR?                              #',13,10
		   DB '#                                                                             #',13,10
		   DB '#                       SIM [1]               NAO [2]                         #',13,10
		   DB '#                                                                             #',13,10
		   DB '###############################################################################',13,10,'$'

;########################################################################

; CRIA FICHEIRO DE TEXTO
	FNAME	DB	'PONTUACOES.TXT',0
	FHANDLE DW	0
	BUFFER	DB	'1 5 6 7 8 9 1 5 7 8 9 2 3 7 8 15 16 18 19 20 3',13,10
			DB 	'+ - / * * + - - + * / * + - - + * / + - - + * ',13,10
			DB	'10 12 14 7 9 11 13 5 10 15 7 8 9 10 13 5 10 11',13,10 
			DB 	'/ * + - - + * / + - / * * + - - + * * + - - + ',13,10
			DB	'3 45 23 11 4 7 14 18 31 27 19 9 6 47 19 9 6 51',13,10
			DB	'______________________________________________',13,10
	MSGERRORCREATE	DB	"OCORREU UM ERRO NA CRIACAO DO FICHEIRO!$"
	MSGERRORWRITE	DB	"OCORREU UM ERRO NA ESCRITA PARA FICHEIRO!$"
	MSGERRORCLOSE	DB	"OCORREU UM ERRO NO FECHO DO FICHEIRO!$"

;########################################################################

; ABRE FICHEIRO DE TEXTO
	ERRO_OPEN       DB      'ERRO AO TENTAR ABRIR O FICHEIRO$'
	ERRO_LER_MSG    DB      'ERRO AO TENTAR LER DO FICHEIRO$'
    ERRO_CLOSE      DB      'ERRO AO TENTAR FECHAR O FICHEIRO$'
	FICH         	DB      'MOLDURA.TXT',0
	HANDLEFICH      DW      0
	CAR_FICH        DB      ?

;########################################################################

; DESENHA TABULEIRO --- DELAY.ASM
	
	POSY	DB	10	; A LINHA PODE IR DE [1 .. 25]
	POSX	DB	40	; POSX PODE IR [1..80]	
	POSYA		DB	5	; POSIÇÃO ANTERIOR DE Y
	POSXA		DB	10	; POSIÇÃO ANTERIOR DE X
		
	PASSA_T		DW	0
	PASSA_T_ANT	DW	0
	DIRECCAO	DB	3
		
	CENTESIMOS	DW 	0
	FACTOR		DB	100
	METADE_FACTOR	DB	?
	RESTO		DB	0

;########################################################################

; CURSOR
	ULTIMO_NUM_ALEAT DW 0

	STR_NUM DB 5 DUP(?),'$'
	
	LINHA	DB	0	; DEFINE O NÚMERO DA LINHA QUE ESTÁ A SER DESENHADA
	NLINHAS	DB	0

	STRING	DB	"TESTE PRÁTICO DE T.A.C.",0
	CAR		DB	32	; GUARDA UM CARACTER DO ECRAN 
	COR		DB	7	; GUARDA OS ATRIBUTOS DE COR DO CARACTER
	CAR2	DB	32	; GUARDA UM CARACTER DO ECRAN 
	COR2	DB	7	; GUARDA OS ATRIBUTOS DE COR DO CARACTER
	;POSY	DB	12	; A LINHA PODE IR DE [1 .. 25]
	;POSX	DB	40	; POSX PODE IR [1..80]	
	;POSYA	DB	5	; POSIÇÃO ANTERIOR DE Y
	;POSXA	DB	10	; POSIÇÃO ANTERIOR DE X	


;########################################################################

; TEMPO



;########################################################################

; MACROS

;########################################################################

; PONTUACAO
BUFFER1	DB	'										',13,10
PONTUACAO	DW	'0'
MSGPONTOS	DB	"MSGPONTOS: ',13,10,'$"
STR12	 	db 		"            "				; String para 12 digitos	
POSyT	    db	    26				; a linha pode ir de [1 .. 25]
POSxT	    db	    81				; POSx pode ir [1..80]	




DADOS	ENDS

CODIGO	SEGMENT	PARA	PUBLIC	'CODE'
		ASSUME	CS:CODIGO, DS:DADOS, SS:PILHA
		
INICIO:
    MOV     AX, DADOS
    MOV     DS, AX
    MOV     AX,0B800H
    MOV     ES,AX

;########################################################################

; MOSTRA MENU PRINCIPAL
MOSTRAMENU:       
    CALL APAGA_ECRAN
    ;GOTO_XY 0,0
	
    LEA     DX, MENUJOGO
    MOV     AH, 09H
    INT     21H
    
    MOV     AH, 1
    INT     21H
    
	CMP		AL, '1'
	JL		MOSTRAMENU
	CMP		AL,'3'
	JG		MOSTRAMENU
	
	CMP		AL,'1'
	JE      MOSTRAMENUCONF
	CMP		AL,'2'
	JE		MOSTRAMENUSTAT
	CMP 	AL,'3'
	JE		FECHAJOGO

;########################################################################		
		
; MOSTRA MENU CONFIGURAR JOGO
MOSTRAMENUCONF:
	CALL APAGA_ECRAN
    LEA     DX, MENUCONF 
    MOV     AH, 09H 
    INT     21H 
     
    MOV     AH, 1 
    INT     21H        
    
    CMP     AL, '1' 
    JL      MOSTRAMENUCONF 
    CMP     AL, '5'
    JG      MOSTRAMENUCONF
        
    CMP     AL, "1"
    JE      JOGO	    ;factor = 100
    CMP     AL, "2"
	MOV		FACTOR, 50  ;factor = 50
    JE      JOGO
	CMP 	AL, "3"
	MOV		FACTOR, 25  ;factor = 25
	JE      JOGO
	CMP 	AL, "4"
	MOV		FACTOR, 10	;factor = 10
	JE      JOGO
    CMP     AL, "5"
    JE      MOSTRAMENU
		
;########################################################################		
		
; MOSTRA MENU ESTATISTICAS
MOSTRAMENUSTAT: 
    CALL APAGA_ECRAN
    LEA     DX, MENUSTAT 
    MOV     AH, 09H 
    INT     21H 
     
    MOV     AH, 1 
    INT     21H        
    
    CMP     AL, '1' 
    JL      MOSTRAMENUSTAT 
    CMP     AL, '3'
    JG      MOSTRAMENUSTAT 
        
    CMP     AL, "1"
    ;JE     HISTJOGOS	
    CMP     AL, "2"
    ;JE     VALSTAT
    CMP     AL, "3"
    JE      MOSTRAMENU
	
;########################################################################	
		
; MOSTRA MENU SAIR
FECHAJOGO:
	CALL APAGA_ECRAN
	
	LEA 	DX, SAIRJOGO
	MOV		AH, 09H
	INT		21H
	
	MOV		AH, 1
	INT		21H
	
	;GOTO_XY 0,23
	
	CMP		AL,'1'
	JB		FECHAJOGO
	CMP		AL,'2'
	JG		FECHAJOGO
	
	CMP		AL,'1'
	JE		SAIR
	CMP		AL,'2'
	JE		MOSTRAMENU

;########################################################################

;ROTINA PARA APAGAR ECRAN
APAGA_ECRAN	PROC
	PUSH BX
	PUSH AX
	PUSH CX
	PUSH SI
	XOR	BX,BX
	MOV	CX,24*80
	mov bx,160
	MOV SI,BX
APAGA:	
	MOV	AL,' '
	MOV	BYTE PTR ES:[BX],AL
	MOV	BYTE PTR ES:[BX+1],7
	INC	BX
	INC BX
	INC SI
	LOOP	APAGA
	POP SI
	POP CX
	POP AX
	POP BX
	RET
APAGA_ECRAN	ENDP


;########################################################################

; FUNCAO SAIR
SAIR:
	CALL APAGA_ECRAN
	MOV	AH,4CH
	INT	21H
	
;########################################################################

; MACROS


;########################################################################

; CURSOR


;########################################################################

; CRIA FICHEIRO



;########################################################################

; LER TECLA

;********************************************************************************
; LEITURA DE UMA TECLA DO TECLADO    (ALTERADO)
; LE UMA TECLA	E DEVOLVE VALOR EM AH E AL
; SE ah=0 É UMA TECLA NORMAL
; SE ah=1 É UMA TECLA EXTENDIDA
; AL DEVOLVE O CÓDIGO DA TECLA PREMIDA
; Se não foi premida tecla, devolve ah=0 e al = 0
;********************************************************************************
LE_TECLA_0	PROC
	;	CALL 	TRATA_HORAS
	;CALL CONTADOR
	
	
	MOV	AH,0BH
	INT 	21H
	CMP 	AL,0
	JNE	COM_TECLA
	MOV	AH, 0
	MOV	AL, 0
	JMP	SAI_TECLA
COM_TECLA:		
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

	
;########################################################################

; ABRE FICHEIRO


;########################################################################

; PASSA TEMPO
PASSA_TEMPO PROC	
 	
	MOV AH, 2CH             ; BUSCAR A HORAS
	INT 21H                 
	
 	XOR AX,AX
	MOV AL, DL              ; CENTESIMOS DE SEGUNDO PARA AX		
	MOV CENTESIMOS, AX
	
	MOV BL, FACTOR		; DEFINE VELOCIDADE DA SNAKE (100; 50; 33; 25; 20; 10)
	DIV BL
	MOV RESTO, AH
	MOV AL, FACTOR
	MOV AH, 0
	MOV BL, 2
	DIV BL
	MOV METADE_FACTOR, AL
	MOV AL, RESTO
	MOV AH, 0
	MOV BL, METADE_FACTOR	; DEVE FICAR SEMPRE COM METADE DO VALOR INICIAL
	MOV AH, 0
	CMP AX, BX
	JBE MENOR
	MOV AX, 1
	MOV PASSA_T, AX	
	JMP FIM_PASSA	
		
MENOR:
	MOV AX,0
	MOV PASSA_T, AX		

FIM_PASSA:	 

 	RET 
PASSA_TEMPO   ENDP


;########################################################################

; IMPRIMIR PONTUACAO
CONTADOR 	PROC
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	XOR AX,AX
	XOR BX,BX
	
	MOV AX, PONTUACAO
	MOV BX,AX
	MOV STR12[0],'P'
	MOV STR12[1],'O'
	MOV STR12[2],'N'
	MOV STR12[3],'T'
	MOV STR12[4],'U'
	MOV STR12[5],'A'
	MOV STR12[6],'C'
	MOV STR12[7],'A'
	MOV STR12[8],'O'
	MOV STR12[9],':'
	MOV STR12[10],' '
	MOV STR12[11],'_'			
	MOV STR12[12],'_'		
	MOV STR12[13],'$'
		
	GOTO_XY	55,0
	MOSTRA	STR12
		
FIM_HORAS:
	GOTO_XY	POSXT,POSYT			; VOLTA A COLOCAR O CURSOR ONDE ESTAVA ANTES DE ACTUALIZAR AS HORAS

	POPF
	POP DX
	POP CX
	POP BX
	POP AX
	RET

CONTADOR ENDP

;########################################################################

; TABULEIRO DE JOGO
IMP_FICH	PROC

;ABRE FICHEIRO

    MOV     AH,3DH			; VAMOS ABRIR FICHEIRO PARA LEITURA 
    MOV     AL,0			; TIPO DE FICHEIRO	
    LEA     DX,FICH			; NOME DO FICHEIRO
    INT     21H				; ABRE PARA LEITURA 
    JC      ERRO_ABRIR		; PODE ACONTER ERRO A ABRIR O FICHEIRO 
    MOV     HANDLEFICH,AX	; AX DEVOLVE O HANDLE PARA O FICHEIRO 
    JMP     LER_CICLO		; DEPOIS DE ABERO VAMOS LER O FICHEIRO 

ERRO_ABRIR:
    MOV     AH,09H
    LEA     DX,ERRO_OPEN
    INT     21H
    JMP     SAI

LER_CICLO:
    MOV     AH,3FH			; INDICA QUE VAI SER LIDO UM FICHEIRO 
    MOV     BX,HANDLEFICH	; BX DEVE CONTER O HANDLE DO FICHEIRO PREVIAMENTE ABERTO 
    MOV     CX,1			; NUMERO DE BYTES A LER 
    LEA     DX,CAR_FICH		; VAI LER PARA O LOCAL DE MEMORIA APONTADO POR DX (CAR_FICH)
    INT     21H				; FAZ EFECTIVAMENTE A LEITURA
	JC	    ERRO_LER		; SE CARRY É PORQUE ACONTECEU UM ERRO
	CMP	    AX,0			; EOF?	VERIFICA SE JÁ ESTAMOS NO FIM DO FICHEIRO 
	JE	    FECHA_FICHEIRO	; SE EOF FECHA O FICHEIRO 
    MOV     AH,02H			; COLOCA O CARACTER NO ECRAN
	MOV	    DL,CAR_FICH		; ESTE É O CARACTER A ENVIAR PARA O ECRAN
	INT	    21H				; IMPRIME NO ECRAN
	JMP	    LER_CICLO		; CONTINUA A LER O FICHEIRO

ERRO_LER:
    MOV     AH,09H
    LEA     DX,ERRO_LER_MSG
    INT     21H

FECHA_FICHEIRO:					; VAMOS FECHAR O FICHEIRO 
    MOV     AH,3EH
    MOV     BX,HANDLEFICH
    INT     21H
    JNC     SAI

    MOV     AH,09H			; O FICHEIRO PODE NÃO FECHAR CORRECTAMENTE
    LEA     DX,ERRO_CLOSE
    INT     21H
SAI:	  RET
IMP_FICH	ENDP


;########################################################################
;             MAIN
;########################################################################
JOGO    PROC
	MOV     AX,DADOS
	MOV     DS,AX
	MOV		AX,0B800H
	MOV		ES,AX		; ES INDICA SEGMENTO DE MEMÓRIA DE VIDEO
	CALL 	APAGA_ECRAN 
	CALL	IMP_FICH
	CALL 	CONTADOR
	CALL	MOVE_SNAKE
		
	MOV		AH,4CH
	INT		21H
JOGO    ENDP

; MOVE SNAKE
MOVE_SNAKE PROC
CALL CONTADOR
CICLO:	
	
	GOTO_XY		POSX,POSY	; VAI PARA NOVA POSSIÇÃO
	MOV 	AH, 08H	; GUARDA O CARACTER QUE ESTÁ NA POSIÇÃO DO CURSOR
	MOV		BH,0		; NUMERO DA PÁGINA
	INT		10H			
	CMP 	AL, '#'	;  NA POSIÇÃO DO CURSOR
	;GUARDA PONTUAÇÃO
	;APARECE GAME OVER
	JE		FIM

	GOTO_XY		POSXA,POSYA		; VAI PARA A POSIÇÃO ANTERIOR DO CURSOR
	MOV		AH, 02H
	MOV		DL, ' ' 	; COLOCA ESPAÇO
	INT		21H	

;QUANDO ANDA COLOCA ESPAÇO ATRÁS
	INC		POSXA
	GOTO_XY		POSXA,POSYA	
	MOV		AH, 02H
	MOV		DL, ' '		;  COLOCA ESPAÇO
	INT		21H	
	DEC 	POSXA
		
	GOTO_XY		POSX,POSY	; VAI PARA POSIÇÃO DO CURSOR

;INCREMENTA COBRA
;INCSNAKE:
	; GOTO_XY		POSXA,POSYA		; VAI PARA A POSIÇÃO ANTERIOR DO CURSOR
	; MOV		AH, 02H
	; CMP AH, ' '
	; JNE INCOBRA
	
;INCOBRA:	
	; MOV		DL, '(' 	; COLOCA ESPAÇO
	; INT		21H	

	; INC		POSXA
	; GOTO_XY		POSXA,POSYA	
	; MOV		AH, 02H
	; MOV		DL, ')'		;  COLOCA ESPAÇO
	; INT		21H	
	; DEC 	POSXA
		
	; GOTO_XY		POSX,POSY	; VAI PARA POSIÇÃO DO CURSOR


IMPRIME:

; para aumentar a cobra é:
; posição do cursor anterior
; coloca avatar 1
; coloca avatar 2
; guarda

	MOV		AH, 02H
	MOV		DL, '('	; COLOCA AVATAR1
	INT		21H
	
	INC		POSX
	GOTO_XY		POSX,POSY		
	MOV		AH, 02H
	MOV		DL, ')'	; COLOCA AVATAR2
	INT		21H	
	DEC		POSX
		
	GOTO_XY		POSX,POSY	; VAI PARA POSIÇÃO DO CURSOR
		
	MOV		AL, POSX	; GUARDA A POSIÇÃO DO CURSOR
	MOV		POSXA, AL
	MOV		AL, POSY	; GUARDA A POSIÇÃO DO CURSOR
	MOV 	POSYA, AL
		
LER_SETA:	
	CALL 	LE_TECLA_0
	CMP		AH, 1
	JE		ESTEND
	CMP 	AL, 27	; ESCAPE
	JE		FIM
	CMP		AL, '1'
	JNE		TESTE_2
	MOV		FACTOR, 100
TESTE_2:
	CMP		AL, '2'
	JNE		TESTE_3
	MOV		FACTOR, 50
TESTE_3:
	CMP		AL, '3'
	JNE		TESTE_4
	MOV		FACTOR, 25
TESTE_4:
	CMP		AL, '4'
	JNE		TESTE_END
	MOV		FACTOR, 10
TESTE_END:		
	CALL	PASSA_TEMPO
	MOV		AX, PASSA_T_ANT
	CMP		AX, PASSA_T
	JE		LER_SETA
	MOV		AX, PASSA_T
	MOV		PASSA_T_ANT, AX
		
VERIFICA_0:	
	MOV		AL, DIRECCAO
	CMP 	AL, 0
	JNE		VERIFICA_1
	
	INC		POSX		;DIREITA
	INC		POSX		;DIREITA
	JMP		CICLO
		
VERIFICA_1:	
	MOV 	AL, DIRECCAO
	CMP		AL, 1
	JNE		VERIFICA_2
	DEC		POSY		;CIMA
	JMP		CICLO
		
VERIFICA_2:	
	MOV 	AL, DIRECCAO
	CMP		AL, 2
	JNE		VERIFICA_3
	DEC		POSX		;ESQUERDA
	DEC		POSX		;ESQUERDA
	JMP		CICLO
		
VERIFICA_3:	
	MOV 	AL, DIRECCAO
	CMP		AL, 3		
	JNE		CICLO
	INC		POSY		;BAIXO		
	JMP		CICLO
		
ESTEND:
	CMP 		AL,48H
	JNE		BAIXO
	MOV		DIRECCAO, 1
	JMP		CICLO

BAIXO:
	CMP		AL,50H
	JNE		ESQUERDA
	MOV		DIRECCAO, 3
	JMP		CICLO

ESQUERDA:
	CMP		AL,4BH
	JNE		DIREITA
	MOV		DIRECCAO, 2
	JMP		CICLO

DIREITA:
	CMP		AL,4DH
	JNE		LER_SETA 
	MOV		DIRECCAO, 0	
	JMP		CICLO

FIM:
	GOTO_XY		40,23
	RET

MOVE_SNAKE ENDP



CODIGO	ENDS
END	INICIO
