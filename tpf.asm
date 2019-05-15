;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;| TRABALHO PRATICO TECNOLOGIAS E ARQUITETURA DE COMPUTADORES  |
;+                                                             +
;|                          2017/2018                          |
;+                                                             +
;| 							                                   |
;+ Beatriz Cardoso - 21270905                                  +
;| Carolina Oliveira - 21270477 			 				   |
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;|   117 - VARIÁVEIS TABELA DE PONTUAÇÕES                      |
;+	 141 - VARIÁVEIS PARA GERAR TABULEIRO ALEATÓRIO            +
;|	 153 - VARIÁVEIS DO CURSOR                                 |
;+	 167 - VARIÁVEIS DOS SLOTS DAS GRELHAS                     +
;|	 182 - VARIÁVEIS PARA O TEMPO                              |
;+	 210 - MACROS                                              +
;|	 237 - ROTINA PARA APAGAR ECRÃ                             |
;+	 256 - ROTINA PARA GERAR GRELHA ALEATÓRIA                  +
;|	 441 - CÓDIGO PARA O CURSOR                                |
;+	 471 - CÓDIGO PARA LER AS HORAS                            +
;|	 513 - CÓDIGO PARA LER O DIA                               |
;+	 614 - IMPRIME A DATA ATUAL E O TEMPO   				   +
;|	 695 - IMPRIME O CRONÓMETRO                   			   |	
;+	 753 - CÓDIGO DO CONTADOR DE PONTOS                        +
;|	 800 - FUNÇÕES PARA CRIAR GRELHAS                          |
;+	 821 - FUNÇÕES PARA EDITAR GRELHAS                         +
;|	 862 - FUNÇÕES PARA GUARDAR GRELHAS CRIADAS                |
;+	 956 - FUNÇÕES PARA JOGAR GRELHAS CRIADAS 				   +
;|	1026 - FUNÇÃO MOSTRAR TABELA    						   |
;+	1074 - FUNÇÃO GUARDAR JOGADOR             				   +
;|	1146 - FUNÇÃO EXPLOSÃO                        			   |
;+	1313 - INICIO                                              +
;|	1321 - CÓDIGO PARA MOSTRAR OS MENUS                        |
;+	1497 - COMEÇAR JOGO                                        +
;|	1638 - FUNÇÃO GUARDAR PONTUAÇÃO 					       |
;+	1649 - FUNÇÃO VER TABELA DE PONTUAÇÕES 					   +
;|	1659 - Sair                                                |
;+	1668 - end	INICIO                                         +
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

.8086
.MODEL SMALL
.STACK 2048

DADOS SEGMENT PARA PUBLIC 'DATA'
MenuJogo   db '              _______               ______  _ ',13,10
		   db '             (__   __)             (____  \| |              _ ',13,10
           db '                | | ___  _   _      ____)  ) | _____  ___ _| |_',13,10
           db '                | |/ _ \| | | |    |  __  (| |(____ |/___|_   _)',13,10
           db '                | | |_| | |_| |    | |__)  ) |/ ___ |___ | | |_',13,10
           db '                |_|\___/ \__  |    |______/ \_)_____(___/   \__)',13,10
           db '                        (____/',13,10
		   db ' ',13,10
           db ' ',13,10
		   db '                           1 - Iniciar Jogo',13,10
           db '                           2 - Tabela Pontuacoes',13,10
           db '                           3 - Configurar Grelha',13,10
           db '                           4 - Sair',13,10
           db ' ',13,10
           db ' ',13,10
           db ' ',13,10
		   db ' ',13,10
		   db ' ',13,10
           db '   Beatriz Cardoso - 21270905                   Carolina Oliveira - 21270477',13,10
           db ' ',13,10,'$'
		   
SubMenuC   db '                 _____             __  _  ',13,10
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
		   
SubMenuGrelhas   db ' ',13,10
				 db ' ',13,10
		         db ' ',13,10
		         db '                          Escolha a sua Grelha',13,10
		         db ' ',13,10
			     db ' ',13,10
				 db ' ',13,10
				 db ' ',13,10
				 db ' ',13,10
				 db '                           1 - Grelha 1',13,10
                 db '                           2 - Grelha 2',13,10
				 db '                           3 - Grelha 3',13,10
				 db '                           4 - Sair',13,10
				 db ' ',13,10,'$' 		   
  
SubMenuJ   db ' ',13,10
           db '                             __ ',13,10
		   db '                             \ \  ___   __    ___',13,10
		   db '                              \ \/ _ \ / _` |/ _ \ ',13,10
		   db '                           /\_/ / (_) | (_| | (_) |',13,10
		   db '                           \___/ \___/ \__, |\___/',13,10
		   db '                                       |___/',13,10
		   db '  ',13,10
		   db '  ',13,10
		   db '                           1 - Gerar Grelha Aleatoria',13,10
           db '                           2 - Carregar Grelha',13,10
           db '                           3 - Sair',13,10
           db ' ',13,10,'$'  		   

SairJogo   db '                             Deseja mesmo sair?',13,10
		   db ' ',13,10
		   db ' ',13,10
		   db '                        Sim [1]               Nao [2]',13,10,'$'
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			   VARIÁVEIS TABELA DE PONTUAÇÕES       		  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;>>>>>>>>>>>>>>>>>>>ABRIR FICHEIRO DE TEXTO<<<<<<<<<<<<<<<<<<<<
fname	db	'tabelat.txt',0
fhandle dw	0
msgnome DB "Introduza o seu nome : $"

msgErrorCreate	db	"Ocorreu um erro na criacao do ficheiro!$"
msgCreate	    db	"Ficheiro criado!$"
msgErrorWrite	db	"Ocorreu um erro na escrita para ficheiro!$"
msgErrorClose	db	"Ocorreu um erro no fecho do ficheiro!$"
ErrorOpen       db  ' Erro ao tentar abrir o ficheiro, confirme que criou o ficheiro primeiro$'
ErrorReading    db  ' Erro ao tentar ler do ficheiro$'
ErrorClose      db  ' Erro ao tentar fechar o ficheiro$'
	
