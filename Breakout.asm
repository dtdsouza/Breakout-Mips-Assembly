.data
Reserva:	.space 48000
breakout:	.asciiz "BREAKOUT\n"
jogar:		.asciiz "1.PLAY\n"
sair:		.asciiz "2.QUIT\n"
facil:		.asciiz "1.EASY\n"
medio:		.asciiz "2.MEDIUM\n"
dificil:	.asciiz "3.HARD\n"
extremo:	.asciiz "4.EXPERT\n"
inf:		.asciiz "GO TO DISPLAY AND KEYBOARD\n"
infdois:	.asciiz "PRESS ANY BUTTON\n"
vit:		.asciiz "WIN\n"
der:		.asciiz "LOSE\n"
enter:		.asciiz "\n"
jdnv:		.asciiz "PRESS 1 TO PLAY AGAIN OR ANOTHER BUTTON TO QUIT\N"

#0x00ffffff branco
#0x0000ff00 verde
#0x00ff1cae rosa
#0x002f4f2f verde escuro
#0x00C54849 vermelho
.text

main:	
	#zerador
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	
	
	li $t0, 0x00ffffff	#carrega a cor
	li $t1, 1024		#limite de pixels
	lui $t2, 0x1001		#inicio do display
	li $t3, 64		#linhas e colunas
	li $t4, 5		#quantidade de linhas dos blocos
	li $t5, 55		#constante para mover o "pincel"
	li $t6, 2		#linhas do game over
	li $t7, 2		#traco de defesa
	lui $s0, 0x1001
	addi $s0, $s0, 15736	#movimento da defesa

loopprint:	#escreve os blocos
	
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t3, $t3, -1
	bgtz $t3, loopprint
	nop
	li $t3, 64
	addi $t4, $t4, -1
	bgtz $t4, loopprint
	nop

loopmove:	#move pra o traco de defesa
			
	addi $t2, $t2, 4
	addi $t3, $t3, -1
	bgtz $t3, loopmove
	nop
	li $t3, 64
	addi $t5, $t5, -1
	bgtz $t5, loopmove
	nop
	
	addi $t2, $t2, 128	#insere a bola	Obs:nesse caso é incrementado 32 posicoes, pois cada posicao sao 4 bits
	li $t0, 0x00ff1cae	
	sw $t0, ($t2)
	addi $t2, $t2, 128
	
	addi $t2, $t2, 120	#printa traco de defesa/ pontas verde esuco e meio verde claro
	li $t0, 0x002f4f2f	#verde escuro
	loopdefa:
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t7, $t7, -1
	bgtz $t7, loopdefa
	nop	
	li $t0, 0x006bbe23	#verde medio
	li $t7, 2
	loopdefb:
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t7, $t7, -1
	bgtz $t7, loopdefb
	nop
	li $t0, 0x0000ff00	#verde claro
	li $t7, 2
	loopdefc:
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t7, $t7, -1
	bgtz $t7, loopdefc
	nop
	addi $t2, $t2, 112
	
gameover:	#printa o traco da derrota
	
	li $t0, 0x00C54849	#vermelho
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t3, $t3, -1
	bgtz $t3, gameover
	nop
	li $t3, 64
	addi $t6, $t6, -1
	bgtz $t6, gameover
	nop


#zerador
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0

#linha de limite
	
	lui $t0, 0x1001
	li $t1, 0x005c3317
	li $t2, 0
	laco:
	sw $t1, ($t0)
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	beq $t2, 64, endlaco
	nop
	j laco
	nop
	endlaco:
	
	lui $t0, 0x1001		
	li $t1, 0x005c3317	#marrom
	li $t2, 0
	lachori:
	addi $t0, $t0, 256
	sw $t1, ($t0)
	addi $t0, $t0, 252
	sw $t1, ($t0)
	addi $t0, $t0, -252
	addi $t2, $t2, 1
	beq $t2, 61, endlhori
	nop
	j lachori
	nop
	endlhori:
	
	
