; Questao 8:
;   Recebe 6 algarismos,
;   imprime * para cada algarimo digitado ou
;   emite um "bell" caso seja digitado algo diferente de algarimos
;   e apresenta os 6 algarismos ao final da digitacao.

.MODEL SMALL
.DATA 

  ;Cria strings com as mensagens
    Str1 DB "Digite seis algarismos:",13,10,'$'
    Str2 DB 13,10,"Os algarismo digitados foram:",13,10,'$'
    
  ;Cria um array para guardar os algarismos
    Algarismos DB 6 DUP(0)
    
.CODE   
.STARTUP

  ;Atualiza o DS com o segmento que guarda as strings.
    MOV AX,@data
    MOV DS, AX 

  ;Imprime mensagem inicial.
    MOV DX,OFFSET Str1
    MOV AH,09H 
    INT 21H 
    
  ;Inicializa os contatores.
    MOV CX,6                ;CX: contador do laco para receber os algarismos.
    MOV BX,0                ;BX: contador que serve como indice do vetor de algarismos.
     
     
  RECEBER_DADO:             ;Bloco para receber os dado digitado um de cada vez
    MOV AH,08H              ;e decidir o que sera feito, dependendo do dado recebido.
    INT 21H                 
    CMP AL,30H              
    JB EMITIR_BELL          
    CMP AL,39H              
    JA EMITIR_BELL          
    
  ;Guarda o algarismo.
    MOV Algarismos[BX],AL
    INC BL
    
  ;Imprime asterisco.
    MOV DX,'*'                                      
    MOV AH,02H                   
    INT 21H
    LOOP RECEBER_DADO

  ;Inicializa os contatores.
    MOV CX,6                ;CX: contador do laco para imprime os algarismos.
    MOV BX,0                ;BX: contador que serve como indice do vetor de algarismos.
    
  ;Imprime mensagem final.
    MOV DX,OFFSET Str2
    MOV AH,09H 
    INT 21H   
          
          
  IMPRIMIR_ALGARISMOS:
  ;Imprime espaco
    MOV DL," "
    MOV AH,02H                   
    INT 21H
        
  ;Imprime algarismo
    MOV DL,Algarismos[BX]
    MOV AH,02H                   
    INT 21H
    INC BL
    LOOP IMPRIMIR_ALGARISMOS
    
  ;Encerra programa
    MOV AH,4CH 
    INT 21H  
    
    
  EMITIR_BELL:              ;Bloco para emitir um "bell"
    MOV DL,07H              ;se o dado digitado nao for um algarismo.
    MOV AH,02H                  
    INT 21H                 
    INC CX                  
    LOOP RECEBER_DADO       
    
    
END 