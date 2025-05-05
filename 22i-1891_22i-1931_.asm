
;UMER IMRAN 22I-1891
;SULEMAN    22I-1931
;DS-C
;COAL PROJECT  -  DUCK SHOOT GAME
;============================================



ConvertDecimal MACRO  decimal, printableDecimal
	mov al,decimal
	xor ah, ah 
	mov cl, 10 
	div cl 
	add ax, 3030h
	mov printableDecimal,ax
	
ENDM ConvertDecimal  
Print MACRO row, column, color 
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, row
   mov Dl, column
   INT 10h 
   mov Ah, 09
   mov Al, ' '
   mov Bl, color
   mov Cx, 1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM Print     

PrintShooter MACRO column
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, 24
   mov Dl, column
   INT 10h 
   mov Ah, 09
   mov Al, 127  ;Arrow shape
   mov Bl, 02h
   mov Cx, 1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintShooter    

PrintShot MACRO row, column
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, row
   mov Dl, column
   INT 10h 
   mov Ah, 09
   mov Al, 254
   mov Bl, 0Ch
   mov Cx, 1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintShot  

PrintText Macro row , column , text
   push ax
   push bx
   push cx
   push dx   
   
   mov ah,2
   mov bh,0
   mov dl,column
   mov dh,row
   int 10h
   mov ah, 9
   mov dx, offset text
   int 21h
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintText

Delete Macro row, column
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, row
   mov Dl, column
   int 10h 
   mov Ah, 09
   mov Al, ' '
   mov Bl, 0h
   mov Cx, 1h
   int 10h 
ENDM Delete

Delay  Macro Seconds, MilliSeconds
    push ax
    push bx
    push cx
    push dx 
    push ds

    mov cx, Seconds		;Cx,Dx : number of microseconds to wait
    mov dx, MilliSeconds
    mov ah, 86h
    int 15h
	
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
ENDM Delay 



ClearScreen MACRO
        
    mov ax, 0600h  ;al=0 => Clear
    mov bh, 07     ;bh=07 => Normal Attributes              
    mov cx, 0      ;From (cl=column, ch=row)
    mov dl, 80     ;To dl=column
    mov dh, 25     ;To dh=row
    int 10h    
    
    ;Move cursor to the beginning of the screen 
    mov ax, 0
    mov ah, 2
    mov dx, 0
    int 10h   
    
ENDM ClearScreen
;//////////////////////////////////////////////////////////////////////////////////////






.MODEL SMALL
.STACK 64    
.DATA 
StartScreen			 db '              ====================================================',0ah,0dh
	db '             ||                                                  ||',0ah,0dh                                        
	db '             ||         >>  DUCK SHOOTING GAME  <<               ||',0ah,0dh
	db '             ||__________________________________________________||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh          
	db '             ||     Use left and right key to move gunshooter    ||',0ah,0dh
	db '             ||          and space button to shoot bullet        ||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||              You begin with 6 lifes              ||',0ah,0dh
	db '             ||  Score the highest you can score before you die  ||',0ah,0dh
	db '             ||        Scoring points increase your lifes        ||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||            Press Enter to start playing          ||',0ah,0dh 
	db '             ||            Press ESC to Exit                     ||',0ah,0dh
	db '              ====================================================',0ah,0dh

	db '$',0ah,0dh

GameoverScreen			 db '          __________________________________________________',0ah,0dh
	db '             ||                                                  ||',0ah,0dh                                        
	db '             ||               >> GAMEOVER <<                     ||',0ah,0dh
	db '             ||__________________________________________________||',0ah,0dh	
	db '$',0ah,0dh
DuckColLeft          db       ? 										 
DuckColRight         db       ? 
DuckColCenter	       db	?


DuckRow              db       15    
DuckColor            db      0d0h    


ShooterCol             db      40
   
ShotRow                db      ?
ShotCol                db      ?
ShotStatus             db      0    						;1 means there exist a displayed shot, 0 otherwise

