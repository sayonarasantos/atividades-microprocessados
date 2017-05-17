;Pratica:           Programa que imprime o dia da semana correspondente ao valor digitado

.MODEL SMALL
.STACK 100H

.DATA
    ;Cria strings com os dias da semana
    StrDom db "Domingo",'$' 
    StrSeg db "Segunda",'$'
    StrTer db "Terca",'$'
    StrQua db "Quarta",'$'
    StrQui db "Quinta",'$'
    StrSex db "Sexta",'$'
    StrSab db "Sabado",'$'
    ;Inicia um array com os dias das semanas
    Semana dw StrDom,StrSeg,StrTer,StrQua,StrQui,StrSex,
    
.CODE
    ;Coloca em DS o segmento que guarda Semana
    MOV AX, SEG Semana
    MOV DS,AX
    ;Recebe um valor do teclado.
    MOV AH,01H
    INT 21H   
    
    MOV AH,0 ;Zera AH.
    
    
    MOV AL,30h ;Converte o valor recebido do teclado para um numero (tabela ASCII).
    MOV DI,AX  ;Copia o valor de ax para o indice
    
    SHL DI,1 ;Multiplica o indice por 2.
    MOV DX,Semana[DI] ;Acessa o elemento di no segmento do array
    ;Imprimi o elemento indicado no array
    MOV AH,09H 
    INT 21H