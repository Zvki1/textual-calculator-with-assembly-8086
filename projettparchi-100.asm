; multi-segment executable file template.

data segment
   info db 0Dh,0Ah,0Dh,0Ah,"PROJET:             CALCULATRICE TEXTUELLE    ",0Dh,0Ah
        db 0Dh,0Ah,0Dh,0Ah, "Developpee par : REGUIEG ZAKARIA ",0Dh,0Ah
        db 0Dh,0Ah ,"          AMARI LAMIS  ",0Dh,0Ah
        db 0Dh,0Ah,0Dh,0Ah,"ACAD B 2022/2023",0Dh,0Ah,'$'
   opd1 db 0Dh,0Ah,0Dh,0Ah,"Entrer le premier operande $ "
   opt  db 0Dh,0Ah,0Dh,0Ah, "taper votre operation : 1:(+) 2:(-) 3:(x) 4:(/) $" ,0Dh,0Ah 
   opd2 db 0Dh,0Ah,0Dh,0Ah,"Entrer le deuxieme operande $" 
   erreuropt db 0Dh,0Ah,0Dh,0Ah, "operation incorrect $"
   merci db 0Dh,0Ah,0Dh,0Ah, "merci pour votre utilisation $" 
   plus db  " + $"  
   egale db " = $"      
   produit db " * $"
   soustraction db  " - $" 
   division db " / $" 
   
   saut db  0Dh,0Ah,0Dh,0Ah," $"  
  ;; menu db
  ;;declaration des tableaux 
    Bstring DB 16 DUP (0)
    Dstring DB 5 DUP  (0)
    Hstring DB 4 DUP (0)

    msg db 0dh,0ah,0dh,0ah,"l'affichage :",10,'$'
    base db 0Dh,0Ah,0Dh,0Ah, "entrez la base : 1-binaire 2-hexadecimal 3-decimal $" 
    erreur db 0Dh,0Ah,0Dh,0Ah, "base incorrect $" 
    quitter db 0DH,0AH,0DH,0Ah,"voulez-vous quitter? (y:yes/n:no) $"
    ;;declaration de la base
    bs db '?'
    ;declaration de l'operation
    opr db '?'
     ;declaration des operands
     num1 dw ?
     num2 dw ?
     result dw ?








ends
stack segment
    dw   128  dup(0)
ends
code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax                             

recalcul:              
                 
;affichage de l'entete 
    mov dx,offset info 
    mov ah ,09h 
    int 21h 
;la saisie de la base
    mov dx,offset base
    mov ah ,09h 
    int 21h 
    mov ah,01h
    int 21h 
    mov bs , AL
    cmp AL,'1'
    JE Binaire
    cmp AL,'2'
    JE hexadecimal
    cmp AL,'3'
    JE decimal
    jmp baseinc ;base incorrecte
    