buffer	db	'         Tabela TOP 10                  ',13,10

buffer1	db	'										',13,10
pontuacao	dw	'0'
msgpontos	db	"msgpontos: ',13,10,'$"

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;		  VARIÁVEIS PARA GERAR TABULEIRO ALEATÓRIO 	     	  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
ultimo_num_aleat dw 0
str_num 		 db 5 dup(?),'$'
linha			 db	0	; Define o número da linha que está a ser desenhada
nlinhas			 db	0
Cor3			 db 0
Car3		 	 db	' '	

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;					VARIÁVEIS DO CURSOR      	     		  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
string		db	"Teste prático de T.I",0
Car1		db	32	; Guarda um caracter do Ecran 
Cor1		db	7	; Guarda os atributos de cor do caracter
Car2		db	32	; Guarda um caracter do Ecran 
Cor2		db	7	; Guarda os atributos de cor do caracter
POSy		db	8	; a linha pode ir de [1 .. 25]
POSx		db	30	; POSx pode ir [1..80]	
POSya		db	8	; Posição anterior de y
POSxa		db	30	; Posição anterior de x
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			  VARIÁVEIS DOS SLOTS DAS GRELHAS     		      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
g1             db	'grelha1.TXT',0
handle1        dw      0
car_fich_gr1   db      ?
g2             db	'grelha2.TXT',0
handle2        dw      0
car_fich_gr2   db      ?
g3             db	'grelha3.TXT',0
handle3        dw      0
car_fich_gr3   db      ?

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			    VARIÁVEIS PARA O TEMPO        		    	  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
STR12	 	db 		"            "				; String para 12 digitos	
NUMERO		db		"                    $" 	; String destinada a guardar o número lido
NUM_SP		db		"                    $" 	; PAra apagar zona de ecran
DDMMAAAA 	db		"                     "
Horas		dw		0				; Vai guardar a HORA actual
Minutos		dw		0				; Vai guardar os minutos actuais
Segundos	dw		0				; Vai guardar os segundos actuais
Old_seg		dw		0				; Guarda os últimos segundos que foram lidos
POSyT	    db	    26				; a linha pode ir de [1 .. 25]
POSxT	    db	    81				; POSx pode ir [1..80]	
NUMDIG	    db	    0				; controla o numero de digitos do numero lido
MAXDIG	    db	    4				; Constante que define o numero MAXIMO de digitos a ser aceite
HorasA		dw		0				; Vai guardar a Hora anterior
MinutosA		dw	0				; Vai guardar os minutos anterior
SegundosA		dw	10				; Vai guardar os segundos anterior


DADOS	ENDS

CODIGO	SEGMENT	para 'code'
		ASSUME	CS:CODIGO, DS:DADOS
		

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			     			MACROS      		    	      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;>>>>>>>>>>>>>>>>>>>>>>>Mover o Cursor<<<<<<<<<<<<<<<<<<<<<<<<<
goto_xy	macro		POSx,POSy
	mov ah,02h
	mov bh,0		; numero da página
	mov dl,POSx
	mov dh,POSy
	int 10h
endm

;>>>>>>MOSTRA - Faz o display de uma string terminada em $<<<<<
MOSTRA MACRO STR 
	MOV AH,09H
	LEA DX,STR 
	INT 21H
ENDM
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;               		FIM MACROS							  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;		         ROTINA PARA APAGAR ECRÃ					  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

apaga_ecran	proc
	xor	bx,bx
	mov	cx,25*80
		
apaga:		
	mov	byte ptr es:[bx],' '
	mov	byte ptr es:[bx+1],7
	inc	bx
	inc bx
	loop apaga
	ret
apaga_ecran	endp

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			   ROTINA PARA GERAR GRELHA ALEATÓRIA       	  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
PRINC PROC

	mov	cx,10			; Faz o ciclo 10 vezes
ciclo4:
	call CalcAleat
	pop	ax 				; vai buscar à pilha o número aleatório

	mov	dl,cl	
	mov	dh,70
	push dx				; Passagem de parâmetros a impnum (posição do ecran)
	push ax				; Passagem de parâmetros a impnum (número a imprimir)
	call impnum			; imprime 10 aleatórios na parte direita do ecran
	loop ciclo4			; Ciclo de impressão dos números aleatórios
		
	mov ax, 0b800h		; Segmento de memória de vídeo onde vai ser desenhado o tabuleiro
	mov es, ax	
	mov	linha, 8		; O Tabuleiro vai começar a ser desenhado na linha 8 
	mov	nlinhas, 6		; O Tabuleiro vai ter 6 linhas
		
ciclo2:		
	mov	al, 160		
	mov	ah, linha
	mul	ah
	add	ax, 60
	mov bx, ax			; Determina Endereço onde começa a "linha". bx = 160*linha + 60

	mov	cx, 9			; São 9 colunas 

ciclo:  	
	mov dh,	Car3		; vai imprimir o caracter "SPACE"
	mov	es:[bx],dh		;
	
novacor:	
	call CalcAleat		; Calcula próximo aleatório que é colocado na pinha 
	pop ax ; 			; Vai buscar 'a pilha o número aleatório
	and al,01110000b	; posição do ecran com cor de fundo aleatório e caracter a preto
	cmp	al, 0			; Se o fundo de ecran é preto
	je	novacor			; vai buscar outra cor 

	mov dh, Car3		; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
	mov	es:[bx],dh		
	mov	es:[bx+1],al	; Coloca as características de cor da posição atual 
	inc	bx		
	inc	bx				; próxima posição e ecran dois bytes à frente 

	mov dh, Car3		; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
	mov	es:[bx],dh
	mov	es:[bx+1], al
	inc	bx
	inc	bx
		
	mov	di,1 			;delay de 1 centesimo de segundo
	call delay
	loop ciclo			; continua até fazer as 9 colunas que correspondem a uma liha completa
		
	inc	linha			; Vai desenhar a próxima linha
	dec	nlinhas			; contador de linhas
	mov	al, nlinhas	
	cmp	al, 0			; verifica se já desenhou todas as linhas 
	jne	ciclo2			; se ainda há linhas a desenhar continua 

