;This is a Tic Tac Toe Program!
.orig x3000
;***********************************************************************************
;*************************************** Main **************************************						MAIN
;***********************************************************************************

BR start

catsGame			;if cat's game	******************* CATS GAME **
JSR displayBoard		;display the board
JSR displayCats			;tell the players the game was a draw
catLoop
TRAP x20			;and ask if they want to play again
LD R6, negASCIIY		;if yes play again, else quit
ADD R6, R0, R6			;
BRz start			;
LD R6, negASCIIN		;if no, quit
ADD R6, R0, R6			;
BRz quit			;if neither n nor y entered, query again
BR catLoop

winner				;if winner *************************** WINNER **
JSR displayBoard		;display the board
JSR displayWinner		;tell the players the game has been won
winnerLoop
TRAP x20			;and ask if they want to play again
LD R6, negASCIIY		;if yes play again, else quit
ADD R6, R0, R6			;
BRz start			;
LD R6, negASCIIN		;if no, quit
ADD R6, R0, R6			;
BRz quit			;if neither n nor y entered, query again
BR winnerLoop

start				;************************************** START **
AND R0, R0, #0			;move away from  any previous
ADD R0, R0, #10			;text on the screen
TRAP x21
TRAP x21
TRAP x21
TRAP x21

JSR createBoard			;create the blank game board *** CREATE BOARD **
AND R0, R0, #0			;initialize memory pointer
ADD R0, R0, #5			;(register not needed)
ST R0, isFullCounter

mainLoop			;********************************** MAIN LOOP **
JSR displayBoard		;display the game board	************ PLAYER 1 **
JSR p1Prompt			;display p1 prompt
XBadInputEntered		;restart if bad input entered
TRAP x20			;get input
LD R6, ASCIICharInputConvert	;convert input
ADD R0, R6, R0			;
AND R6, R0, R0			;hold value in R6

				;***************************** CHECK P1 INPUT **
JSR checkP1Input		;check for validity of input

AND R0, R0, #0			;display returns
ADD R0, R0, #10			;
TRAP x21			;
TRAP x21			;
TRAP x21			;
TRAP x21			;
JSR  fillX			;fill location with X


LD R0, isFullCounter		;decrement counter *************** CHECK FULL **
ADD R0, R0, #-1			;
BRz catsGame			;board is full so start new game
ST R0, isFullCounter		;

LD R1, ASCIIXCheck
JSR checkWinner			;check to see if P1 has won **** CHECK WINNER **

JSR displayBoard		;display the board ***************** PLAYER 2 **
JSR p2Prompt			;display p2 prompt
OBadInputEntered		;restart if bad input entered
TRAP x20			;get input
LD R6, ASCIICharInputConvert	;convert input
ADD R0, R6, R0			;
AND R6, R0, R0			;hold value in R6

JSR checkP2Input		;check for validity of input

AND R0, R0, #0			;display return
ADD R0, R0, #10			;
TRAP x21			;
TRAP x21			;
TRAP x21			;
TRAP x21			;
JSR fillO			;fill location with O

LD R1, ASCIIOCheck
JSR checkWinner			;check to see if P1 has won **** CHECK WINNER **
BR mainLoop

quit				;************************************** QUIT **
HALT
ASCIICharInputConvert	.FILL #-48
isFullCounter		.FILL x0000
negASCIIY		.FILL #-121
negASCIIN		.FILL #-110


;***********************************************************************************						Check P1 Winner
;********************************** Check Winner ***********************************
;***********************************************************************************
;called with R1 containing negative ASCII "\"
checkWinner
;                                                  _____________________________
;_________________________________________________| Check horizontal top winner |
LD R6, cellOne			;check cell 1					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkTwo			;continue if there is an X/O in cell 1		|
				;						|
LD R6, cellTwo			;check cell 2					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp cellOne2			;continue if there is an X/O in cell 2		|
				;						|
LD R6, cellThree		;check cell 3					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp cellOne2			;if there is an X/O in cell 3, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
cellOne2
;                                             __________________________________
;____________________________________________| Check Descending Diagonal Winner |
				;						|
LD R6, cellFive			;check cell 5					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp cellOne3			;continue if there is an X\O in cell 5		|
				;						|