BINAIRE:    
   ;lecture du premier operande         
   mov dx,offset opd1 
   mov ah ,09h 
   int 21h   
   call lirebinaire
   ;convert du premier operande 
   push num1 
   call StringToBinary
   pop num1
   ;;saut de ligne;;
   mov dx,offset saut 
   mov ah ,09h 
   int 21h  
   ;affichage
   mov ax,num1
   call  printbinary
   
    
   ;lecture du deuxieme operande 
   mov dx,offset opd2 
   mov ah ,09h 
   int 21h   
   call lirebinaire
   ;convert le deuxieme operande a un nembre
   push num2
   call StringToBinary 
   pop num2
   ;;saut de ligne;;
    mov dx,offset saut 
    mov ah ,09h 
    int 21h  
   ;affichage
    mov ax,num2
    call  PrintBinary 
  
   
   ;lecture de l'operation
    mov dx,offset opt 
    mov ah ,09h 
    int 21h
    ;lecture d'un caractere par le clavier 
    mov ah,01h
    int 21h
    cmp AL,'+'
    JE additionb 
    cmp AL,'-'
    JE soustractionb
    cmp AL,'*'     
    JE MULTIPLICATIONb
    cmp AL,'/'
    JE divisionb
    jmp errop ;operation n'existe pas
    
  additionb:
     mov ax, num1
     add ax, num2
     mov result, ax   
     mov dx,offset saut  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h 
     ;AFFICHAGE DU PREMIER OP
      mov ax,num1
      call  Printbinary    
      ;AFFICHAGE DE PLUS 
      mov dx,offset plus  
      mov ah ,09h 
      int 21h  
              
      ;AFFICHAGE DU deuxieme OP
      mov ax,num2
      call  Printbinary         
     
      ;AFFICHAGE DE egale 
      mov dx,offset egale  
      mov ah ,09h 
      int 21h  
     
     ;AFFICHAGE DE RESULTAT 
     
      mov ax,result
      call  Printbinary
                     
      jmp finop
     
  soustractionb:
     mov ax, num1
     sub ax, num2 
     mov result,ax 
     mov dx,offset saut  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h 
     ;AFFICHAGE DU PREMIER OP
     mov ax,num1
     call  Printbinary   
     ;AFFICHAGE DE sub 
     mov dx,offset soustraction  
     mov ah ,09h 
     int 21h  
              
      ;AFFICHAGE DU deuxieme OP
     mov ax,num2
     call  Printbinary        
     
      ;AFFICHAGE DE egale 
     mov dx,offset egale  
     mov ah ,09h 
     int 21h  
     
     ;AFFICHAGE DE RESULTAT 
       
     mov ax,result
      call  Printbinary 
      
      jmp finop
   
  multiplicationb:
    mov ax, num1
    mul num2 
    mov result,ax
    
     mov dx,offset saut  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h 
     ;AFFICHAGE DU PREMIER OP
     mov ax,num1
     call  Printbinary 
      ;AFFICHAGE DE produit 
     mov dx,offset produit  
     mov ah ,09h 
     int 21h  
              
      ;AFFICHAGE DU deuxieme OP
     mov ax,num2
     call  Printbinary         
     
      ;AFFICHAGE DE egale 
     mov dx,offset egale  
     mov ah ,09h 
     int 21h  
     
     ;AFFICHAGE DE RESULTAT 
       
     mov ax,result
     call  Printbinary    
     jmp finop
   
  divisionb:
     mov dx, 0
     mov ax, num1
     div num2  ; ax = (dx ax) / num2.
     mov result,ax 
 
  ;AFFICHAGE DU RESULTAT EN BINAIRE      
     mov dx,offset saut  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h 
     ;AFFICHAGE DU PREMIER OP
     mov ax,num1
     call  Printbinary   
     ;AFFICHAGE DE div 
     mov dx,offset division  
     mov ah ,09h 
     int 21h  
              
     ;AFFICHAGE DU deuxieme OP
     mov ax,num2
     call  Printbinary         
     
      ;AFFICHAGE DE egale 
     mov dx,offset egale  
     mov ah ,09h 
     int 21h  
     
     ;AFFICHAGE DE RESULTAT 
       
     mov ax,result
     call  Printbinary
        
     jmp finop
   