lifes                  db      6
Misses                 db      0
Hits                   db      0							;Score
PlayerName	       db      15, ?,  15 dup('$')
AskPlayerName	       db      'Enter your name: ','$'
Disp_Hits	       db      'Score: ??','$'
Disp_lifes             db      'lifes: ?','$'
GameTitle	       db      ' >>  DUCK SHOOTING GAME  >> ','$'
FinalScoreString       db      'Your final score is: ??','$'
DuckDirection	       db      0						;0=Left, 1=Right
EasyMode	       db      'Easy Mode','$'
HardMode	       db      'Hard Mode','$'
ExtremeMode	       db      'Extreme Mode','$'
Instruction	       db      'Press ESC to exit - Space to fire - Right/Left arrows to move','$'
separate			db		'>>','$'











 s1 DB 0AH,0DH,0AH,0DH,' --------------------------------------$'
    MMM DB 0AH,0DH,'            >>> DUCK SHOOT <<<$'
    s2 DB 0AH,0DH,0AH,0DH,' --------------------------------------$'
    MMM5 DB 0AH,0DH,0AH,0DH,' PRESS ANY KEY AND ENTER FOR (MENU) :$'
    msg1 DB 0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH, ' UMER / SULEMAN $'
    MMM6 DB 0AH,0DH,'            >>> MENU <<<$'
    s3 DB 0AH,0DH,0AH,0DH,' --------------------------------------$'
    MMM8 DB 0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,' MODE 1 : ( 1 DUCK 3 ROUNDS )  $'
    s4 DB 0AH,0DH,0AH,0DH,' ----------------------------$'
    MMM9 DB 0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,0AH,0DH,' MODE 2 : ( MULTIPLE DUCKS )  $'
    s5 DB 0AH,0DH,0AH,0DH,' ----------------------------$'
    MMM10 DB 0AH,0DH,0AH,0DH,' CHOOSE MODE 1 OR 2 :   $'



newColorSkyBlue db 11    ; Sky blue color (palette index)
newColorbrown db 6      
newColorgreen db 10 

;//////////////////////////////////////////////////////////////////////////////////////

.CODE   
MAIN    PROC FAR  
    mov ax, @DATA
    mov ds, ax  
    


 MOV AX, 13H
    INT 10H

    ; Display the initial menu
    CALL game_name

    ; Call menu procedure after any key press and Enter
    CALL menu




 ClearScreen
call StartMenu
ClearScreen
call DrawInterface
call ResetDuck
PrintShooter 40
call UpdateStrings

MainLoop:
 cmp DuckDirection, 1
 jz moveDuckRight
 call DuckMoveLeft
 jmp AfterDuckMove

 moveDuckRight:
 call DuckMoveRight

 AfterDuckMove:
 cmp ShotStatus, 1
 jnz NoShotExist
 call CheckShotStatus      ;I'll see if the shotStatus alter to 0

 cmp ShotStatus, 1
 jnz NoShotExist
 call MoveShot
 PrintShooter ShooterCol      ;since the shot deletes the shooter at the beginning

 NoShotExist:       
 mov ah,1h
 int 16h                        ;ZF=1 when a key is pressed                        
 jz NokeyPress
 call KeyisPressed

 NokeyPress:
 call Difficulty

 EndOfMainLoop:
 jmp MainLoop
 hlt
MAIN        ENDP





;//////////////////////////////////////////////////////////////////////////////////////

game_name PROC
    MOV AH, 9
    LEA DX, s1
    INT 21H
    MOV AH, 9
    LEA DX, MMM
    INT 21H
    LEA DX, s2
    INT 21H
    LEA DX, MMM5
    INT 21H
    LEA DX, msg1
    INT 21H

    ; Display prompt to click any key
    MOV AH, 1
    INT 21H

    ; Wait for any key press

WAIT_FOR_KEY:
    MOV AH, 1
    INT 21H

    ; Check for Enter key press
    CMP AL, 0DH
    JNE WAIT_FOR_KEY

    ; Clear the screen before proceeding to the next page
    MOV AX, 13H
    INT 10H

    RET
game_name ENDP

menu PROC
    MOV AH, 9
    LEA DX, MMM6
    INT 21H
    MOV AH, 9
    LEA DX, s3
    INT 21H
    MOV AH, 9
    LEA DX, MMM8
    INT 21H
    MOV AH, 9
    LEA DX, s4
    INT 21H
    MOV AH, 9
    LEA DX, MMM9
    INT 21H
    MOV AH, 9
    LEA DX, s5
    INT 21H
    MOV AH, 9
    LEA DX, MMM10
    INT 21H

    ; Prompt for user input
    MOV AH, 1
    INT 21H
    ; AL will contain the ASCII value of the pressed key

    ; Check if the input is '1' or '2'
    CMP AL, '1'
    JE MODE_1
    CMP AL, '2'
    JE MODE_2

    MOV AX, 13H
    INT 10H