LD R6, cellNine			;check cell 9					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp cellOne3			;if there is an X\O in cell 9, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
cellOne3
;                                                   ____________________________
;__________________________________________________| Check Left Vertical Winner |
				;						|
LD R6, cellFour			;check cell 4					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkTwo			;continue if there is an X/O in cell 4		|
				;						|
LD R6, cellSeven		;check cell 7					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "."		|
BRnp checkTwo			;if there is an X in cell 7, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
checkTwo
;                                                 ______________________________
;________________________________________________| Check Middle Vertical Winner |
LD R6, cellTwo			;check cell 2					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkThree			;continue if there is an X/O in cell 2		|
				;						|
LD R6, cellFive			;check cell 5					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkThree			;continue if there is an X/O in cell 5		|
				;						|
LD R6, cellEight		;check cell 8					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkThree			;if there is an X/O in cell 8, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
checkThree
;                                              _________________________________
;_____________________________________________| Check Ascending Diagonal Winner |
LD R6, cellThree		;check cell 3					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkFour			;continue if there is an X/O in cell 3		|
				;						|
LD R6, cellFive			;check cell 5					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkThree2		;continue if there is an X/O in cell 5		|
				;						|
LD R6, cellSeven		;check cell 7					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkThree2		;if there is an X/O in cell 7, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
checkThree2
;                                                  _____________________________
;_________________________________________________| Check right Vertical Winner |
				;						|
LD R6, cellSix			;check cell 6					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkFour			;continue if there is an X/O in cell 6		|
				;						|
LD R6, cellNine			;check cell 9					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "."		|
BRnp checkFour			;if there is an X in cell 9, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
checkFour
;                                               ________________________________
;______________________________________________| Check Middle Horizontal Winner |
LD R6, cellFour			;check cell 4					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkSeven			;continue if there is an X/O in cell 4		|
				;						|
LD R6, cellFive			;check cell 5					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkSeven		;continue if there is an X/O in cell 5		|
				;						|
LD R6, cellSix			;check cell 6					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp checkSeven		;if there is an X/O in cell 6, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|
checkSeven
;                                               ________________________________
;______________________________________________| Check Bottom Horizontal Winner |
LD R6, cellSeven		;check cell 7					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp noWinner			;continue if there is an X/O in cell 7		|
				;						|
LD R6, cellEight		;check cell 8					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp noWinner			;continue if there is an X/O in cell 8		|
				;						|
LD R6, cellNine			;check cell 9					|
LDR R0, R6, #0			;fill R0 with character at this location	|
ADD R0, R1, R0			;check to see if it's a "\" or "." 		|
BRnp noWinner			;if there is an X/O in cell 9, WINNER!		|
JSR winner			;						|
;_______________________________________________________________________________|

noWinner			;if no winner, return
RET

cellOne		.FILL x2B04	;Spot 1 position
cellTwo		.FILL x2B12	;Spot 2 position
cellThree	.FILL x2B20	;Spot 3 position
cellFour	.FILL x2C2A	;Spot 4 position
cellFive	.FILL x2C38	;Spot 5 position
cellSix		.FILL x2C46	;Spot 6 position
cellSeven	.FILL x2D50	;Spot 7 position
cellEight	.FILL x2D5E	;Spot 8 position
cellNine	.FILL x2D6C	;Spot 9 position
ASCIIXCheck	.FILL #-92	;negaitve ASCII "\"
ASCIIOCheck	.FILL #-46	;negative ASCII "."


;***********************************************************************************						Display Winner
;********************************* Display Winner **********************************
;***********************************************************************************
displayWinner
ADD R6, R7, #0		;TRAP x21 uses R7, so save it
LEA R1, #7		;Initialize R1 as pointer to c-string
LDR R0, R1, #0		;fill R0 with ascii value for first character in string
displayWinnerLoop
TRAP x21		;display character
ADD R1, R1, #1		;Fill R0 with
LDR R0, R1, #0		;next ASCII value
BRnp displayWinnerLoop	;loop if string not finished printing out
ADD R7, R6, #0		;Restore R7, then return
RET
.STRINGZ "Winner!\nPlay again? (y/n): "