DECIMAL:
  ;lecture du premier operande
   mov dx,offset opd1 
   mov ah ,09h 
   int 21h   
   call lireDecimal
   ;convert le premier operande string to decimal 
   push num1
   call StringToDecimal
   pop num1
   ;lecture du deuxieme operande
   mov dx,offset opd2 
   mov ah ,09h 
   int 21h   
   call lireDecimal 
   ;convert le deuxieme operande
   push num2
   call StringToDecimal
   pop num2
   ;lecture de l'operation
    mov dx,offset opt 
    mov ah ,09h 
    int 21h  
    
    mov ah,01h
    int 21h
    cmp AL,'+'
    JE additiond 
    cmp AL,'-'
    JE soustractiond 
    
    cmp AL,'*'     
    JE MULTIPLICATIONd
    cmp AL,'/'
    JE divisiond 
    jmp errop 
     ;ADDITION DECIMAL
  additiond:
     call sauter
     push num1
     call outputdecimal
     add sp,2
     mov dx, offset plus
     mov ah,09h
     int 21h
     push num2
     call outputdecimal
     add sp,2
     call egaleproc
     mov ax,num1
     add ax, num2   
     mov result, ax 
     push result
     call outputdecimal
     add sp,2
      
     jmp finop
     
    ;SOUSTRACTION DECIMAL
  soustractiond:
     call sauter
     push num1
     call outputdecimal
     add sp,2
     mov dx, offset soustraction
     mov ah,09h
     int 21h
     push num2
     call outputdecimal
     add sp,2
     call egaleproc
     mov ax, num1
     sub ax, num2 
     mov result,ax 
     push result
     call outputdecimal
     add sp,2 
     
    jmp finop 
     
    
   
   ;MULTIPLICATION DECIMAL
  multiplicationd:
    call sauter
     push num1
     call outputdecimal
     add sp,2
     mov dx, offset produit
     mov ah,09h
     int 21h
     push num2
     call outputdecimal
     add sp,2
     call egaleproc
     mov ax, num1
     mul num2 
     mov result,ax 
     push result
     call outputdecimal
     add sp,2
     
     jmp finop
    
    ;DIVISION DECIMAL
    divisiond:
     call sauter
     push num1
     call outputdecimal
     add sp,2
     mov dx, offset division
     mov ah,09h
     int 21h
     push num2
     call outputdecimal
     add sp,2
     call egaleproc
    
    
     mov dx, 0
     mov ax, num1
     div num2  ; ax = (dx ax) / num2.
     mov result,ax
     push result
     call outputdecimal
     add sp,2     
    
     jmp finop
     
     
HEXADECIMAL:
 ;lecture du premier operande
   mov dx,offset opd1 
   mov ah ,09h 
   int 21h   
   call lireHexa
 ;convert le premier operande String to hexa
   push num1
   call StringToHexa
   pop num1    
   mov ax, num1
   call sauter ; SAUT DE LIGNE
   call AffHexa ;l'affichage de num1
    
  ;lecture du deuxieme operande
   mov dx,offset opd2 
   mov ah ,09h 
   int 21h  
   call lireHexa 
  ;convert le deuxieme operande string to hexa
   push num2
   call StringToHexa
   pop num2
   mov ax, num2
   call sauter ; SAUT DE LIGNE
   call AffHexa  ;l'affichage de num2 
  
  ;lecture de l'operation
    mov dx,offset opt 
    mov ah ,09h 
    int 21h
   
    mov ah,01h
    int 21h
    cmp AL,'+'
    JE additionH 
    cmp AL,'-'
    JE soustractionH
    cmp AL,'*'     
    JE MULTIPLICATIONH
    cmp AL,'/'
    JE divisionH
    jmp errop 
    
    ;ADDITION HEXA
  additionH:
     mov ax, num1
     call sauter ; SAUT DE LIGNE
     call AffHexa  ;affichage de num1
     call additionproc ;affichage de caractere (+)
     mov ax,num2      
     call AffHexa ;affichage de num2
     add ax, num1 ;ax=num2+num1
     call egaleproc;affichage de (=)
     call AffHexa
     ;mov result, ax
     
    jmp finop                
         ;SOUSTRACTION HEXA;
  soustractionH:
     mov ax, num1
     call sauter
     call AffHexa ;AFFICHAGE DU PREMIER OPERAND
     mov dx,offset soustraction ;AFFICHAGE DU CARACTERE -
     mov ah ,09h
     int 21h
     mov ax,num2
     call affhexa    ;AFFICHAGE DU DEUXIEME OPERAND
     call egaleproc  ;AFFICHAGE DU =
     mov ax,num1
     sub ax, num2 
     mov result,ax   ;AFFICHAGE DU RESULTAT
     call AffHexa ;affichage du resultant
   
   jmp finop  
       ;MULTIPLICATION EN HEXA;
  multiplicationH:
    mov ax, num1 
    call sauter            ;saut de ligne
    call affhexa ;aff num 1
    mov dx,offset produit
    mov ah,09h
    int 21h
    mov ax,num2
    call affhexa         ;aff du num2
    call egaleproc          ;LE MEME PROCESS DES AUTRES OPERATION
    mov ax,num1
    mul num2      
    mov result,ax
    call affhexa  ;affichage du resultant
    jmp finop 
  divisionH:
     mov ax, num1
     call sauter
     call affhexa
     mov dx, offset division
     mov ah,09h
     int 21h
     mov ax,num2
     call affhexa
     call egaleproc
     mov dx, 0 
     mov ax, num1
     div num2  ; ax = (dx ax) / num2.     
     call affhexa
     mov result,ax
   
   
   
   
  
   
  errop:
   mov dx,offset erreuropt
   mov ah ,09h 
   int 21h
   jmp finop
   
 baseinc: 
    mov dx,offset erreur 
    mov ah ,09h 
    int 21h 
 
 finop:
   call sauter 
   mov dx,offset quitter 
   mov ah ,09h
   int 21h
   
   mov ah,01h
   int 21h 
   cmp AL,'y'
   JE quit
   cmp AL,'n'
   JE recalcul


