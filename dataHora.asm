;Programa 1:           Programa que imprime a data e a hora.

.MODEL SMALL
.STACK 100H
.DATA

  ;Cria strings com os dias da semana
  StrDom db ", Domingo, ",'$' 
  StrSeg db ", Segunda-feira, ",'$'
  StrTer db ", Ter",0087H,"a-feira, ",'$'
  StrQua db ", Quarta-feira, ",'$'
  StrQui db ", Quinta-feira, ",'$'
  StrSex db ", Sexta-feira, ",'$'
  StrSab db ", S",00A0H,"bado, ",'$'
    
  ;Cria um array com os dias das semanas
  Semana dw StrDom,StrSeg,StrTer,StrQua,StrQui,StrSex,StrSab
    
.CODE
.STARTUP

  ;Coloca os dados na pilha.
  
    ;Chama a funcao GET TIME.
    MOV AH,2CH
    INT 21H
      ;Guada os minutos.
    MOV BL,CL        
    PUSH BX
      ;Guada a hora.
    MOV BX,0 
    MOV BL,CH        
    PUSH BX
    
    ;Chama a funcao GET DATE.
    MOV AH,2AH
    INT 21H
      ;Guarda o dia da semana.
    MOV BX,0 
    MOV BL,AL        
    PUSH BX       
      ;Guarda o ano.          
    PUSH CX 
      ;Guarda o mes.
    MOV BX,0
    MOV BL,DH        
    PUSH BX
      ;Guarda o dia.      
    MOV BX,0
    MOV BL,DL         
    PUSH BX
           
           
    
  ;Inicializa o contator para executar 6 vezes RETIRAR_DA_PILHA. 
    MOV CX,6 
    
                                           
  RETIRAR_DA_PILHA:
    
    MOV AX,0 
    POP AX
    
    ;Verifica se e o dia da semana
    CMP CX,3
    JE FORMATAR_DIA_DA_SEMANA    ;Se sim, pula para FORMATAR_DIA_DA_SEMANA.
                                 ;Se nao, o programa segue (para IMPRESSAO DE 2 DIGITOS).
                                 
    
  ;IMPRESSAO DE 2 DIGITOS:       Imprime o valor em decimal.
    
    ;Divide o valor por 0AH
    MOV DX,0
    MOV BX,0AH
    DIV BX
      
    ;Guarda o resto na pilha
    PUSH DX
      
    ;Verifica se e o ano.
    CMP CX,4
    JE FORMATAR_ANO              ;Se sim, pula para FORMATAR_ANO.
                                 ;Se nao, o programa segue (para IMPRIMR).
                                                
    
  IMPRIMIR:
  
    ;Imprime o primeiro digito.
    CALL IMPRIMIR_UM_DIGITO
    
    
    ;Imprime o segundo digito.
    MOV DX,0
    POP DX                       ;Retira o resto da pilha.
    MOV AL,DL
    
    CALL IMPRIMIR_UM_DIGITO
     
    
    ;Verifica se precisa imprimir outro caracter (/ ou :).
    CMP CX,5
    JGE IMPRIMIR_BARRA           ;Se o dado anterior e o dia ou o mes, pula para IMPRIMIR_BARRA. 
    CMP CX,2
    JE IMPRIMIR_PONTOS           ;Se o dado anterior e a hora, pula para IMPRIMIR_PONTOS.
        
        
    LOOP RETIRAR_DA_PILHA        ;Repete RETIRAR_DA_PILHA, se CX>0.
    
    
    
  ;ENCERRAR PROGRAMA
    MOV AH,4CH 
    INT 21H
       
    
      
  IMPRIMIR_UM_DIGITO:
    ADD AL,30H                   ;Converte o valor para decimal.
    MOV DL,AL                    
    ;Imprime.                    
    MOV AH,02H                   
    INT 21H
                         
    RET                          ;Retorna para onde o programa saiu.
      
      
    
  IMPRIMIR_BARRA:
    MOV DX,'/'                   
    ;Imprime.                   
    MOV AH,02H                   
    INT 21H
                          
    LOOP RETIRAR_DA_PILHA
      
      
    
  IMPRIMIR_PONTOS:
    MOV DX,':'                   ;Copia o valor para DL
    ;Imprime.
    MOV AH,02H                   
    INT 21H
                          
    LOOP RETIRAR_DA_PILHA
        
        
   
  FORMATAR_ANO:
    MOV DX,0
    DIV BX                       ;Divide o quociente da divisao anterior por 0AH
    MOV AX,0
    MOV AX,DX                    ;Copia o resto para AX
    
    JMP IMPRIMIR                 ;Pula para IMPRIMIR
    
    
  FORMATAR_DIA_DA_SEMANA:
    MOV AH,0                     
    MOV SI,AX
    ;Passa para DS o segmento que guarda Semana.
    MOV AX,SEG Semana
    MOV DS, AX
    ;Obtem do array o elemento correspondente ao dia da semana                       
    SHL SI,1                     
    MOV DX,Semana[SI]            
    ;Imprime
    MOV AH,09H 
    INT 21H
    
    LOOP RETIRAR_DA_PILHA