MODE_1:
    ; Call procedure for MODE 1
    CALL MODE_1_PROC
    RET

MODE_2:
    ; Call procedure for MODE 2
    CALL MODE_2_PROC
    RET

errorMsg DB 0AH, 0DH, 'Invalid input. Please enter 1 or 2.$'

menu ENDP





MODE_1_PROC PROC

   ; Set text mode
    mov ax, 0003h
    int 10h



;//////////////////////////////////////////////////////////////////////////////////////
UpdateStrings Proc  
	 push ax
	 
     ConvertDecimal Hits, ax
	 mov Disp_Hits[8], ah
	 mov FinalScoreString[22], ah
	 mov Disp_Hits[7], al
	 mov FinalScoreString[21], al
		
     mov ah,lifes
     add ah, 30h
   	 mov Disp_lifes[7], ah
	
	PrintText 1 , 56 , Disp_Hits
	PrintText 1 , 70 , Disp_lifes	

	pop ax
	ret             
UpdateStrings ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
DuckMoveLeft Proc   
    dec DuckColLeft
    Print   DuckRow ,DuckColLeft, DuckColor 
    Delete DuckRow, DuckColRight     
    dec DuckColRight  
    dec DuckColCenter
	
    cmp DuckColLeft ,0   
    Jnz endOfDuckMoveLeft 
    call DeleteDuck
    call ResetDuck
    endOfDuckMoveLeft: ret              
DuckMoveLeft ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
DuckMoveRight Proc   
    inc DuckColRight
    Print   DuckRow ,DuckColRight, DuckColor 
    Delete DuckRow, DuckColLeft     
    inc DuckColleft 
    inc DuckColCenter
	
    cmp DuckColRight ,80   
    Jnz endOfDuckMoveRight 
    call DeleteDuck
    call ResetDuck
    endOfDuckMoveRight: ret              
DuckMoveRight ENDP 


;//////////////////////////////////////////////////////////////////////////////////////
KeyisPressed  Proc 
    mov ah,0
    int 16h

    cmp ah,4bh                            ;Move Shooter Left if left button is pressed
    jnz NotLeftKey
    call MoveShooterLeft 
    jmp EndofKeyisPressed
	
    NotLeftKey:
    cmp ah,4dh					
    jnz NotRightKey			 ;Move Shooter Right if Right button is pressed
    call MoveShooterRight
    jmp EndofKeyisPressed
	
    NotRightKey:
    cmp ah,1H                 	 ;Esc to exit the game

	Jnz NotESCKey
	call Gameover 
		
	NotESCKey:
    cmp ah,39h                            ;go spaceKey if up button is pressed

    jnz EndofKeyisPressed
    cmp ShotStatus, 1
    jz EndofKeyisPressed
    mov al,1                      	  ;intialize a new shot
    mov ShotStatus,1 
    mov al, ShooterCol
    mov ShotCol, al
    mov al, 24				  ;it will be decremented in the new MainLoop
    mov ShotRow,al 
			
    EndofKeyisPressed:
    ret
KeyisPressed  ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
MoveShooterLeft  Proc  
     cmp ShooterCol, 0
     JZ NoMoveLeft
     dec ShooterCol
     PrintShooter ShooterCol 
     mov al, ShooterCol   
     inc al
     delete 24, al
    NoMoveLeft:
    ret
MoveShooterLeft  ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
MoveShooterRight  Proc 
     cmp ShooterCol, 79
     JZ NoMoveRight
     inc ShooterCol
     PrintShooter ShooterCol  
     mov al, ShooterCol   
     dec al
     delete 24, al 
     NoMoveRight:
    ret
MoveShooterRight  ENDP 
;//////////////////////////////////////////////////////////////////////////////////////

MoveShot  Proc 
    dec ShotRow
    PrintShot ShotRow,ShotCol 
    mov al, ShotRow  
    inc al
    delete al, ShotCol    
    ret