PRINC ENDP

CalcAleat proc near

	sub		sp,2		; 
	push	bp
	mov		bp,sp
	push	ax
	push	cx
	push	dx	
	mov	ax,[bp+4]
	mov	[bp+2],ax

	mov	ah,00h
	int	1ah

	add	dx,ultimo_num_aleat		; vai buscar o aleatório anterior
	add	cx,dx	
	mov	ax,65521
	push	dx
	mul	cx			
	pop	dx			 
	xchg	dl,dh
	add	dx,32749
	add	dx,ax

	mov	ultimo_num_aleat,dx		; guarda o novo numero aleatório  

	mov	[BP+4],dx				; o aleatório é passado por pilha

	pop	dx
	pop	cx
	pop	ax
	pop	bp
	ret
CalcAleat endp

impnum proc near
	push bp
	mov	bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov	ax,[bp+4]	 ;param3
	lea	di,[str_num+5]
	mov	cx,5

prox_dig:
	xor	dx,dx
	mov	bx,10
	div	bx
	add	dl,'0'		; dh e' sempre 0
	dec	di
	mov	[di],dl
	loop	prox_dig

	mov	ah,02h
	mov	bh,00h
	mov	dl,[bp+7] 	;param1
	mov	dh,[bp+6] 	;param2
	int	10h
	mov	dx,di
	mov	ah,09h
	int	21h
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	4 			;limpa parametros (4 bytes) colocados na pilha
impnum endp


;recebe em di o número de milisegundos a esperar
delay proc
	pushf
	push	ax
	push	cx
	push	dx
	push	si
	
	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx
	mov	si,ax


ciclo:	
	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx

	cmp	ax,si 
	jnb	naoajusta
	add	ax,6000 ; 60 segundos

naoajusta:
	sub	ax,si
	cmp	ax,di
	jb	ciclo

	pop	si
	pop	dx
	pop	cx
	pop	ax
	popf
	ret

delay endp

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                CÓDIGO PARA O CURSOR						  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

LE_TECLA PROC
	call Trata_Horas
	call Contador
		
SEM_TECLA:
	call Trata_Horas
	call Contador
	MOV	AH,0BH
	INT 21h
	cmp AL,0
	je	sem_tecla
				
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
LE_TECLA ENDP

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                CÓDIGO PARA LER AS HORAS					  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;**************************************************************
; HORAS  - LE Hora DO SISTEMA E COLOCA em tres variaveis (Horas, Minutos, Segundos)
; CH - Horas, CL - Minutos, DH - Segundos
;**************************************************************	

Ler_TEMPO PROC	
 
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	PUSHF
		
	MOV AH, 2CH             ; Buscar a hORAS
	INT 21H                 
		
	XOR AX,AX
	MOV AL, DH              ; segundos para al
	mov Segundos, AX		; guarda segundos na variavel correspondente
		
	XOR AX,AX
	MOV AL, CL              ; Minutos para al
	mov Minutos, AX         ; guarda MINUTOS na variavel correspondente
		
	XOR AX,AX
	MOV AL, CH              ; Horas para al
	mov Horas,AX			; guarda HORAS na variavel correspondente
 
	POPF
	POP DX
	POP CX
	POP BX
	POP AX
	RET 
Ler_TEMPO   ENDP 

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                CÓDIGO PARA LER O DIA						  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;**************************************************************
; HOJE - LE DATA DO SISTEMA E COLOCA NUMA STRING NA FORMA DD/MM/AAAA
; CX - ANO, DH - MES, DL - DIA
;**************************************************************
HOJE PROC	

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSHF
		
	MOV AH, 2AH             ; Buscar a data
	INT 21H                 
	PUSH CX                 ; Ano-> PILHA
	XOR CX,CX              	; limpa CX
	MOV CL, DH              ; Mes para CL
	PUSH CX                 ; Mes-> PILHA
	MOV CL, DL				; Dia para CL
	PUSH CX                 ; Dia -> PILHA
	XOR DH,DH                    
	XOR	SI,SI
;>>>>>>>>>>>>>>>>>>>>>>>>>>>DIA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; DX=DX/AX --- RESTO DX   
	XOR DX,DX               ; Limpa DX
	POP AX                  ; Tira dia da pilha
	MOV CX, 0               ; CX = 0 
	MOV BX, 10              ; Divisor
	MOV	CX,2
DD_DIV:                         
	DIV BX                  ; Divide por 10
	PUSH DX                 ; Resto para pilha
	MOV DX, 0               ; Limpa resto
	loop dd_div
	MOV	CX,2
DD_RESTO:
	POP DX                  ; Resto da divisao
	ADD DL, 30h             ; ADD 30h (2) to DL
	MOV DDMMAAAA[SI],DL
	INC	SI
	LOOP DD_RESTO            
	MOV DL, '/'             ; Separador
	MOV DDMMAAAA[SI],DL
	INC SI
;>>>>>>>>>>>>>>>>>>>>>>>>>>>MÊS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; DX=DX/AX --- RESTO DX
	MOV DX, 0               ; Limpar DX
	POP AX                  ; Tira mes da pilha
	XOR CX,CX               
	MOV BX, 10				; Divisor
	MOV CX,2
MM_DIV:                         
	DIV BX                  ; Divisao or 10
	PUSH DX                 ; Resto para pilha
	MOV DX, 0               ; Limpa resto
	LOOP MM_DIV
	MOV CX,2 
MM_RESTO:
	POP DX                  ; Resto
	ADD DL, 30h             ; SOMA 30h
	MOV DDMMAAAA[SI],DL
	INC SI		
	LOOP MM_RESTO
		
	MOV DL, '/'             ; Character to display goes in DL
	MOV DDMMAAAA[SI],DL
	INC SI
 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>ANO<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	MOV DX, 0               
	POP AX                  ; mes para AX
	MOV CX, 0               ; 
	MOV BX, 10              ; 
 AA_DIV:                         
	DIV BX                   
	PUSH DX                 ; Guarda resto
	ADD CX, 1               ; Soma 1 contador
	MOV DX, 0               ; Limpa resto
	CMP AX, 0               ; Compara quotient com zero
	JNE AA_DIV              ; Se nao zero