#zerador
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0

#comunicacao com o usuario
	
	li $v0, 4
	la $a0, breakout
	syscall
	la $a0, jogar
	syscall
	la $a0, sair
	syscall
	new:
	li $v0, 5
	syscall
	beq $v0, 1, opc1
	nop
	beq $v0, 2, opc2
	nop
	j new
	nop
	opc1:
	la $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, jogar
	syscall
	la $a0, facil
	syscall
	la $a0, medio
	syscall
	la $a0, dificil
	syscall
	la $a0, extremo
	syscall
	trab:
	li $v0, 5
	syscall
	beq $v0, 1, easy
	nop
	beq $v0, 2, medium
	nop
	beq $v0, 3, hard
	nop
	beq $v0, 4, extreme
	nop
	j trab
	nop
	easy:
	li $t7, 10
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, facil
	syscall
	la $a0, inf
	syscall
	la $a0, infdois
	syscall
	j start
	nop
	medium:
	li $t7, 30
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, medio
	syscall
	la $a0, inf
	syscall
	la $a0, infdois
	syscall
	j start
	nop
	hard:
	li $t7, 50
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, dificil
	syscall
	la $a0, inf
	syscall
	la $a0, infdois
	syscall
	j start
	nop
	extreme:
	li $t7, 100
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, extremo
	syscall
	la $a0, inf
	syscall
	la $a0, infdois
	syscall
	j start
	nop
	
	
	opc2:		#encerra
	li $v0, 10
	syscall
	