quit:
  mov dx,offset merci 
  mov ah ,09h
  int 21h
  
mov ah ,4ch
int 21h 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;les procedure 
  ;Fonction pour lire un nombre de base(2) et stocke dans Bstring
LirebINAIRE PROC 
  PUSH AX 
   push SI
   push cx
   push bp
   mov bp,sp
   mov si,00h 
   mov cx,16
   remplissage: 
   cmp SI,CX
   JGE fin
    mov ah,01h
    int 21h
    mov Bstring[si],AL
    inc si  
    cmp AL,'0'
    JE remplissage
    cmp AL,'1'
    JE remplissage
    cmp AL,0DH ;;enter key
    JE fin ;fin de remplissage
    dec si ;decrementation pour ecraser le chiffre different de 0 ou 1
    jmp remplissage 
    fin:
   pop bp 
   pop cx 
   pop si
   pop ax 
   ret
  Lirebinaire endp
;;;;;;;;;;;;;;; 
  ;la fonction qui lit un nombre decimal dans Dstring
  LireDecimal PROC 
  PUSH AX 
   push SI
   push cx
   mov si,00h 
   mov cx,5
   remplissageD: 
   cmp SI,CX
   JGE finD 
    mov ah,01h
    int 21h
    mov Dstring[si],AL
    inc si  
    cmp AL,'0';verification si le chiffre de 0 a 9
    JL veri
    cmp AL,'9'
    JG veri
    jmp remplissageD  
  veri: 
    cmp AL,0DH ;;enter key
    JE finD 
    dec si ;le chiffre lu n'appartient pas de 0 a 9 donc il va etre ecraser
    jmp remplissageD 
    finD: 
   pop cx 
   pop si
   pop ax 
   ret
  LireDecimal endp 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;fonction qui lit un nombre hexa dans Hstring
  LireHexa PROC 
  PUSH AX 
   push SI
   push cx
   mov si,00h 
   mov cx,4
   remplissageH: 
   cmp SI,CX
   JGE finH 
   mov ah,01h
   int 21h
   mov Hstring[si],AL
   inc si  
   cmp AL,'0'
   JGE ver
   jmp verih
  ver: cmp AL,'9'
      JLE  remplissageh 
   
  ver1 : cmp AL,'@'
         JG ver2 
         jmp verih
        ver2: cmp AL,'G'
         JL  remplissageh 
         
   veriH: cmp AL,0DH ;;enter key
         JE finH 
         dec si
         jmp remplissageH 
    finH: 
   pop cx 
   pop si
   pop ax 
   ret
  LireHexa endp 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Fonction qui fait la conversion de string a un nombre
   ;Convvert string to binary 
 StringToBinary Proc
    push ax
    push bx
    push cx 
    push si
    push bp
    mov bp,sp
    mov ax,0000H
    mov cx,16
    mov si,0
    mov bx,offset Bstring
     BOUCLESTR:
     cmp si,cx
     jG finstr
     cmp [bx+si],'1'
     Je tap1
     cmp [bx+si],'0'
     jE tap0 
     jmp finstr
     tap0:
     shl ax,1 ;decalage a gauche pour avoir le 0 lu de bstring
     inc si
     jmp bouclestr
     tap1:
     SHL AX,1 ;decalage a gauche avec une position 
     ADD AX,1 ;ajouter le 1 lu d'apres la chaine
     inc si 
     jmp bouclestr
   
     finstr:
    mov [bp+12] ,ax 
    pop bp
    pop si
    pop cx
    pop bx
    pop ax
    ret
 StringToBinary ENDP  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;convert string to decimal
  StringToDecimal Proc
    push ax
    push bx
    push cx
    push dx 
    push si
    push bp
    mov bp,sp
    mov Ax,0000H
    mov bx,offset Dstring
    mov cx,5
    mov si,0
    
     BOUCLESTRD:
    cmp [bx+si],0DH
    jE sort
    mov dl,10          ;  AX = AX*10
    mul dl ;ax=al*dl                   
    add aL,[bx+si]    ; AX = AX+[BX+SI]-30h
    sub ax,30h ;pour avoir le chiffre exacte^pas son code ascii
    inc si
    loop bouclestrd
    
    
    sort:
    mov [bp+14] ,ax  
    pop bp
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
 StringToDecimal ENDP  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 ;convert string to hexa