AA_RESTO:
	POP DX                  
	ADD DL, 30h             ; ADD 30h (2) to DL
	MOV DDMMAAAA[SI],DL
	INC SI
	LOOP AA_RESTO
	POPF
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET 
HOJE   ENDP 

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;            IMPRIME A DATA ATUAL E O TEMPO	         		  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Trata_Horas PROC

	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX		

	CALL Ler_TEMPO			; Horas MINUTOS e segundos do Sistema
		
	MOV AX, Segundos
	cmp AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
	je fim_horas			; Se a hora não mudou desde a última leitura sai.
	mov Old_seg, AX			; Se segundos são diferentes actualiza informação do tempo 
		
	mov ax,Horas
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			; 
	MOV STR12[1],ah
	MOV STR12[2],'h'		
	MOV STR12[3],'$'
	GOTO_XY 66,19
	MOSTRA STR12 		
        
	mov ax,Minutos
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			; 
	MOV STR12[1],ah
	MOV STR12[2],'m'		
	MOV STR12[3],'$'
	GOTO_XY	70,19
	MOSTRA	STR12 		
		
	mov ax,Segundos
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			; 
	MOV STR12[1],ah
	MOV STR12[2],'s'		
	MOV STR12[3],'$'
	GOTO_XY	74,19
	MOSTRA	STR12 		
        
	CALL 	HOJE				; Data de HOJE
	MOV al ,DDMMAAAA[0]	
	MOV STR12[0], al	
	MOV al ,DDMMAAAA[1]	
	MOV STR12[1], al	
	MOV al ,DDMMAAAA[2]	
	MOV STR12[2], al	
	MOV al ,DDMMAAAA[3]	
	MOV STR12[3], al	
	MOV al ,DDMMAAAA[4]	
	MOV STR12[4], al	
	MOV al ,DDMMAAAA[5]	
	MOV STR12[5], al	
	MOV al ,DDMMAAAA[6]	
	MOV STR12[6], al	
	MOV al ,DDMMAAAA[7]	
	MOV STR12[7], al	
	MOV al ,DDMMAAAA[8]	
	MOV STR12[8], al
	MOV al ,DDMMAAAA[9]	
	MOV STR12[9], al		
	MOV STR12[10],'$'
	GOTO_XY	66,20
	MOSTRA	STR12 	
		
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;											 				  |
;                   IMPRIME O CRONÓMETRO	          		  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	mov ax,HorasA
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			 
	MOV STR12[1],ah
	MOV STR12[2],'h'		
	MOV STR12[3],'$'
	GOTO_XY 2,1
	MOSTRA STR12 		
        
	mov ax,MinutosA
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			
	MOV STR12[1],ah
	MOV STR12[2],'m'		
	MOV STR12[3],'$'
	GOTO_XY	6,1
	MOSTRA	STR12 		
		
	mov ax,SegundosA
	MOV bl, 10     
	div bl
	add al, 30h				; Caracter Correspondente às dezenas
	add ah,	30h				; Caracter Correspondente às unidades
	MOV STR12[0],al			
	MOV STR12[1],ah
	MOV STR12[2],'s'		
	MOV STR12[3],'$'
	GOTO_XY	10,1
	MOSTRA	STR12
	cmp  segundosA,0
	je gpontuacao
	mov ax,segundosA
	dec ax
	mov segundosA, ax
						
fim_horas:		
	goto_xy	POSxT,POSyT			; Volta a colocar o cursor onde estava antes de actualizar as horas
	
	POPF
	POP DX		
	POP CX
	POP BX
	POP AX
	RET		
			
Trata_Horas ENDP

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;             CÓDIGO DO CONTADOR DE PONTOS					  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Contador 	PROC
	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	xor ax,ax
	xor bx,bx
	
	mov ax, pontuacao
	mov bx,ax
	MOV STR12[0],'P'
	MOV STR12[1],'o'
	MOV STR12[2],'n'
	MOV STR12[3],'t'
	MOV STR12[4],'u'
	MOV STR12[5],'a'
	MOV STR12[6],'c'
	MOV STR12[7],'a'
	MOV STR12[8],'o'
	MOV STR12[9],':'
	MOV STR12[10],' '
	MOV STR12[11],bl			
	MOV STR12[12],bh		
	MOV STR12[13],'$'
		
	GOTO_XY	2,2
	MOSTRA	STR12
		
fim_horas:
	goto_xy	POSxT,POSyT			; Volta a colocar o cursor onde estava antes de actualizar as horas

	POPF
	POP DX
	POP CX
	POP BX
	POP AX
	RET

Contador ENDP

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;               FUNÇÕES PARA CRIAR GRELHAS				      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
grelha_1:
    call    apaga_ecran
    call    editargr
    jmp     GuardarGR1
grelha_2:
    call    apaga_ecran
    call    editargr
    jmp     GuardarGR2
grelha_3:
    call    apaga_ecran
    call    editargr
    jmp     GuardarGR3
editargr:

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<	

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;               FUNÇÕES PARA EDITAR GRELHAS				      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
EditarGrelha1:
	call  apaga_ecran
	mov   ah,3dh			; vamos abrir ficheiro para leitura 
    mov   al,0			; tipo de ficheiro	
    lea   dx,g1			; nome do ficheiro
    int   21h				; abre para leitura 
    lea	  dx, erroabrir		; pode aconter erro a abrir o ficheiro 
    mov   Handle1,ax		; ax devolve o Handle para o ficheiro 
    jmp   ler_ciclo1b		; depois de abero vamos ler o ficheiro 

