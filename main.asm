; antic modes - https://gury.atari8.info/refs/graphics_modes.php
; C:\MADS\mads -l -t main.asm - compile
; C:\Altira\altirra /singleinstance main.obx - run

; its 2 seria code

    org $2000 ; start section

SAVMSC = $0058 ; screen memory address in ATARI
SDLSTL = $0230 ; 16 bit display list starting address

screen = $4000 ; screen buffer - we are going writing screen stuff here
blank8 = $70 ; 8 blank lines variable, blank lines needed for ATARI screen, area where none to show - over scan
lms = $40 ; Load Memory Scan
jvb = $41 ; Jump while vertical blank

; Antic modes - its graphics mode (colors, pixels) for Atari
antic2 = 2 
antic3 = 3
antic4 = 4
antic5 = 5 ; 12 lines - 40 column 12 rows
antic6 = 6
antic7 = 7

; Load display list
    lda #<dlist ; load first byte of address of display list in 0203
    sta SDLSTL ; store it
    lda #>dlist ; load another byte in 0231
    sta SDLSTL+1 ; store it plus 1

; Main loop
    ldy #0 ; Y = 0, it needs for offset, Y registor, works with A registor, #0 - means literal 0, if 0 - means address, its not needed
loop    
    lda hello,y ; A registor, load to accumulator 
    sta screen,y ; it shows first bit without loop, store in accumulator (SAVMSC or screen) and Y need for correct saving, parenthesis its like a pointer in c++, need to uses that what in address
    iny ; increment Y
    cpy #12 ; compare with 12 cause 12 literals in ATARI word
    bne loop ; it looks if cpy is true its 0 flag for bne, and loop continues, if cpy is false its 1 flag, and bne exit loop

    jmp * ; jump to star means that it will be infinite, like a infinite, while exit

; Display List
dlist
    .byte blank8, blank8, blank8 ; over scan (none seen lines) - actually 24 blank lines for ATARI
    ; antic for hello atari
    .byte antic5 + lms, <screen, >screen ; plus for a load memory scan, then < and > is a shift operator for sending $4000 to Antic  
    ; 11 rows in 12 antic rows - blue lines
    .byte antic5, antic5, antic5, antic5, antic5, antic5
	.byte antic5, antic5, antic5, antic5, antic5

    ; jump to display list
    .byte jvb, <dlist, >dlist 
; Data
hello ; label
    .byte "HELLO ATARI!" ; byte its allocate some space and store string in it