StringToHexa Proc
    push ax
    push bx
    push cx
    push dx 
    push si
    push bp
    mov bp,sp
    mov ax,0000H
    mov cx,4
    mov si,0
    mov bx,offset Hstring
     BOUCLESTRH:
     
    cmp [bx+si],0DH
    jE sorth
     shl ax,4 ; decalage a gauche avec 4 positions
    ;add al,[bx+si]
    cmp [bx+si],'A';si c'est une lettre de A a Z
    
    JL  zeroaneuf
    MOV DL,[bx+si]
    sub dl,55  
    add al,dl
    ;sub ax,31h
    jmp inch
    zeroaneuf: ; si c'est un chiffre de 0 a 9
    add al,[bx+si]
    sub ax,30h
    inch:
    inc si
    loop bouclestrh
   
     sorth:
    mov [bp+14] ,ax 
    pop bp
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
 StringToHexa ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;fonction de saut ligne
 sauter Proc
       push dx
       push ax       
     
     mov dx,offset saut  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h   
     
       pop  ax
       pop  dx
       
     ret
     sauter ENDP  
   ;;fonction qui affiche (+)
 additionproc Proc
       push dx
       push ax       
     
       mov dx,offset plus  ;  
       mov ah ,09h 
       int 21h   
     
       pop  ax
       pop  dx
       
     ret
additionproc ENDP
  ;;fonction qui affiche(=)
egaleproc Proc
       push dx
       push ax       
     
     mov dx,offset egale  ;SAUT DE LIGNE  
     mov ah ,09h 
     int 21h   
     
       pop  ax
       pop  dx
       
     ret
egaleproc ENDP  

   ;; fonction qui affiche en  binaire 
PrintBinary PROC 
    
    push bx
    
    
    mov bx,ax  ;ax=la valeur a afficher
    mov cx,16                          ;nb iteration
    
    print:
    mov ah,02h ; option  aff d'un caractere
    mov dl,'0'            ;le caractere a afficher
    test bx, 1000000000000000b         ;test si le bit du poids fort = 1
    jz zero   ;sinon jmp to zero
    mov dl,'1' ;    charger le 1 pour lafficher
    
    zero:
    int 21h
    shl bx,1  ;rotation pour la gauche
    loop print
    
    pop bx
    
    ret 
    
    PrintBinary ENDP   