ler_ciclo1b:
	mov  ah,3fh			; indica que vai ser lido um ficheiro 
    mov  bx,Handle1		; bx deve conter o Handle do ficheiro previamente aberto 
    mov  cx,1			; numero de bytes a ler 
	lea  dx,car_fich_gr1	; vai ler para o local de memoria apontado por dx (car_fich)
	int  21h			; faz efectivamente a leitura
	lea	 dx, ErrorReading		; se carry é porque aconteceu um erro
	cmp	 ax,0			; EOF? Verifica se já estamos no fim do ficheiro 
	je	 fecha_ficheiro1b	; se EOF fecha o ficheiro 
    mov  ah,02h			; coloca o caracter no ecran
    mov	 dl,car_fich_gr1		; este é o caracter a enviar para o ecran
    int	 21h			; imprime no ecran
    jmp	 ler_ciclo1b		; continua a ler o ficheiro

fecha_ficheiro1b:			; vamos fechar o ficheiro 
    mov  ah,3eh
    mov  bx,Handle1
    int  21h
 ;---------------------       
    call  editargr
    call  GuardarGR1

EditarGrelha2:

EditarGrelha3:

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;             FUNÇÕES PARA GUARDAR GRELHAS CRIADAS		      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
GuardarGR1:
	mov	ah, 3ch			; abrir ficheiro para escrita 
	mov	cx, 00H			; tipo de ficheiro
	lea	dx, g1			; dx contem endereco do nome do ficheiro 
	int	21h			    ; abre efectivamente e AX vai ficar com o Handle do ficheiro 
	jnc	escrever1		; se não acontecer erro vamos escrever
		
	mov	ah, 09h			; Aconteceu erro na leitura
	lea	dx, msgErrorCreate
	int	21h
		
	jmp	sair
	
escrever1:
	mov	bx, ax			; para escrever BX deve conter o Handle 
	mov	ah, 40h			; indica que vamos escrever 
			
	lea	dx, buffer		; Vamos escrever o que estiver no endereço DX
	mov	cx, 4000		; vamos escrever multiplos bytes duma vez só
	int	21h			    ; faz a escrita 
	jnc	close			; se não acontecer erro fecha o ficheiro 
		
	mov	ah, 09h
	lea	dx, msgErrorWrite
	int	21h

GuardarGR2:

	mov	ah, 3ch			; abrir ficheiro para escrita 
	mov	cx, 00H			; tipo de ficheiro
	lea	dx, g2			; dx contem endereco do nome do ficheiro 
	int	21h			    ; abre efectivamente e AX vai ficar com o Handle do ficheiro 
	jnc	escrever2		; se não acontecer erro vamos escrever
		
	mov	ah, 09h			; Aconteceu erro na leitura
	lea	dx, msgErrorCreate
	int	21h
		
	jmp	sair
	
escrever2:
	mov	bx, ax			; para escrever BX deve conter o Handle 
	mov	ah, 40h			; indica que vamos escrever 
			
	lea	dx, buffer		; Vamos escrever o que estiver no endereço DX
	mov	cx, 4000		; vamos escrever multiplos bytes duma vez só
	int	21h			    ; faz a escrita 
	jnc	close			; se não acontecer erro fecha o ficheiro 
		
	mov	ah, 09h
	lea	dx, msgErrorWrite
	int	21h
		
GuardarGR3:
	mov	ah, 3ch			; abrir ficheiro para escrita 
	mov	cx, 00H			; tipo de ficheiro
	lea	dx, g3			; dx contem endereco do nome do ficheiro 
	int	21h			    ; abre efectivamente e AX vai ficar com o Handle do ficheiro 
	jnc	escrever3		; se não acontecer erro vamos escrever
		
	mov	ah, 09h			; Aconteceu erro na leitura
	lea	dx, msgErrorCreate
	int	21h
		
	jmp	sair
	
escrever3:
	mov	bx, ax			; para escrever BX deve conter o Handle 
	mov	ah, 40h			; indica que vamos escrever 
			
	lea	dx, buffer		; Vamos escrever o que estiver no endereço DX
	mov	cx, 4000		; vamos escrever multiplos bytes duma vez só
	int	21h			    ; faz a escrita 
	jnc	close			; se não acontecer erro fecha o ficheiro 
		
	mov	ah, 09h
	lea	dx, msgErrorWrite
	int	21h
		
close:
	mov	ah,3eh			; indica que vamos fechar
	int	21h
    call apaga_ecran	; fecha mesmo
	jnc	sair			; se nao acontecer erro termina
	
	mov	ah, 09h
	lea	dx, msgErrorClose
	int	21h
    jmp MostraSubMenuC
; -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															   |
;				 FUNÇÕES PARA JOGAR GRELHAS CRIADAS		       +
;															   |
; -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
JogarGrelha1:
call    apaga_ecran
;abre ficheiro
	mov ah,3dh			; vamos abrir ficheiro para leitura 
	mov al,0			; tipo de ficheiro	
	lea dx,g1			; nome do ficheiro
	int 21h			    ; abre para leitura 
	jc  erroabrir		; pode aconter erro a abrir o ficheiro 
	mov Handle1,ax		; ax devolve o Handle para o ficheiro 
	jmp ler_ciclo1		; depois de abero vamos ler o ficheiro 

ler_ciclo1:
	mov ah,3fh			; indica que vai ser lido um ficheiro 
	mov bx,Handle1		; bx deve conter o Handle do ficheiro previamente aberto 
	mov cx,1			; numero de bytes a ler 
	lea dx,car_fich_gr1	; vai ler para o local de memoria apontado por dx (car_fich)
	int 21h				; faz efectivamente a leitura
	jc	erro_ler1		; se carry é porque aconteceu um erro
	cmp	ax,0			; EOF? Verifica se já estamos no fim do ficheiro 
	je	fecha_ficheiro1 ; se EOF fecha o ficheiro  
	mov     ah,02h		; coloca o caracter no ecran
	mov	dl,car_fich_gr1	; este é o caracter a enviar para o ecran
	int 21h				; imprime no ecran

	cmp car_fich_gr1,63 ; compara o caracter com o caracter especial "?"
	je ler_comeco1      ; se for igual guarda a posição de onde está o caracter

	jmp	ler_ciclo1		; continua a ler o ficheiro

