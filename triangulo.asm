;Programa 2:   Programa que verifica a condicao de existencia do triangulo
;                         e o classifica quanto aos lados. 

.MODEL SMALL
.DATA

  ;Cria strings com mensagens   
  StrMsg1 db "Digite o tamanho do primeiro lado: ",'$' 
  StrMsg2 db 13,10,"Digite o tamanho do segundo lado: ",'$'
  StrMsg3 db 13,10,"Digite o tamanho do terceiro lado: ",'$'
  
  ;Cria strings com os possiveis resultados
  StrNao db 13,10,"Os lados n",00C6H,"o formam um tri",0083H,"ngulo.",'$'
  StrEqu db 13,10,"Os lados formam um tri",0083H,"ngulo equil",00A0H,"tero.",'$'
  StrIso db 13,10,"Os lados formam um tri",0083H,"ngulo is",00A2H,"sceles.",'$'
  StrEsc db 13,10,"Os lados formam um tri",0083H,"ngulo escaleno.",'$'
  
  ;Cria array com as mensagens iniciais
  MsgInicial dw StrMsg1,StrMsg2,StrMsg3
  
  ;Cria array com os resultados
  Tipo dw StrNao,StrEqu,StrIso,StrEsc
  
  ;Cria um array de 3 bytes para guardar os lados
  Triangulo dw 3 DUP(0)
   
.CODE
.STARTUP

  ;Coloca em DS o segmento que guarda MsgInicial
  MOV AX,SEG MsgInicial
  MOV DS, AX
  
  ;Inicializa contadores  
  MOV CX,3             ;CX decresce de 1 em 1 a cada execucao de RECEBER_DADOS 
  MOV BX,0             ;BX crescente de 2 em 2 a cada execucao de RECEBER_DADOS  
 
    
  RECEBER_LADOS: ;pelo teclado
  
    ;Imprimi mensagem de solicitacao
    MOV DX,MsgInicial[BX]
    MOV AH,09H 
    INT 21H
    
    ;Recebe o primeiro digito
    MOV AH,01H
    INT 21H
    SUB AL,30H         ;Obtem o valor correspondente em hexadecimal
    SHL AL,1           
    MOV DH,AL
    
    ;Recebe o segundo digito
    MOV AH,01H
    INT 21H
    SUB AL,30H         ;Obte o valor correspondente em hexadecimal
    
    ;Obte o valor do lado digitado em hexadecimal
    ADD AL,DH
    
    ;Coloca o lado no array Triangulo
    MOV AH,0
    MOV Triangulo[BX],AX
    
    ADD BX,2           ;Incrementa BX
    LOOP RECEBER_LADOS 
     
            
            
  ;VERIFICAR:          Verifica se os lados formam um triangulo
  
    ;Copia os lados nos regitradores      
    MOV SI,0
    
    MOV AX,0
    MOV AX,Triangulo[SI]
    
    MOV BX,0
    MOV BX,Triangulo[SI+2]
    
    MOV CX,0
    MOV CX,Triangulo[SI+4]
     
     
    ;Compara a soma de dois lados com o outro lado 
    ADD BL,CL          ;BX = BX + CX 
     
    CMP BX,AX
    JLE NEGAR          ;Se AX >= BX, salta para NEGAR
                       ;Se nao, continua a verificacao
     
         
    ;Recupera o valor do lado que estava em BX        
    MOV BX,0
    MOV BX,Triangulo[SI+2]
    
    ;Compara a soma de dois lados com o outro lado
    ADD AL,CL          ;AX = AX + CX
    
    CMP AX,BX  
    JLE NEGAR          ;Se BX >= AX, salta para NEGAR
                       ;Se nao, continua a verificacao
      
         
    ;Recupera o valor do lado que estava em AX        
    MOV AX,0
    MOV AX,Triangulo[SI]
    
    ;Compara a soma de dois lados com o outro lado
    ADD AL,BL          ;AX = AX + BX
    
    CMP AX,CX  
    JG IDENTIFICAR_TIPO;Se CX < AX, salta pra IDENTIFICAR_TIPO 
                       ;Se nao, continua (para NEGAR)
            
            
    
  NEGAR:               ;Imprime a mensagem informando que os lados nao formam triangulo
    MOV DX,0
    MOV SI,DX
    MOV DX,Tipo[SI]
    MOV AH,09H
    INT 21H
    JMP ENCERRAR_PROGRAMA
          
          
    
  IDENTIFICAR_TIPO:    ;Label para identificar qual o tipo de triangulo
    
    ;Recupera o valor do lado que estava em AX
    MOV AX,0
    MOV AX,Triangulo[SI]
    
    CMP AX,BX          ;Verifica se dois lados sao iguais
    JNE ISO_ESC        ;Se nao sao iguais, pula para ISO_ESC
    CMP AX,CX          ;Se sao iguais, verifica se o outro lado e igual
    JNE ISOSCELES      ;Se um lado e diferente, pula para ISOCELES
    JE EQUILATERO      ;Se todos os lado sao iguais, pula para EQUILATERO
    
    ISO_ESC:
      CMP BX,CX        ;Continua a verificar se tem pelo menos 2 lados iguais
      JE ISOSCELES      ;Se sao iguais, pula para ISOCELES
      CMP CX,AX        ;Se nao, continua a verificar se tem pelo menos 2 lados iguais
      JE ISOSCELES      ;Se sao iguais, pula para ISOCELES
                       ;Se todos os lado sao diferentes, segue (para ESCALENO)
          
          
      
 ;ESCALENO:            Imprime a mensagem informando que o triangulo e escaleno
    MOV DX,6
    MOV SI,DX
    MOV DX,Tipo[SI]
    MOV AH,09H
    INT 21H
    JMP ENCERRAR_PROGRAMA
        
        
    
  EQUILATERO:          ;Imprime a mensagem informando que o triangulo e equilatero
    MOV DX,2
    MOV SI,DX
    MOV DX,Tipo[SI]
    MOV AH,09H
    INT 21H
    JMP ENCERRAR_PROGRAMA
    
    
  ISOSCELES:            ;Imprime a mensagem informando que o triangulo e isosceles
    MOV DX,4
    MOV SI,DX
    MOV DX,Tipo[SI]
    MOV AH,09H
    INT 21H
    
    
  ENCERRAR_PROGRAMA:
  MOV AH,4CH 
  INT 21H    