;; fonction affichage en decimal
outputdecimal Proc
    push ax
    push bx
    push cx 
    push si
    push dx
    push bp
      ;mov dx,offset saut  ;SAUT DE LIGNE  
    ; mov ah ,09h 
     ;int 21h 
     ;AFFICHAGE DU PREMIER OPERAND
      mov bp,sp
      mov ax,[bp+14]
        mov bx,10
        mov cx,0
        
    empiler:
    
        mov dx,0
        div bx    ;ax/bx quotient=dx 
        add dx,48  ;convertion vers ascii
        push dx    ;empilement du caractere 
        inc cx     ; incrementation du cx ou cx =le nombre de'empilement a la fin
        cmp ax,0   ; division successif jusqua ax =0
        jne empiler
        
    depiler:
    
        mov ah,02h  ;option d'affichage dun caractere
        pop dx      ;depilement du caractere a afficher
        int 21h
        loop depiler    ;on boucle le depilement des caracteres ou cx=le nombre des caracteres empiler

    pop bp
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    ret
 outputdecimal ENDP
 ;;; fonction affichage en hexa
 AffHexa proc 
    push ax ;SAUVEGARDE DU CONTENU DU REGISTRE AX
    
   MOV bx, 10h  ;INITIALISER LE DIVISEUR BX A 10h (16)
   MOV cx, 00h  ;INITIALISATION DU CX A ZERO
emp:
   mov dx, 00h ;INITIALISER DX LE RESTE DE LA DIVISION A ZERO 
   div bx  ;ax/bx   dx==le reste de la division , ax==le quotient 
   cmp dx, 09h  ;COMPARAISON DU RESULTAT A 09h
   jg hex     ;SI SUPERIEUR IL VA SAUTER VERS L'ETIQUETE HEXA POUR TESTER SU LA LETTRE 
   add dx,30h  ;CONVERSION VERS LE ASCII
   push dx     ;EMPILER LE CARACTERE CORRESPENDANT AU QUOTIENT A LA PILE 
   jmp i    ;SAUT IMMEDIAT VERS L'ETIQUETE i   
   
hex: ; VEUT DIRE QUE LE QUOTIENT EST > 09h ALORS ON VERIFIE DX PARAPORT AU LETTRE DE L'HEXA A--F
   cmp dx,0ah
   je a
   cmp dx,0bh
   je b
   cmp dx,0ch
   je c
   cmp dx,0dh
   je d
   cmp dx,0eh
   je e
   cmp dx,0fh
   je f 
   jmp i
a:
   mov dx,41h
   push dx
   jmp i
b:
   mov dx,42h
   push dx
  jmp i
c:
  mov dx,43h
  push dx
  jmp i
d: 
  mov dx, 44h 
  push dx   
  jmp i
e: 
  mov dx, 45h 
  push dx 
  jmp i
f: 
  mov dx, 46h 
  push dx
  jmp i 

i:   ;utilisation de i parceque c'est un bout de code qui se re[ete apres tous empilement de caractere 
  inc cx   ;INCREMENTATION DU CX A CAUSE DE L'EMPILEMENT D'UN CARACTERE 
  cmp ax,00h   ;VERIFICATION SI LE NOMBRE EST EGAL A ZERO VEUT DIRE QUE TOUS LES CHIFRES SONT EMPILER 
  jne emp  ;SINON (AX != 0) ,SAUT VERS L'ETIQUETE EMP (EMPILER A NOUVEAU)
dep: ;ETIQUETE DE DIPILEMENT APRES QUE TOUS LES CARACTERES CORESPENDANT  CHIFRES DU NOMBRE HEXA SONT EMPILER D
  mov ah,02h
  pop dx ;DEPILEMENT DU DERNIER CARACTERE DANS LA PILE EXMP NUM1=123 ALORS DEPILEMENT DU NOMBRE '1'
  int 21h ;AFFICHAGE DU CARACTERE VIA L'INT 21H
  loop dep ;BOUCLER VERS L'ETIQUETE DEP JUSQUAU CX=0 (LES NOMBRES SONT TOUS DEPILER )
  pop ax ;AX REPREND SA VALEUR INITIALE AVANT LE CALL DE CETTE PROC
  ret  ;RETOUR VERS LE PROGRAMME PRINCIPAL
AffHexa endp
 ;*********************************FIN
 ends