MoveShot  ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
CheckShotStatus  Proc
    push ax
    
    mov ah,DuckRow
    inc ah                          ; Checking the row I {WILL} draw the shot in if occupied by a duck
    cmp ah, ShotRow  
    JNZ CheckEndRange 
                                    ; Check if it was a hit
        mov al,ShotCol
        cmp al, DuckColLeft
        JZ Hit      
        cmp al, DuckColCenter
        JZ Hit
        cmp al, DuckColRight
        JZ Hit     
        cmp DuckDirection, 0
        jnz RightDirection
        mov ah, DuckColLeft
        dec ah
        cmp al, ah
        JZ Hit
        jmp CheckEndRange
        RightDirection:
        mov ah, DuckColRight
        inc ah
        cmp al, ah
        JZ Hit
        
   ;//////////////////////////////////////////////////////////////////////////////////////
   CheckEndRange:
     cmp ShotRow, 2          ; It stops while printed on the number of row I put here
     jnz noChange           
     dec Lifes
     cmp Lifes, 0
     jnz ResetTheShot
     call Gameover
     
     Hit: inc Hits
     inc Lifes
     call DeleteDuck
     call ResetDuck
     ResetTheShot:
     call ResetShot
     call UpdateStrings
     noChange:
     
    pop ax
    ret    
CheckShotStatus ENDP


;//////////////////////////////////////////////////////////////////////////////////////
Difficulty Proc
	
	cmp Hits, 5
	jle EasyGame					
	cmp Hits, 10
	jle HardGame
	Delay 0,10000
	PrintText 0, 67, ExtremeMode ;Extreme Mode when 10<Hits
	jmp EndDifficulty
	
	HardGame: Delay 0,20000		;Hard Mode when 10<=Hits<5
	PrintText 0, 70, HardMode
	jmp EndDifficulty
	
	EasyGame: Delay 0,20000			;Easy Mode when Hits<=5
	EndDifficulty:
	ret
Difficulty ENDP
;//////////////////////////////////////////////////////////////////////////////////////
DeleteDuck Proc
	 Delete DuckRow, DuckColLeft
	 Delete DuckRow, DuckColCenter
	 Delete DuckRow, DuckColRight
	ret
DeleteDuck ENDP

;//////////////////////////////////////////////////////////////////////////////////////
RandomiseDuckRow Proc    
   push ax
   push bx
   push cx
   push dx 
   
   ; Range of row= [5,24]
   mov ah, 2ch                
   int 21h                      		; get system time where DH = second   Dl=MilliSeconds
   xor ax, ax
   mov al, dl
   mov bl, 20					; That limits the remainder to be [0,19]
   div bl
   add ah, 3					; The range would be= [3,22]
   mov DuckRow, ah   	 		
   
   ; Change the color of duck
   NotBlack:
   add DuckColor ,10h				; Add one to background color
   mov ah, DuckColor
   and ah, 10h
   cmp ah ,00h
   jz NotBlack
        
   pop dx
   pop cx
   pop bx
   pop ax
   ret  
RandomiseDuckRow ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
ResetDuck Proc
    call RandomiseDuckDirection
	call RandomiseDuckRow
	
	cmp DuckDirection, 1
	jnz movementLeft
	mov DuckColLeft, 0	 
    mov DuckColCenter, 1
	mov DuckColRight, 2
	jmp EndOfResetDuck
	
	movementLeft:
	mov DuckColLeft, 78	
	mov DuckColCenter, 79
	mov DuckColRight, 80
    
    EndOfResetDuck: 
    ret 
ResetDuck ENDP 

;//////////////////////////////////////////////////////////////////////////////////////
RandomiseDuckDirection Proc
   push ax
   push bx
   push cx
   push dx 

   mov ah, 2ch                
   int 21h                      ; get system time where DH = second   Dl=MilliSeconds
   xor ax, ax
   mov al, dl
   mov bl, 2                    ; That limits the remainder to be [0,1]
   div bl                       
   mov DuckDirection, ah

   pop dx
   pop cx
   pop bx
   pop ax
   ret
RandomiseDuckDirection ENDP


;//////////////////////////////////////////////////////////////////////////////////////
ResetShot Proc
	 delete ShotRow, ShotCol  
     mov al,0          
     mov ShotStatus,al 
	ret
