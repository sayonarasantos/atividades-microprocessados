; Questao 9: jogo de adivinhacao 

.MODEL SMALL
.DATA
    
  ;Cria strings com a mensagem inicial e com os resultados
    STR1 DB "Tente adivinha o n",00A3H,"mero secreto!",13,10,'$'
    STR2 DB 13,10,"Quente...",13,10,'$'
    STR3 DB 13,10,"Frio...",13,10,'$'
    STR4 DB 13,10,"Acertou!!!",13,10,'$'
    
  ;Define NUM com o valor 8 (valor a ser adivinhado)
    NUM EQU '8'             

.CODE
  
  ;Atualiza o DS com o segmento que guarda as strings.
    MOV AX,@DATA
    MOV DS,AX
  
  ;Imprime mensagem inicial.
    MOV DX,OFFSET STR1
    MOV AH,09H
    INT 21H


  RECEBER_DADO:
    MOV AH,01H
    INT 21H

  ;Verifica se o dado e o numero correto
    SUB AL,NUM
    
    CMP AL,0
    JE ACERTOU
    
    CMP AL,1
    JE QUENTE 
    
    CMP AL,-1
    JE QUENTE
    
    
  ;FRIO:                 ;Bloco para imprimir "Frio.." caso a diferenca entre o numero digitado
    MOV DX,OFFSET STR3   ;e numero a ser adivinhado seja maior ou igual a 2
    MOV AH,09H
    INT 21H
    JMP RECEBER_DADO
         

  QUENTE:                ;Bloco para imprimir "Quente.." caso a diferenca entre o numero digitado
    MOV DX,OFFSET STR2   ;e numero a ser adivinhado seja 1
    MOV AH,09H
    INT 21H
    JMP RECEBER_DADO        


  ACERTOU:               ;Bloco para imprimir "Acertou!!!" caso a diferenca entre o numero digitado
    MOV DX,OFFSET STR4   ;e numero a ser adivinhado seja 0
    MOV AH,09H
    INT 21H


  ;Encerra programa    
    MOV AH,4CH
    INT 21H

END
   
   