;***********************************************************************************						Display Cat's
;********************************** Display Cat's **********************************
;***********************************************************************************
displayCats
ADD R6, R7, #0		;TRAP x21 uses R7, so save it
LEA R1, #7		;Initialize R1 as pointer to c-string
LDR R0, R1, #0		;fill R0 with ascii value for first character in string
displayCatsLoop
TRAP x21		;display character
ADD R1, R1, #1		;Fill R0 with
LDR R0, R1, #0		;next ASCII value
BRnp displayCatsLoop	;loop if string not finished printing out
ADD R7, R6, #0		;Restore R7, then return
RET
.STRINGZ "This game is a draw!\nPlay again? (y/n): "

;***********************************************************************************						Player 1 PROMPT
;********************************* Player 1 Prompt *********************************
;***********************************************************************************
p1Prompt
ADD R6, R7, #0		;TRAP x21 uses R7, so save it
LEA R1, #7		;Initialize R1 as pointer to c-string
LDR R0, R1, #0		;fill R0 with ascii value for first character in string
p1PromptLoop
TRAP x21		;display character
ADD R1, R1, #1		;Fill R0 with
LDR R0, R1, #0		;next ASCII value
BRnp p1PromptLoop	;loop if string not finished printing out
ADD R7, R6, #0		;Restore R7, then return
RET
.STRINGZ "Player 1's Turn: "

;***********************************************************************************						Player 2 PROMPT
;********************************* Player 2 Prompt *********************************
;***********************************************************************************
p2Prompt
ADD R6, R7, #0		;TRAP x21 uses R7, so save it
LEA R1, #7		;Initialize R1 as pointer to c-string
LDR R0, R1, #0		;fill R0 with ascii value for first character in string
p2PromptLoop
TRAP x21		;display character
ADD R1, R1, #1		;Fill R0 with
LDR R0, R1, #0		;next ASCII value
BRnp p2PromptLoop	;loop if string not finished printing out
ADD R7, R6, #0		;Restore R7, then return
RET
.STRINGZ "Player 2's Turn: "


;***********************************************************************************						DISPLAY BOARD
;***************************** Display Board Subroutine ****************************
;***********************************************************************************

;=====REGISTER USAGE======
;*************************
;R0 - I/O                *
;R1 -             	 *
;R2 -			 *
;R3 -        		 *
;R4 -			 *
;R5 - temp stores R7 	 *
;R6 - pointer  		 *
;R7 - return value	 *
;*************************

;==========CODE===========
displayBoard
ADD R5, R7, #0			;TRAP x21 uses R7, so save it
LD R6, pointerInitialize	;initialize pointer
LD R3, arraySize		;initialize counter		
LDR R0, R6, #0			;fill R0 with caracter to display         
				;				
displayLoop			;				
TRAP x21			;display character	
ADD R6, R6, #1			;increment pointer
LDR R0, R6, #0			;fill R0 with caracter to display		
ADD R3, R3, -1			;decrement counter		
BRp displayLoop			;loop until end of array found
ADD R7, R5, #0			;restore R7
RET				;return

;***********************************************************************************						CREATE BOARD
;***************************** Create Board Subroutine *****************************
;***********************************************************************************

;=====REGISTER USAGE======
;*************************
;R0 - holds ASCII values *
;R1 - used for calcs	 *
;R2 -			 *
;R3 - counter		 *
;R4 -			 *
;R5 -			 *
;R6 - pointer		 *
;R7 - return value	 *
;*************************


;==========CODE===========
createBoard
LD R6, pointerInitialize	;initialize pointer
;                        _______________________________
;_______________________| fill entire array with spaces |
;							|
LD R3, arraySize	;initialize counter		|
LD R0, space		;fill R0 with ASCII #32         |
			;				|