ler_comeco1:
	push ax
	push bx
	push dx
	mov bh,0
	mov ah,03h
	int 10h
	dec dl           ; identação da leitura "puxa" o eixo X para a esquerda
	dec dh           ; identação da leitura "puxa" o eixo Y para baixo
	mov posx,dl
	mov posy,dh
	pop dx
	pop bx
	pop ax
	jmp ler_ciclo1

erro_ler1:
	mov ah,09h
	lea dx, ErrorReading
	int 21h 
erroabrir:
	mov ah,09h
	lea dx,ErrorOpen
	int 21h
	jmp Sair

fecha_ficheiro1:			;fecha o ficheiro
	mov ah,3eh
	mov bx,Handle1
	int 21h
	goto_xy 10,5

JogarGrelha2:

JogarGrelha3:

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;              		 FUNÇÃO MOSTRAR TABELA 				      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
top10 Proc

	mov ah, 3Ch				; Abrir o ficheiro para escrita
	mov cx, 00H				; Define o tipo de ficheiro (neste caso, texto)
	lea dx, fname			; DX aponta para o nome do ficheiro 
	int 21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	jnc escreve				; Se não existir erro escreve no ficheiro
	
	mov	 ah, 09h
	lea dx, msgErrorCreate
	int 21h
	
	jmp fim

escreve:
	mov bx, ax				; Coloca em BX o Handle
    mov ah, 40h				; indica que é para escrever
    	
	lea dx, buffer			; DX aponta para a informação a escrever
    mov cx, 52				; CX fica com o numero de bytes a escrever
	int 21h					; Chama a rotina de escrita
	jnc close1				; Se não existir erro na escrita fecha o ficheiro
	
	mov ah, 09h
	lea dx, msgErrorWrite
	int 21h
				
close1:
	mov ah,3eh				; fecha o ficheiro
	int 21h
	jnc fim
	
	mov ah, 09h
	lea dx, msgErrorClose
	int 21h
		
fim:
	mov ah, 09h
	lea dx, msgCreate
	int 21h
	jmp MostraMenu
	
top10 Endp
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;              		 FUNÇÃO GUARDAR JOGADOR				      +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
jogador proc
	
	lea dx, msgnome
	mov ah,09h
	int 21h

	mov cx,10
	xor si,si
	
input:
	mov ah,01h
	int 21h
	mov buffer1[si],ah
	inc si
	loop input
	
	call nomes
	
	jmp MostraMenu

jogador endp

nomes Proc

	mov ah, 3Ch				; Abrir o ficheiro para escrita
	mov cx, 00H				; Define o tipo de ficheiro (neste caso, texto)
	lea dx, fname			; DX aponta para o nome do ficheiro 
	int 21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	jnc escreve				; Se não existir erro escreve no ficheiro
	
	mov ah, 09h
	lea dx, msgErrorCreate
	int 21h
	
	jmp fim

escreve:
	mov bx, ax				; Coloca em BX o Handle
    mov ah, 40h				; indica que é para escrever
    	
	lea dx, buffer1			; DX aponta para a informação a escrever
    mov cx, 52				; CX fica com o numero de bytes a escrever
	int 21h					; Chama a rotina de escrita
	jnc close1				; Se não existir erro na escrita fecha o ficheiro
	
	mov ah, 09h
	lea dx, msgErrorWrite
	int 21h
		
		
close1:
	mov ah,3eh				; fecha o ficheiro
	int 21h
	jnc fim
	
	mov ah, 09h
	lea dx, msgErrorClose
	int 21h
		
fim:
	mov ah, 09h
	lea dx, msgCreate
	int 21h
	jmp MostraMenu
	
nomes Endp

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                      	FUNÇÃO EXPLOSÃO		    			  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
CICLO_COR:
;Com este ciclo é iniciada a comparação das cores à volta

COR_ATUAL_CIMA:
;Comparação da cor escolhida com a cor de cima
	goto_xy	 POSx,POSy
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0		
	int	10h	
	mov	ch, ah			; Guarda a cor que está na posição do Cursor em CH

	dec POSy 		    ; Passa para a cor de cima
	goto_xy	 POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0		
	int 10h
	mov cl, ah  		; Guarda a cor que está na posição do Cursor em CL
	cmp ch,cl
	je EXPLOSAO_CURSOR_CIMA	
	inc POSy            
	goto_xy	 POSxa,POSya; Decrementa/incrementa na mesma a posicao

		
COR_ATUAL_ESQUERDA:		
;Comparação da cor escolhida com a cor de à esquerda
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0
	int	10h	
	mov	ch, ah			; Guarda a cor que está na posição do Cursor em CH
		
	dec POSx			; Passa para a cor à esquerda
	dec POSx
	goto_xy	 POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0	
	int 10h
	mov cl, ah  		; Guarda a cor que está na posição do Cursor em CL
	cmp ch,cl
	je EXPLOSAO_CURSOR_ESQUERDA
		
	inc POSx  
	inc POSx
	goto_xy	 POSxa,POSya; Decrementa/incrementa na mesma a posicao

		
COR_ATUAL_DIREITA:
;Comparação da cor escolhida com a cor de à direita
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0
	int	10h	
	mov	ch, ah			; Guarda a cor que está na posição do Cursor em CH
		
	inc POSx			; Passa para a cor à direita
	inc POSx	
	goto_xy	 POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0
	int 10h
	mov cl, ah  		; Guarda a cor que está na posição do Cursor em CL
	cmp ch,cl
	je EXPLOSAO_CURSOR_DIREITA
		
	dec POSx
	dec POSx
	goto_xy	 POSx,POSy  ; Decrementa/incrementa na mesma a posicao
	
COR_ATUAL_BAIXO:
;Comparação da cor escolhida com a cor de em baixo
	goto_xy	 POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0
	int	10h	
	mov	ch, ah			; Guarda a cor que está na posição do Cursor em CH
		
	inc POSy			; Passa para a cor em baixo
	goto_xy	 POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov	bh,0
	int 10h
	mov cl,	ah  		; Guarda a cor que está na posição do cursor em cl
	cmp ch,cl
	je EXPLOSAO_CURSOR_BAIXO
		
	dec POSy            
	goto_xy	 POSxa,POSya; Mesmo fazendo voltar á posicao anterior temos que decrementar na mesma a posicao "dec POSX(Y)"
		
	cmp si,1
	je CODIGO_CURSOR_EXPLOSAO
		
	JMP CICLO   		; Salta novamente para o CICLO CURSOR
			