ResetShot ENDP 
;//////////////////////////////////////////////////////////////////////////////////////
StartMenu Proc
    
	push ax
	push bx
	push cx
	push dx
	push ds 

	ClearScreen
	LoopOnName:
	PrintText 8,8,AskPlayerName

	;Receive player name from the user
	mov ah, 0Ah
	mov dx, offset PlayerName
	int 21h

	cmp PlayerName[1], 0	;Check that input is not empty
	jz LoopOnName

	;Checks on the first letter to ensure that it's either a capital letter or a small letter
	cmp PlayerName[2], 40h
	jbe LoopOnName
	cmp PlayerName[2], 7Bh
	jae LoopOnName
	cmp PlayerName[2], 60h
	jbe	anotherCheck
	ja ExitLoopOnName
	anotherCheck:
	cmp PlayerName[2], 5Ah
	ja	LoopOnName

	ExitLoopOnName:
	ClearScreen
	PrintText 1,1,StartScreen	

	;hide curser
	 mov ah,01h
	  ;If bit 5 of CH is set, that often means "Hide cursor". So CX=2607h is an invisible cursor.
	 mov cx,2607h 
	 int 10h

	checkforinput:
	mov AH,0            		 
	int 16H 

	cmp al,13              		     ;Enter to Start Game   
	JE StartTheGame

	cmp ah,1H                 		 ;Esc to exit the game
	JE ExitMenu
	JNE checkforinput

	ExitMenu:
	mov ah,4CH
	int 21H

	StartTheGame: 
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax 
	RET
StartMenu ENDP
;//////////////////////////////////////////////////////////////////////////////////////
 Gameover Proc 
 ClearScreen

 PrintText 1, 30, PlayerName
 PrintText 3, 25,FinalScoreString
 PrintText 5, 5 ,GameoverScreen

 
    mov ah,4CH
    int 21H 
    ret
 Gameover ENDP 
;//////////////////////////////////////////////////////////////////////////////////////
DrawInterface	Proc
	
	push ax
	push cx
	push dx
	
	; Set the entire screen to blue background
	mov ah, 09h         ; BIOS function to print character with attribute
	mov al, ' '         ; Print a space character
	mov bh, 0           ; Page number (0 for all text modes)
	mov cx, 2000        ; Total characters on the screen (80x25)
	mov bl, newColorSkyBlue  ; Blue background color attribute
	int 10h             ; BIOS interrupt call
	
	; Go to the line beginning and print characters
	mov al, 0
	mov cx, 80
	DrawLineloop1:
		Print 1, al, 30h  ; Assuming the rocket gun moves in the second row
		inc al
	loop DrawLineloop1
	
	; Print other interface elements
	mov al, ' '
	mov PlayerName[0], al
	mov PlayerName[1], al
	PrintText 1, 0, PlayerName
	PrintText 1, 56, Disp_Hits
	PrintText 1, 70, Disp_lifes	
	PrintText 1, 24, GameTitle
	PrintText 0, 70, EasyMode
	
	PrintText 1, 67, separate
	
	pop dx
	pop cx
	pop ax
	RET
DrawInterface	ENDP


;//////////////////////////////////////////////////////////////////////////////////////
  
MODE_1_PROC ENDP









MODE_2_PROC PROC
    ; Code for MODE 2
    

 mov ax, @data
    mov ds, ax

    ; Set video mode to 13h (320x200, 256 colors)
    mov ax, 0013h
    int 10h

    ; Set the entire screen to sky blue
    mov ax, 0A000h     ; Graphics memory segment
    mov es, ax
    mov di, 0          ; Start at the beginning of video memory

    mov cx, 320*100    ; Total pixels in the top half of the screen
    mov al, newColorSkyBlue   ; Sky blue color
    rep stosb          ; Fill video memory with the new color

    ; Set the bottom half of the screen to brown
    mov di, 320*100    ; Start below the sky blue area
    mov cx, 320*50     ; Total pixels for the brown layer
    mov al, newColorgreen     ; Brown color
    rep stosb          ; Fill video memory with the new color

    ; Set a thin layer of green above the brown
    mov di, 320*150    ; Start below the brown layer
    mov cx, 320*45     ; Total pixels for the green layer
    mov al, newColorbrown     ; Green color
    rep stosb          ; Fill video memory with the new color


    ; Wait for a keypress before exiting
    mov ah, 0
    int 16h

    ; Set video mode back to text mode
    mov ax, 0003h
    int 10h


CALL MODE_1_PROC
ret


MODE_2_PROC ENDP


;//////////////////////////////////////////////////////////////////////////////////////
END MAIN    