fillWithSpacesLoop	;				|
STR R0, R6, #0		;fill location with a space	|
ADD R6, R6, #1		;increment pointer		|
ADD R3, R3, -1		;decrement counter		|
BRp fillWithSpacesLoop	;loop until end of array found	|
;							|
;_______________________________________________________|
LD R6, pointerInitialize	;initialize pointer
;                       ________________________________
;______________________| fill arrary with needed endl's |
;							|
LD R3, arrayHeight	;initialize counter		|
LD R0, endl		;fill R0 with ASCII #10         |
LD R1, arrayWidth	;fill R1 with array width	|
ADD R6, R6, R1		;point to first endl needed	|
ADD R6, R6, #-1		;				|
STR R0, R6, #0		;store endl character		|
ADD R3, R3, -1		;decrement counter		|
			;				|
fillWithEndlsLoop	;				|
ADD R6, R6, R1		;point to next endl needed	|
STR R0, R6, #0		;store endl character		|
ADD R3, R3, -1		;decrement counter		|
BRp fillWithEndlsLoop	;loop until end of array found	|
;							|
;_______________________________________________________|
LD R6, pointerInitialize	;initialize pointer
;                          _____________________________
;_________________________| fill arrary with needed |'s |
;							|
LD R3, arrayHeight	;initialize counter		|
LD R0, upDash		;fill R0 with ASCII #124        |
ADD R6, R6, #13		;point to first "|" needed	|
STR R0, R6, #0		;store "|" character		|
ADD R6, R6, #14		;point to second "|" needed	|
STR R0, R6, #0		;store "|" character		|
ADD R3, R3, -1		;decrement counter		|
LD R1, twentyeight	;load R1 with decimal 28	|
			;				|
fillWithUpLoop		;				|
ADD R6, R6, R1		;point to next "|" needed	|
STR R0, R6, #0		;store "|" character		|
ADD R6, R6, #14		;point to next "|" needed	|
STR R0, R6, #0		;store "|" character		|
ADD R3, R3, -1		;decrement counter		|
BRp fillWithUpLoop	;loop until end of array found	|
;							|
;_______________________________________________________|
;                           ____________________________
;__________________________| fill array with needed '-'s|
;							|
LD R6, firstHoriz	;initialize pointer		|
LD R3, arrayWidth	;initialize counter	        |
ADD R3, R3, #-1		;				|
LD R0, sideDash		;fill R0 with ASCII #45         |
;							|
firstHorizLoop		;				|
STR R0, R6, #0		;fill location with "-"		|
ADD R6, R6, #1		;increment pointer		|
ADD R3, R3, #-1		;decrement counter		|
BRp firstHorizLoop	;loop unitl end of input	|
;							|
LD R6, secondHoriz	;initialize pointer		|
LD R3, arrayWidth	;initialize counter	        |
ADD R3, R3, #-1		;				|
;							|
secondHorizLoop		;				|
STR R0, R6, #0		;fill loaction with "-"		|
ADD R6, R6, #1		;increment pointer		|
ADD R3, R3, #-1		;decrement counter		|
BRp secondHorizLoop	;loop unitl end of input	|
;							|
;_______________________________________________________|
;                           ____________________________
;__________________________| fill array with needed '+'s|
;							|
LD R6, firstHoriz	;initialize pointer		|
LD R0, plus		;fill R0 with ASCII #43         |
;							|
ADD R6, R6, #13		;point to first plus		|
STR R0, R6, #0		;fill location with "+"		|
ADD R6, R6, #14		;increment pointer		|
STR R0, R6, #0		;fill location with "+"		|
LD R6, secondHoriz	;initialize pointer		|
;							|
ADD R6, R6, #13		;point to first plus		|
STR R0, R6, #0		;fill location with "+"		|
ADD R6, R6, #14		;increment pointer		|
STR R0, R6, #0		;fill location with "+"		|
;							|
;_______________________________________________________|
;                           ____________________________
;__________________________| fill array with needed '#'s|
;							|
LD R6, rowOneDigPos	;initialize pointer		|
AND R3, R3, #0		;initialize counter	        |
ADD R3, R3, #3		;				|
LD R0, ASCIIDigitConvert ;				|
CellNumberLoop		;				|
ADD R0, R0, #1		;increment digit 		|
STR R0, R6, #0		;store digit			|
ADD R6, R6, #14		;increment pointer		|
ADD R0, R0, #1		;increment digit		|
STR R0, R6, #0		;store digit			|
ADD R6, R6, #14		;increment pointer		|
ADD R0, R0, #1		;increment digit		|
STR R0, R6, #0		;store digit			|
LD R6, rowTwoDigPos	;				|
ADD R3, R3, #-2		;decrement counter		|
BRp CellNumberLoop	;				|
LD R6, rowThreeDigPos	;				|
ADD R3, R3, #1		;increment counter		|
BRz CellNumberLoop	;				|
;							|
;_______________________________________________________|