CODIGO_CURSOR_EXPLOSAO:
	call PROCESSO_EXPLODIR
	inc pontuacao
	mov si,0
	JMP CICLO
			
EXPLOSAO_CURSOR_CIMA:
	inc pontuacao
	call PROCESSO_EXPLODIR
	inc POSy
	goto_xy	 POSx,POSy
	mov si,1
	jmp COR_ATUAL_ESQUERDA
			
EXPLOSAO_CURSOR_ESQUERDA:
	inc pontuacao
	call PROCESSO_EXPLODIR
	inc POSx
	inc POSx
	goto_xy	 POSx,POSy	
	mov si,1
	jmp COR_ATUAL_DIREITA
	
EXPLOSAO_CURSOR_DIREITA:
	inc pontuacao
	call PROCESSO_EXPLODIR
	dec POSx
	dec POSx
	goto_xy	 POSx,POSy
	mov si,1
	jmp COR_ATUAL_BAIXO	
		
EXPLOSAO_CURSOR_BAIXO:
	inc pontuacao
	call PROCESSO_EXPLODIR
	dec POSy  
	goto_xy	 POSx,POSy		
	mov si,1
	jmp CODIGO_CURSOR_EXPLOSAO	
		
PROCESSO_EXPLODIR proc		
	mov ah,03h  		; Recebe o tamanho e a posição do cursor
	mov bh,0			; Guarda em DH-Linha e em DL-Coluna
	int 10h
		
	mov al,dh  			;passa a linha para al
	mov bl,160  
	mul bl     			;multiplica 160 pelo o nº da linha 
	mov cx,ax 
	mov al,dl  			;passa para a coluna para al
	mov bl,2   
	mul bl     			; multiplica 2 pelo o nº da coluna
	mov dx,ax
	ADD cx,dx  			; Soma o resultado do nº da linha com o nº da coluna
	mov bx,cx  			; guarda esse resultado em bx para depois gravar nessa posicao
		
;BX tem neste momento a posicao atual do cursor.
	mov al,00001000b	;Atribui a cor preta
	mov	es:[bx],ah		
	mov	es:[bx+1],al	; Coloca as características de cor da posição atual 
	inc	bx		
	inc	bx				; próxima posição e ecran dois bytes à frente 

; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecra
; Se nao repetir apenas pinta metade do "pixel" de preto.
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
		
	ret 
PROCESSO_EXPLODIR endp

 INICIO:
	MOV AX, DADOS
	MOV DS, AX
	MOV AX,0B800h
	MOV ES,AX

;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;			     CÓDIGO PARA MOSTRAR OS MENUS				  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
MostraMenu:       
    call apaga_ecran
;>>>>>>>>>>>>>>>>>>>>>>>MOSTRA O MENU<<<<<<<<<<<<<<<<<<<<<<<<<<
    goto_xy 0,10
	
	lea dx, MenuJogo
	mov ah, 09h
	int 21h
        
	mov ah, 1
	int 21h
    
	cmp al, '1'
	jl MostraMenu
	cmp al,'4'
	jg MostraMenu
		
	cmp al,'1'
	je MostraSubMenuJ
	cmp al,'2'
	je Tabela
	cmp al,'3'
	je MostraSubMenuC
	cmp al,'4'
	je FechaJogo
		
;>>>>>>>MOSTRA O SUBMENU DA CONFIGURAÇÃO, OPÇÃO 3 DO MENU<<<<<
MostraSubMenuC: 
	call apaga_ecran
	goto_xy 0,3
	lea dx, SubMenuC 
	mov ah, 09h 
	int 21h 
     
	mov ah, 1 
	int 21h        
    
	cmp al, '1' 
	jl MostraSubMenuC 
	cmp al, '3'
	jg MostraSubMenuC 
        
	cmp al, "1"
	je MostraSlotC	
	cmp al, "2"
	je MostraSlotE
	cmp al, "3"
    je MostraMenu
		
;>>>>>>>>>>>>MOSTRA O SUBMENU DO JOGO, OPÇÃO 1 DO MENU<<<<<<<<<
MostraSubMenuJ:
    call apaga_ecran
	goto_xy 0,6
		
    lea dx, SubMenuJ 
    mov ah, 09h 
    int 21h 
     
    mov ah, 1 
    int 21h        
    
    cmp al, '1' 
    jl MostraSubMenuJ 
    cmp al, '3'
    jg MostraSubMenuJ 
        
    cmp al, "1"
    je Jogo	
    cmp al, "2"
    je MostraSlotJ
    cmp al, "3"
    je MostraMenu

;>>>>>>>>>>>>MOSTRA OS SLOTS PARA CRIAR GRELHAS<<<<<<<<<<<<<<<<<
MostraSlotC:
	call apaga_ecran
	goto_xy 0,7
	
    lea dx, SubMenuGrelhas
    mov ah, 09h 
    int 21h 
        
    mov ah, 1 
    int 21h        
    
    cmp al, '1' 
    jl MostraSlotC
    cmp al, '4'
    jg MostraSlotC
        
    cmp al, "1"
    je grelha_1
    cmp al, "2"
    je grelha_2
    cmp al, "3"
    je grelha_3
    cmp al, "4"
    jmp MostraSubMenuC
	
;>>>>>>>>>>MOSTRA OS SLOTS PARA JOGAR GRELHAS CRIADAS<<<<<<<<<<<
MostraSlotJ:
	call apaga_ecran
	goto_xy 0,7
	
    lea dx, SubMenuGrelhas
    mov ah, 09h 
    int 21h 
       
    mov ah, 1 
    int 21h        
    
    cmp al, '1' 
    jl MostraSlotJ
    cmp al, '4'
    jg MostraSlotJ
        
    cmp al, "1"
    je JogarGrelha1
    cmp al, "2"
    je JogarGrelha1
    cmp al, "3"
    je JogarGrelha1
    cmp al, "4"
    jmp MostraSubMenuJ
	