#logica do jogo
	start:
	#zerador
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	
	li $t3, 0x00ff1cae
	lui $t0, 0x1001		#ponteiro para o endereço da bola
	addi $t0, $t0, 15488
	li $t1, 10000		#constante para controle do tempo do jogo, caso esteja rapido aumentar, caso esteja lento diminuir
	
	#condiçao para so iniciar apos o usuario apertar alguma tecla
	naoiniciado:
	lui $t9, 0xffff
	addi $t9, $t9, 4
	lw $t5, ($t9)
	beqz $t5, naoiniciado
	nop			
	#-----------------------------------------------------------
	
	#verifica a cada movimento da bola se foi digitado algo
	cima:
	lui $t9, 0xffff
	addi $t9, $t9, 4		
	lw $t5, ($t9)			
	
	
	#peso para ajustar a jogabilidade com o tempo( se tirar o jogo fica muito rapido)
	move $t8, $t1
	lopes1:			#ver
	addi $t8, $t8, -1		
	beqz $t8, pass1
	nop
	j lopes1
	nop
	pass1:
	#--------------------------------------------------------------------------------
	
	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up1
	nop	
	jal moveesquerda
	nop
	up1:
	bne $t5, 54, before1
	nop
	jal movedireita
	nop
	
	
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before1:
	nop
	move $t4, $t0
	addi $t4, $t4, -256	#verifica se acertou no bloco
	move $t2, $t0
	lw $t2, ($t4)
	beq $t2, 0x005c3317, baixo
	nop
	move $t2, $t0
	lw $t6, ($t4)
	bnez $t6, acerto
	nop
	addi $t0, $t0, -256	
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j cima
	nop
	
	#verifica a cada movimento da bola se foi digitado algo
	baixo:
	lui $t9, 0xffff
	addi $t9, $t9, 4
	lw $t5, ($t9)		
	
	
	#peso para ajustar a jogabilidade com o tempo( se diminuir o jogo fica rapido)
	move $t8, $t1
	lopes2:			#ver
	addi $t8, $t8, -1		
	beqz $t8, pass2
	nop
	j lopes2
	nop
	pass2:
	nop
	#--------------------------------------------------------------------------------
	
	
	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up2
	nop
	jal moveesquerda
	nop
	up2:
	bne $t5, 54, before2
	nop
	jal movedireita
	nop
	
	
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before2:
	move $t2, $t0
	move $t4, $t0
	addi $t4, $t4, 256
	lw $t6, ($t4)	
	beq $t6, 0x002f4f2f, cimaesquerda	#volta para cima/esquerda(acerta o verde escuro)
	nop
	beq $t6, 0x006bbe23, cima		#volta pra cima(acerta o verde medio)
	nop
	beq $t6, 0x0000ff00, cimadireita	#volta pra cima/direita(acerta o verde claro)
	nop					#perde(acerta a area vermelha)
	beq $t6, 0x00C54849, derrota
	nop
	addi $t0, $t0, 256
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j baixo
	nop
	
	#verifica a cada movimento da bola se foi digitado algo
	cimadireita:
	lui $t9, 0xffff
	addi $t9, $t9, 4		
	lw $t5, ($t9)
	
	
	#peso para ajustar a jogabilidade com o tempo( se tirar o jogo fica muito rapido)
	move $t8, $t1
	lopes3:			#ver
	addi $t8, $t8, -1		
	beqz $t8, pass3
	nop
	j lopes3
	nop
	pass3:
	nop
	#--------------------------------------------------------------------------------
	
	
	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up3
	nop
	jal moveesquerda
	nop
	up3:
	bne $t5, 54, before3
	nop
	jal movedireita
	nop
	
	
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before3:
	move $t2, $t0
	move $t4, $t0
	addi $t4, $t4, -256	#verifica se acertou no bloco
	lw $t6, ($t4)
	bnez $t6, acerto
	nop
	addi $t4, $t4, 260
	lw $t6, ($t4)
	beq $t6, 0x005c3317, cimaesquerda
	nop
	addi $t0, $t0, -252	
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j cimadireita
	nop
	
	#verifica a cada movimento da bola se foi digitado algo
	baixodireita:
	lui $t9, 0xffff
	addi $t9, $t9, 4	
	lw $t5, ($t9)
	
	
	#peso para ajustar a jogabilidade com o tempo( se tirar o jogo fica muito rapido)
	move $t8, $t1
	lopes4:			#ver
	addi $t8, $t8, -1		
	beqz $t8, pass4
	nop
	j lopes4
	nop
	pass4:
	nop
	#--------------------------------------------------------------------------------
	

	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up4
	nop
	jal moveesquerda
	nop
	up4:
	bne $t5, 54, before4
	nop
	jal movedireita
	nop

		
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before4:
	move $t2, $t0
	move $t4, $t0
	addi $t4, $t4, 256
	lw $t6, ($t4)
	beq $t6, 0x002f4f2f, cimaesquerda	#volta para cima/esquerda(acerta o verde escuro)
	nop
	beq $t6, 0x006bbe23, cima		#volta pra cima(acerta o verde medio)
	nop
	beq $t6, 0x0000ff00, cimadireita	#volta pra cima/direita(acerta o verde claro)
	nop
	beq $t6, 0x00C54849, derrota
	nop
	addi $t4, $t4, -252
	lw $t6, ($t4)
	beq $t6, 0x005c3317, baixoesquerda
	nop
	addi $t0, $t0, 260
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j baixodireita
	nop
	
	
	#verifica a cada movimento da bola se foi digitado algo
	cimaesquerda:
	lui $t9, 0xffff
	addi $t9, $t9, 4
	lw $t5, ($t9)		#movimento do traco
	
	
	#peso para ajustar a jogabilidade com o tempo( se tirar o jogo fica muito rapido)
	move $t8, $t1
	lopes5:
	addi $t8, $t8, -1		
	beqz $t8, pass5
	nop
	j lopes5
	nop
	pass5:
	#--------------------------------------------------------------------------------
	
	
	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up5
	nop
	jal moveesquerda
	nop
	up5:
	bne $t5, 54, before5
	nop
	jal movedireita
	nop
	
	
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before5:	
	nop
	move $t2, $t0
	move $t4, $t0
	addi $t4, $t4, -256	#verifica se acertou no bloco
	lw $t6, ($t4)
	bnez $t6, acerto
	nop
	addi $t4, $t4, 252
	lw $t6, ($t4)
	beq $t6, 0x005c3317, cimadireita
	nop
	addi $t0, $t0, -260
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j cimaesquerda
	nop
	
	#verifica a cada movimento da bola se foi digitado algo
	baixoesquerda:
	lui $t9, 0xffff
	addi $t9, $t9, 4
	lw $t5, ($t9)		#movimento do traco
	
	
	#peso para ajustar a jogabilidade com o tempo( se tirar o jogo fica muito rapido)
	move $t8, $t1
	lopes6:		
	addi $t8, $t8, -1		
	beqz $t8, pass6
	nop
	j lopes6
	nop
	pass6:
	nop
	#--------------------------------------------------------------------------------
	

	#verifica se algo foi digitado, e se foi tomar as devidas atitudes
	bne $t5, 52, up6
	nop
	jal moveesquerda
	nop
	up6:
	bne $t5, 54, before6
	nop
	jal movedireita
	nop
	
	#caso nao for digitado um caractere valido, a bola continua o movimento
	before6:
	move $t2, $t0
	move $t4, $t0
	addi $t4, $t4, 256
	lw $t6, ($t4)
	beq $t6, 0x002f4f2f, cimaesquerda	#volta para cima/esquerda(acerta o verde escuro)
	nop
	beq $t6, 0x006bbe23, cima		#volta pra cima(acerta o verde medio)
	nop
	beq $t6, 0x0000ff00, cimadireita	#volta pra cima/direita(acerta o verde claro)
	nop
	beq $t6, 0x00C54849, derrota
	nop
	addi $t4, $t4, -260
	lw $t6, ($t4)
	beq $t6, 0x005c3317, baixodireita
	nop
	addi $t0, $t0, 252
	sw $zero ($t2)		#apaga rastro
	sw $t3, ($t0)
	j baixoesquerda
	nop
	