RET	;return

;===============MEMORY VALUES FOR CREATE BOARD SUBROUTINE===============

pointerInitialize 	.FILL x2B00		;location of first character in the board
endl 			.FILL #10		;ENTER key
upDash 			.FILL #124		; "|" key
plus 			.FILL #43		; "+" key
sideDash  		.FILL #45		; "-" key
space			.FILL #32		;space key
arraySize		.FILL #840		;Area of the board
arrayHeight		.FILL #20		;height of board
arrayWidth		.FILL #42		;width of board
twentyeight		.FILL #28		;decimal value 28
firstHoriz		.FILL x2BFC		;location of first horizontal line
secondHoriz		.FILL x2D22		;location of second horizontal line
rowOneDigPos		.FILL x2BDE		;location of digit in cell 1
rowTwoDigPos		.FILL x2D04		;Location of digit in cell 2
rowThreeDigPos		.FILL x2E2A		;Location of digit in cell 3
ASCIIDigitConvert	.FILL #48		;ASCII Digit Convert


;***********************************************************************************						FILL X
;*************************************** Fill X ************************************
;***********************************************************************************
;called with R6 containing the number of cell to put the X

;=====REGISTER USAGE======
;*************************
;R0 - holds ASCII values *
;R1 - used for calcs	 *
;R2 -			 *
;R3 - counter		 *
;R4 -			 *
;R5 -			 *
;R6 - pointer		 *
;R7 - return value	 *
;*************************

;==========CODE===========
fillX
ADD R6, R6, #-1
BRz pointXOne		;put an x in spot 1

ADD R6, R6, #-1
BRz pointXTwo		;put an x in spot 2

ADD R6, R6, #-1
BRz pointXThree		;put an x in spot 3

ADD R6, R6, #-1
BRz pointXFour		;put an x in spot 4

ADD R6, R6, #-1
BRz pointXFive		;put an x in spot 5

ADD R6, R6, #-1
BRz pointXSix		;put an x in spot 6

ADD R6, R6, #-1
BRz pointXSeven		;put an x in spot 7

ADD R6, R6, #-1
BRz pointXEight		;put an x in spot 8

BR pointXNine		;put an x in spot 9

;                                      _________________
;_____________________________________| point to cell 1 |
;							|
pointXOne		;				|
LD R6, onePos		;point to cell 2		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 2 |
;							|
pointXTwo		;				|
LD R6, twoPos		;point to cell 2		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 3 |
;							|
pointXThree		;				|
LD R6, threePos		;point to cell 3		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 4 |
;							|
pointXFour		;				|
LD R6, fourPos		;point to cell 4		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 5 |
;							|
pointXFive		;				|
LD R6, fivePos		;point to cell 5		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 6 |
;							|
pointXSix		;				|
LD R6, sixPos		;point to cell 6		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 7 |
;							|
pointXSeven		;				|
LD R6, sevenPos		;point to cell 2		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 8 |
;							|
pointXEight		;				|
LD R6, eightPos		;point to cell 8		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 9 |
;							|
pointXNine		;				|
LD R6, ninePos		;point to cell 9		|
BR fillTheX		;fill in an X			|
;							|
;_______________________________________________________|