;>>>>>>>>>>MOSTRA OS SLOTS PARA EDITAR GRELHAS CRIADAS<<<<<<<<<<
MostraSlotE:
    call apaga_ecran

    lea dx, SubMenuGrelhas
    mov ah, 09h 
    int 21h 
   
    mov ah, 1 
    int 21h        
    
    cmp al, '1' 
    jl MostraSlotE
    cmp al, '4'
    jg MostraSlotE
        
    cmp al, "1"
    je EditarGrelha1
    cmp al, "2"
    je EditarGrelha2
    cmp al, "3"
    je EditarGrelha3
    cmp al, "4"
    jmp MostraSubMenuC
	
;>>>>>>>>>>>>>>>>>>>>>>>>MOSTRA SAIR<<<<<<<<<<<<<<<<<<<<<<<<<<<<
FechaJogo:
	call apaga_ecran
	goto_xy 0,10
	lea dx, SairJogo
	mov ah, 09h
	int 21h
	
	mov ah, 1
	int 21h
	
	cmp al,'1'
	jb FechaJogo
	cmp al,'2'
	jg FechaJogo
	
	cmp al,'1'
	je Sair
	cmp al,'2'
	je MostraMenu
	
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;						COMEÇAR JOGO				          +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Jogo:		
	call apaga_ecran

	mov SegundosA,60	;quando começa um jogo novo o tempo volta novamente a 60
	;mov pontuacao,0	;quando começa um jogo novo a pontuacao volta novamente a 0
	call PRINC


	goto_xy POSx,POSy	; Vai para nova posição
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov bh,0			; numero da página
	int 10h			
	mov Car3, al		; Guarda o Caracter que está na posição do Cursor
	mov Cor3, ah		; Guarda a cor que está na posição do Cursor	
		
	inc POSx
	goto_xy POSx,POSy	; Vai para nova possição2
	mov ah, 08h			; Guarda o Caracter que está na posição do Cursor
	mov bh,0			; numero da página
	int 10h			
	mov Car2, al		; Guarda o Caracter que está na posição do Cursor
	mov Cor2, ah		; Guarda a cor que está na posição do Cursor	
	dec POSx

	
CICLO:		
	goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
	mov ah, 02h
	mov dl, Car3		; Repoe Caracter guardado 
	int 21H	

	inc POSxa
	goto_xy POSxa,POSya	
	mov ah, 02h
	mov dl, Car2		; Repoe Caracter2 guardado 
	int 21H	
	dec POSxa
		
	goto_xy	POSx,POSy	; Vai para nova possição
	mov ah, 08h
	mov bh,0			; numero da página
	int 10h		
	mov Car3, al		; Guarda o Caracter que está na posição do Cursor
	mov Cor3, ah		; Guarda a cor que está na posição do Cursor
		
	inc POSx
	goto_xy POSx,POSy	; Vai para nova possição
	mov ah, 08h
	mov bh,0			; numero da página
	int 10h		
	mov Car2, al		; Guarda o Caracter2 que está na posição do Cursor2
	mov Cor2, ah		; Guarda a cor que está na posição do Cursor2
	dec POSx
		
	goto_xy 77,0		; Mostra o caractr que estava na posição do AVATAR
	mov ah, 02h			; IMPRIME caracter da posição no canto
	mov dl, Car3	
	int 21H			
		
	goto_xy 78,0		; Mostra o caractr2 que estava na posição do AVATAR
	mov ah, 02h			; IMPRIME caracter2 da posição no canto
	mov dl, Car2	
	int 21H			
		
	goto_xy POSx,POSy	; Vai para posição do cursor
		
IMPRIME:	
	mov ah, 02h
	mov dl, '('			; Coloca AVATAR1
	int 21H
		
	inc POSx
	goto_xy POSx,POSy		
	mov ah, 02h
	mov dl, ')'			; Coloca AVATAR2
	int 21H	
	dec POSx
		
	goto_xy POSx,POSy	; Vai para posição do cursor
		
	mov al, POSx		; Guarda a posição do cursor
	mov POSxa, al
	mov al, POSy		; Guarda a posição do cursor
	mov POSya, al
		
LER_SETA:	
	call LE_TECLA
	cmp ah, 1
	je ESTEND
	cmp AL, 13 			;Enter
	je CICLO_COR 	    ;Selecionado o enter
	CMP AL, 27			; ESCAPE
	JE MostraMenu		; FAZER FUNÇÃO PARA GUARDAR JOGO NO FIM DO TEMPO
	jmp LER_SETA
	
ESTEND:					; max cima: 8
	cmp POSy,8
	je BAIXO	
	cmp al,48h
	jne BAIXO
	dec POSy			;cima
	jmp CICLO

BAIXO:					; max baixo: 13
	cmp POSy,13
	je ESQUERDA
		
	cmp al,50h
	jne ESQUERDA
	inc POSy			;Baixo
	jmp CICLO
	
ESQUERDA:			    ; max esquerda: 30
	cmp POSx,30
	je DIREITA
	cmp al,4Bh
	jne DIREITA
	dec POSx			;Esquerda
	dec POSx			;Esquerda

	jmp CICLO

DIREITA:				; max direita: 46
	cmp POSx,46
	je CICLO
		
	cmp al,4Dh
	jne LER_SETA
	inc POSx			;Direita
	inc POSx			;Direita
		
	jmp CICLO
	
jmp FechaJogo


;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                FUNÇÃO GUARDAR PONTUAÇÃO					  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
gpontuacao:
	call apaga_ecran
	call jogador
	jmp MostraMenu


;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;              FUNÇÃO VER TABELA DE PONTUAÇÕES				  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Tabela:
	call apaga_ecran
	call top10


;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;															  |
;                      		Sair							  +
;															  |
;-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+	
Sair:
	call apaga_ecran
	MOV	AH,4Ch
	INT	21h
	
CODIGO	ends
end	INICIO