acerto:
	li $s7, 3
	sw $zero, ($t4)
	addi $s6, $s6, 1
	beq $s6, $t7, vitoria		#t7 é a dificuldade do game
	nop
	div $s6, $s7
	mfhi $s7
	beq $s7, 0, opum
	nop
	beq $s7, 1, opdois
	nop
	beq $s7, 2, optres
	nop
	opum:
	j baixo
	nop
	opdois:
	j baixoesquerda
	nop
	optres:
	j baixodireita
	nop

moveesquerda:
	move $s1, $s0
	addi $s1, $s1, -4	
	beq $s1, 268516608, kp	#caso chegue no limite da tela nao move mais
	nop
	move $s4, $s1		#endereco atual da barra de defesa
	li $s3, 7
	lopesq:
	lw $s2, ($s0)
	sw $s2, ($s1)
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s3, $s3, -1
	bnez $s3, lopesq
	nop
	move $s0, $s4
	sw $zero, ($t9)
	kp:jr $ra
	nop

movedireita:
	move $s1, $s0
	addi $s1, $s1, 20
	beq $s1, 268516856, lf	#caso chegue no limite da tela nao move mais
	nop
	li $s3, 7
	lopdir:
	lw $s2, ($s1)
	move $s5, $s1
	addi $s5, $s5, 4
	sw $s2, ($s5)
	addi $s3, $s3, -1
	addi $s1, $s1, -4
	bnez $s3, lopdir
	nop
	addi $s0, $s0, 4
	sw $zero, ($t9)
	lf:jr $ra
	nop
	
	
derrota:
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, der
	syscall
	la $a0, jdnv
	syscall
	li $v0, 5
	syscall
	beq $v0, 1, main
	nop
	li $v0, 10
	syscall
vitoria:
	li $v0, 4
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, enter
	syscall
	la $a0, vit
	syscall
	la $a0, jdnv
	syscall
	li $v0, 5
	syscall
	beq $v0, 1, main
	nop
	li $v0, 10
	syscall
	
	
	