;                                        _______________
;_______________________________________| fill in the X |
;							|
fillTheX			;			|
LD R0, descendingDash		;			|
STR R0, R6, #0			;			|
ADD R6, R6, #4			;			|
LD R0, ascendingDash		;			|
STR R0, R6, #0			;			|
LD R0, thirtynine		;			|
ADD R6, R6, R0			;			|
LD R0, descendingDash		;			|
STR R0, R6, #0			;			|
ADD R6, R6, #2			;			|
LD R0, ascendingDash		;			|
STR R0, R6, #0			;			|
LD R0, thirtynine		;			|
ADD R0, R0, #2			;			|
ADD R6, R0, R6			;			|
LD R0, xChar			;			|
STR R0, R6, #0			;			|
LD R0, thirtynine		;			|
ADD R0, R0, #2			;			|
ADD R6, R0, R6			;			|
LD R0, ascendingDash		;			|
STR R0, R6, #0			;			|
ADD R6, R6, #2			;			|
LD R0, descendingDash		;			|
STR R0, R6, #0			;			|
LD R0, thirtynine		;			|
ADD R6, R0, R6			;			|
LD R0, ascendingDash		;			|
STR R0, R6, #0			;			|
ADD R6, R6, #4			;			|
LD R0, descendingDash		;			|
STR R0, R6, #0			;			|
;_______________________________________________________|

RET			;Return

onePos		.FILL x2B04	;Spot 1 position
twoPos		.FILL x2B12	;Spot 2 position
threePos	.FILL x2B20	;Spot 3 position
fourPos		.FILL x2C2A	;Spot 4 position
fivePos		.FILL x2C38	;Spot 5 position
sixPos		.FILL x2C46	;Spot 6 position
sevenPos	.FILL x2D50	;Spot 7 position
eightPos	.FILL x2D5E	;Spot 8 position
ninePos		.FILL x2D6C	;Spot 9 position
descendingDash	.FILL #92	;ASCII "\"
ascendingDash	.FILL #47	;ASCII "/"
xChar		.FILL #88	;ASCII "X"
underscore	.FILL #95	;ASCII "_"
period		.FILL #46	;ASCII "."
apostrophe	.FILL #39	;ASCII '
thirtynine	.FILL #39	;decimal #39

;***********************************************************************************						FILL O
;*************************************** Fill O ************************************
;***********************************************************************************
;called with R6 containing the number of cell to put the O

;=====REGISTER USAGE======
;*************************
;R0 - holds ASCII values *
;R1 - used for calcs	 *
;R2 -			 *
;R3 - counter		 *
;R4 -			 *
;R5 -			 *
;R6 - pointer		 *
;R7 - return value	 *
;*************************

;==========CODE===========
fillO
ADD R6, R6, #-1
BRz pointOOne		;put an O in spot 1

ADD R6, R6, #-1
BRz pointOTwo		;put an O in spot 2

ADD R6, R6, #-1
BRz pointOThree		;put an O in spot 3

ADD R6, R6, #-1
BRz pointOFour		;put an O in spot 4

ADD R6, R6, #-1
BRz pointOFive		;put an O in spot 5

ADD R6, R6, #-1
BRz pointOSix		;put an O in spot 6

ADD R6, R6, #-1
BRz pointOSeven		;put an O in spot 7

ADD R6, R6, #-1
BRz pointOEight		;put an O in spot 8

BR pointONine		;put an O in spot 9

;                                      _________________
;_____________________________________| point to cell 1 |
;							|
pointOOne		;				|
LD R6, onePos		;point to cell 2		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 2 |
;							|
pointOTwo		;				|
LD R6, twoPos		;point to cell 2		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 3 |
;							|
pointOThree		;				|
LD R6, threePos		;point to cell 3		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 4 |
;							|
pointOFour		;				|
LD R6, fourPos		;point to cell 4		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 5 |
;							|
pointOFive		;				|
LD R6, fivePos		;point to cell 5		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 6 |
;							|
pointOSix		;				|
LD R6, sixPos		;point to cell 6		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 7 |
;							|
pointOSeven		;				|
LD R6, sevenPos		;point to cell 2		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 8 |
;							|
pointOEight		;				|
LD R6, eightPos		;point to cell 8		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;                                      _________________
;_____________________________________| point to cell 9 |
;							|
pointONine		;				|
LD R6, ninePos		;point to cell 9		|
BR fillTheO		;fill in an O			|
;							|
;_______________________________________________________|
;
;R0 = "/"
;R1 = "\"
;R2 = "-"
;R3 = "|"
;R4 = 39
;                                           ____________
;__________________________________________| Fill The O |
;							|
fillTheO		;				|
LD R0, ascendingDash	;				|
LD R1, descendingDash	;				|
LD R2, period		;				|
LD R3, upDash		;				|
LD R4, thirtynine	;				|
LD R5, sideDash		;				|
ADD R4, R4, #-2		;				|
STR R2, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R2, R6, #0		;				|
ADD R6, R6, R4		;				|
STR R0, R6, #0		;				|
ADD R6, R6, #6		;				|
STR R1, R6, #0		;				|
ADD R4, R4, #-2		;				|
ADD R6, R6, R4		;				|
STR R3, R6, #0		;				|
ADD R6, R6, #8		;				|
STR R3, R6, #0		;				|
ADD R6, R4, R6		;				|
STR R1, R6, #0		;				|
ADD R6, R6, #6		;				|
STR R0, R6, #0		;				|
ADD R4, R4, #1		;				|
ADD R4, R4, #1		;				|
ADD R6, R4, R6		;				|
LD R0, apostrophe	;				|
STR R0, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R5, R6, #0		;				|
ADD R6, R6, #1		;				|
STR R0, R6, #0		;				|
;							|
;_______________________________________________________|

RET			;Return

;***********************************************************************************						CHECK P2 Input
;********************************** Check P2 Input *********************************
;***********************************************************************************
;called with R6 containing the cell the X was added to.
;MUST perserve R6
;R0 - ASCII space
;R2 - counter
;R3 - used for temporary storage

checkP2Input
;                                          _____________________________
;_________________________________________| make sure it's a number 1-9 |
ADD R3, R6, #0				;				|
LD R0, negSpace                         ;				|
					;				|
ADD R3, R3, -1				;				|
BRz OCheckCell1				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell2				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell3				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell4				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell5				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell6				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell7				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell8				;				|
ADD R3, R3, -1				;				|
BRz OCheckCell9				;				|
BR OBadInput				;				|
;_______________________________________________________________________|
;                                              _________________________
;_____________________________________________| make sure cell is empty |
					;				|
OCheckCell1				;				|
LD R3, onePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell2				;				|
LD R3, twoPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell3				;				|
LD R3, threePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell4				;				|
LD R3, fourPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell5				;				|
LD R3, fivePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell6				;				|
LD R3, sixPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell7				;				|
LD R3, sevenPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell8				;				|
LD R3, eightPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
					;				|
OCheckCell9				;				|
LD R3, ninePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP2InputReturn			;				|
BR OBadInput				;				|
;_______________________________________________________________________|



checkP2InputReturn
RET

OBadInput
JSR OBadInputEntered

;***********************************************************************************						CHECK P1 Input
;********************************** Check P1 Input *********************************
;***********************************************************************************
;called with R6 containing the cell the X was added to.
;MUST perserve R6
;R0 - ASCII space
;R1 - ASCII period
;R2 - counter
;R3 - used for temporary storage
;R4

checkP1Input
;                                          _____________________________
;_________________________________________| make sure it's a number 1-9 |
ADD R3, R6, #0				;				|
LD R0, negSpace                         ;				|
					;				|
ADD R3, R3, -1				;				|
BRz XCheckCell1				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell2				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell3				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell4				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell5				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell6				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell7				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell8				;				|
ADD R3, R3, -1				;				|
BRz XCheckCell9				;				|
BR XBadInput				;				|
;_______________________________________________________________________|
;                                              _________________________
;_____________________________________________| make sure cell is empty |
					;				|
XCheckCell1				;				|
LD R3, onePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell2				;				|
LD R3, twoPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell3				;				|
LD R3, threePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell4				;				|
LD R3, fourPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell5				;				|
LD R3, fivePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell6				;				|
LD R3, sixPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell7				;				|
LD R3, sevenPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell8				;				|
LD R3, eightPos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
					;				|
XCheckCell9				;				|
LD R3, ninePos				;				|
LDR R3, R3, #0				;				|
ADD R3, R0, R3				;				|
BRz checkP1InputReturn			;				|
BR XBadInput				;				|
;_______________________________________________________________________|



checkP1InputReturn
RET

XBadInput
JSR XBadInputEntered

negSpace	.FILL #-32

.end