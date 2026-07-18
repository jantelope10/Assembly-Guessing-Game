; ------------------------------------------------------
; Program Description: 
; Author: 
; Creation Date:
; Language: IA-32 x86
; Assembler: Microsoft Macro Assembler (MASM)
; Collaboration: 
; ------------------------------------------------------

INCLUDE Irvine32.inc

.data

accountBalance DWORD 0
MAX_ALLOWED EQU 20
creditAmount DWORD 0			;can't be above 20, display error otherwise
correctGuesses DWORD 0
missedGuesses DWORD 0
nameMaxChars EQU 50
playerName BYTE nameMaxChars + 1 DUP(0)
moneyWon DWORD 0
moneyLost DWORD 0
gamesPlayed DWORD 0
currentBetAmount DWORD 0
roundGuessNumber DWORD 0
distanceNumber DWORD 0
currentRound DWORD 1

;General messages
typeToContinueMsg BYTE "* Press any key to continue... *", 0

;Beginning messages
menuIntro BYTE "Welcome to the 1st Edition of the TakingRISC Guessing Game!", 0dh, 0ah, 0dh, 0ah, 0
nameIntro BYTE "What is your name? (max 50 characters): ", 0
welcomeIntro BYTE "Welcome to the arena ", 0
welcomeOutro BYTE "!", 0

;MainMenu messages
errorInputMsg BYTE "Please type a number from 1-5 as displayed.", 0dh, 0ah, 0dh, 0ah, 0
menuListing BYTE "*** RISC-Y Business *** *** MAIN MENU ***", 0dh, 0ah, 0dh, 0ah,
					"Please select one of the following:", 0dh, 0ah, 0dh, 0ah,
					"1: Display my available credit", 0dh, 0ah, 0dh, 0ah,
					"2: Add credits to my account", 0dh, 0ah, 0dh, 0ah,
					"3: Play the guessing game", 0dh, 0ah, 0dh, 0ah,
					"4: Display my statistics", 0dh, 0ah, 0dh, 0ah,
					"5: Exit", 0dh, 0ah, 0dh, 0ah,
					"Enter the number corresponding to your choice (1-5): ", 0

;DisplayBalance messages
balanceMsg BYTE "Your current available balance is: $", 0

;AddCredits and ErrorAddCredits messages
addCreditsMsg BYTE "Please enter the amount of money you would like to add (don't enter more than $20): $", 0
passCreditsMsg BYTE "The money has been successfully added to your account, good luck!", 0dh, 0ah, 0dh, 0ah, 0
errorCreditsMsg BYTE "You entered an amount greater than $20, try again.", 0dh, 0ah, 0dh, 0ah, 0

;StartGame and all difficulties messages
startGameMsg BYTE "Welcome to the Guessing Game!", 0dh, 0ah,
					"-----------------------------", 0dh, 0ah, 0dh, 0ah,
					"Here we offer three difficulties (easy, medium, hard) with hard having the biggest cash pot!", 0dh, 0ah, 0dh, 0ah,
					"Which difficulty would you like to select? (type 1 for easy, 2 for medium, 3 for hard, 4 to return to main menu): ", 0
errorGameMsg BYTE "You entered a number that wasn't 1-3, try again.", 0dh, 0ah, 0dh, 0ah, 0
errorGameCreditsMsg BYTE "Your account doesn't have enough credits for your bet, try again.", 0dh, 0ah, 0dh, 0ah, 0
errorMinimalCreditsMsg BYTE "You didn't bet enough! If playing medium difficulty, you must bet a minimum of $5, ", 0dh, 0ah,
							"and for hard difficulty you must bet a minimum of $10. Try again.", 0dh, 0ah, 0dh, 0ah, 0
errorInvalidGuessMsg BYTE "Invalid guess! You were supposed to guess a number from 1-10, we are now ", 0dh, 0ah,
							"refunding your money and taking you back to the main menu.", 0dh, 0ah, 0dh, 0ah, 0
winnerMsg1 BYTE "Congratulations! You guessed the number correctly! I can't believe you actually beat my game!", 0dh, 0ah, 0dh, 0ah, 0
easyWinMsg BYTE "You won twice your bet, making your payout $", 0
mediumWinMsg BYTE "You won four times your bet, making your payout $", 0
hardWinMsg BYTE "You won eight times your bet, making your payout $", 0
winnerMsg2 BYTE "! Play again soon!", 0dh, 0ah, 0

roundMsg1 BYTE "Round ", 0
roundMsg2 BYTE "!", 0dh, 0ah,
				"--------", 0dh, 0ah, 0dh, 0ah, 0
easyRoundMsg BYTE "Please guess any number from 1-10: ", 0
mediumRoundMsg BYTE "Please guess any number from 1-25: ", 0
hardRoundMsg BYTE "Please guess any number from 1-50: ", 0
incorrectMsg1 BYTE "Your guess was incorrect. Luckily, your guess was within ", 0
incorrectMsg2 BYTE " numbers of the correct answer!", 0dh, 0ah, 0dh, 0ah, 0
lastRoundMsg1 BYTE "You lost! The number I chose was ", 0
lastRoundMsg2 BYTE ".", 0dh, 0ah, 0dh, 0ah,
					"You ended up losing your bet of $", 0
lastRoundMsg3 BYTE ", better luck next time!", 0dh, 0ah, 0dh, 0ah, 0

easyInstructions BYTE "Welcome to the Easy Difficulty!", 0dh, 0ah,
						"-------------------------------", 0dh, 0ah, 0dh, 0ah,
						"In this mode, a random number from 1-10 will be selected by me, 1 and 10 inclusive.", 0dh, 0ah,
						"You will have 3 rounds to guess what number I selected, each of which I will roughly ", 0dh, 0ah,
						"tell you how far away you are from my number. Easy, right?", 0dh, 0ah, 0dh, 0ah,
						"Win the game to win double your bet!!", 0dh, 0ah, 0dh, 0ah, 0
easyBetMsg1 BYTE "Since this is Easy Difficulty, you can bet any amount you want, ", 0dh, 0ah,
					"as long as you have that available in your account balance.", 0dh, 0ah, 0dh, 0ah,
				"How much would you like to bet for this round? (Your current account balance is $", 0
easyBetMsg2 BYTE "): ", 0

mediumInstructions BYTE "Welcome to the Medium Difficulty!", 0dh, 0ah,
						"---------------------------------", 0dh, 0ah, 0dh, 0ah,
						"In this mode, a random number from 1-25 will be selected by me, 1 and 25 inclusive.", 0dh, 0ah,
						"You will have 3 rounds to guess what number I selected, each of which I will roughly ", 0dh, 0ah,
						"tell you how far away you are from my number. Tough, right?", 0dh, 0ah, 0dh, 0ah,
						"Win the game to win four times your bet!!", 0dh, 0ah, 0dh, 0ah, 0
mediumBetMsg1 BYTE "In this difficulty, you must bet a minimum of $5.", 0dh, 0ah,
					"How much would you like to bet for this round? (Your current account balance is $", 0
mediumBetMsg2 BYTE "): ", 0

hardInstructions BYTE "Welcome to the Hard Difficulty!", 0dh, 0ah,
						"-------------------------------", 0dh, 0ah, 0dh, 0ah,
						"In this mode, a random number from 1-50 will be selected by me, 1 and 50 inclusive.", 0dh, 0ah,
						"You will have 3 rounds to guess what number I selected, each of which I will roughly ", 0dh, 0ah,
						"tell you how far away you are from my number. Difficult, right?", 0dh, 0ah, 0dh, 0ah,
						"Win the game to win eight times your bet!!", 0dh, 0ah, 0dh, 0ah, 0
hardBetMsg1 BYTE "In this difficulty, you must bet a minimum of $10.", 0dh, 0ah,
				"How much would you like to bet for this round? (Your current account balance is $", 0
hardBetMsg2 BYTE "): ", 0
confirmingBetMsg1 BYTE "Excellent! Your bet is set at $", 0
confirmingBetMsg2 BYTE ". Let's begin!", 0dh, 0ah, 0dh, 0ah, 0


;DisplayGameStats and StatsDisplayer messages
displayGameStatsMsg BYTE "Here are your current stats:", 0dh, 0ah, 0dh, 0ah, 0
playerDisplayer BYTE "Player Name: ", 0
availableCreditDisplayer BYTE "Available Credit: $", 0
gamesPlayedDisplayer BYTE "Games Played: ", 0
correctGuessesDisplayer BYTE "Correct Guesses: ", 0
missedGuessesDisplayer BYTE "Missed Guesses: ", 0
moneyWonDisplayer BYTE "Money You Won: $", 0
moneyLostDisplayer BYTE "Money You Lost: $", 0

;CloseGame messages
closeGameIntroMsg BYTE "Thank you for playing the TakingRISC Guessing Game, ", 0
closeGameOutroMsg BYTE "! Let's take one last look at your final stats:", 0dh, 0ah, 0dh, 0ah, 0
outroMsg BYTE "Come back soon!", 0dh, 0ah, 0dh, 0ah,
				"* Press any key to close... *", 0

.code
main proc

mov edx, OFFSET menuIntro
call writeString
mov edx, OFFSET typeToContinueMsg
call writeString
call readChar
call clrscr

mov edx, OFFSET nameIntro
call writeString
mov edx, OFFSET playerName
mov ecx, nameMaxChars
call readString
call crlf

mov edx, OFFSET welcomeIntro
call writeString
mov edx, OFFSET playerName
call writeString
mov edx, OFFSET welcomeOutro
call writeString

call crlf
call crlf
mov edx, OFFSET typeToContinueMsg
call writeString
call readChar


MainMenu:
	call clrscr
	mov edx, OFFSET menuListing
	call writeString
	call readInt

	cmp eax, 1
	je DisplayBalance
	cmp eax, 2
	je AddCredits
	cmp eax, 3
	je StartGame
	cmp eax, 4
	je DisplayGameStats
	cmp eax, 5
	je CloseGame

	call crlf
	mov edx, OFFSET errorInputMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


DisplayBalance:
	call clrscr
	mov edx, OFFSET balanceMsg
	call writeString
	mov eax, accountBalance
	call writeInt
	call crlf
	call crlf

	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


AddCredits:
	call clrscr
	mov edx, OFFSET addCreditsMsg
	call writeString
	call readInt

	cmp eax, 20
	ja ErrorAddCredits

	mov ebx, accountBalance
	add eax, ebx
	mov accountBalance, eax
	mov creditAmount, 0

	call crlf
	mov edx, OFFSET passCreditsMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


ErrorAddCredits:
	call crlf
	mov edx, OFFSET errorCreditsMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	call clrscr
	jmp AddCredits


StartGame:
	call clrscr
	mov edx, OFFSET startGameMsg
	call writeString
	call readInt

	cmp eax, 1
	jl ErrorStartGameChoice
	je EasyDifficulty
	cmp eax, 2
	je MediumDifficulty
	cmp eax, 3
	je HardDifficulty
	cmp eax, 4
	je MainMenu
	ja ErrorStartGameChoice


EasyDifficulty:
	call clrscr
	mov edx, OFFSET easyInstructions
	call writeString

	mov edx, OFFSET easyBetMsg1
	call writeString
	mov eax, accountBalance
	call writeInt
	mov edx, OFFSET easyBetMsg2
	call writeString
	call readInt

	cmp eax, accountBalance
	jg ErrorStartGameCredits
	cmp eax, 0
	jle ErrorMinimalCredits
	mov currentBetAmount, eax

	call crlf
	mov edx, OFFSET confirmingBetMsg1
	call writeString
	call writeInt
	mov edx, OFFSET confirmingBetMsg2
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	call clrscr

	call GenerateEasyNumber

	mov ecx, 3
	EasyRounds:
		push ecx
		mov edx, OFFSET roundMsg1
		call writeString
		mov eax, currentRound
		call writeInt
		mov edx, OFFSET roundMsg2
		call writeString
		mov edx, OFFSET easyRoundMsg
		call writeString
		call readInt

		cmp eax, 10
		jg ErrorInvalidGuess
		cmp eax, 0
		jle ErrorInvalidGuess
		cmp eax, roundGuessNumber
		je EasyRoundWinner

		call NumberDistance
		call crlf
		mov edx, OFFSET incorrectMsg1
		call writeString
		mov eax, distanceNumber
		call writeInt
		mov edx, OFFSET incorrectMsg2
		call writeString
		mov edx, OFFSET typeToContinueMsg
		call writeString
		call readChar
		call clrscr
		inc currentRound
		pop ecx
		dec ecx
	jnz EasyRounds

	mov edx, OFFSET lastRoundMsg1
	call writeString
	mov eax, roundGuessNumber
	call writeInt
	mov edx, OFFSET lastRoundMsg2
	call writeString
	mov eax, currentBetAmount
	call writeInt
	mov edx, OFFSET lastRoundMsg3
	call writeString
	sub accountBalance, eax
	add moneyLost, eax
	inc missedGuesses
	inc gamesPlayed
	mov currentRound, 1
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


MediumDifficulty:
	call clrscr
	mov edx, OFFSET mediumInstructions
	call writeString

	mov edx, OFFSET mediumBetMsg1
	call writeString
	mov eax, accountBalance
	call writeInt
	mov edx, OFFSET mediumBetMsg2
	call writeString
	call readInt

	cmp eax, accountBalance
	jg ErrorStartGameCredits
	cmp eax, 5
	jl ErrorMinimalCredits
	mov currentBetAmount, eax

	call crlf
	mov edx, OFFSET confirmingBetMsg1
	call writeString
	call writeInt
	mov edx, OFFSET confirmingBetMsg2
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	call clrscr

	call GenerateMediumNumber

	mov ecx, 3
	MediumRounds:
		push ecx
		mov edx, OFFSET roundMsg1
		call writeString
		mov eax, currentRound
		call writeInt
		mov edx, OFFSET roundMsg2
		call writeString
		mov edx, OFFSET mediumRoundMsg
		call writeString
		call readInt

		cmp eax, 25
		jg ErrorInvalidGuess
		cmp eax, 0
		jle ErrorInvalidGuess
		cmp eax, roundGuessNumber
		je MediumRoundWinner

		call NumberDistance
		call crlf
		mov edx, OFFSET incorrectMsg1
		call writeString
		mov eax, distanceNumber
		call writeInt
		mov edx, OFFSET incorrectMsg2
		call writeString
		mov edx, OFFSET typeToContinueMsg
		call writeString
		call readChar
		call clrscr
		inc currentRound
		pop ecx
		dec ecx
	jnz MediumRounds

	mov edx, OFFSET lastRoundMsg1
	call writeString
	mov eax, roundGuessNumber
	call writeInt
	mov edx, OFFSET lastRoundMsg2
	call writeString
	mov eax, currentBetAmount
	call writeInt
	mov edx, OFFSET lastRoundMsg3
	call writeString
	sub accountBalance, eax
	add moneyLost, eax
	inc missedGuesses
	inc gamesPlayed
	mov currentRound, 1
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu
	

HardDifficulty:
	call clrscr
	mov edx, OFFSET hardInstructions
	call writeString

	mov edx, OFFSET hardBetMsg1
	call writeString
	mov eax, accountBalance
	call writeInt
	mov edx, OFFSET hardBetMsg2
	call writeString
	call readInt

	cmp eax, accountBalance
	jg ErrorStartGameCredits
	cmp eax, 10
	jl ErrorMinimalCredits
	mov currentBetAmount, eax

	call crlf
	mov edx, OFFSET confirmingBetMsg1
	call writeString
	call writeInt
	mov edx, OFFSET confirmingBetMsg2
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	call clrscr

	call GenerateHardNumber

	mov ecx, 3
	HardRounds:
		push ecx
		mov edx, OFFSET roundMsg1
		call writeString
		mov eax, currentRound
		call writeInt
		mov edx, OFFSET roundMsg2
		call writeString
		mov edx, OFFSET hardRoundMsg
		call writeString
		call readInt

		cmp eax, 50
		jg ErrorInvalidGuess
		cmp eax, 0
		jle ErrorInvalidGuess
		cmp eax, roundGuessNumber
		je HardRoundWinner

		call NumberDistance
		call crlf
		mov edx, OFFSET incorrectMsg1
		call writeString
		mov eax, distanceNumber
		call writeInt
		mov edx, OFFSET incorrectMsg2
		call writeString
		mov edx, OFFSET typeToContinueMsg
		call writeString
		call readChar
		call clrscr
		inc currentRound
		pop ecx
		dec ecx
	jnz HardRounds

	mov edx, OFFSET lastRoundMsg1
	call writeString
	mov eax, roundGuessNumber
	call writeInt
	mov edx, OFFSET lastRoundMsg2
	call writeString
	mov eax, currentBetAmount
	call writeInt
	mov edx, OFFSET lastRoundMsg3
	call writeString
	sub accountBalance, eax
	add moneyLost, eax
	inc missedGuesses
	inc gamesPlayed
	mov currentRound, 1
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu
	

GenerateEasyNumber:
	mov eax, 10
	call RandomRange
	inc eax
	mov roundGuessNumber, eax
	ret


GenerateMediumNumber:
	mov eax, 25
	call RandomRange
	inc eax
	mov roundGuessNumber, eax
	ret


GenerateHardNumber:
	mov eax, 50
	call RandomRange
	inc eax
	mov roundGuessNumber, eax
	ret


NumberDistance:
	sub eax, roundGuessNumber
	jns IsPositive
	neg eax
IsPositive:
	mov ebx, 6
	mov edx, 0
	div ebx
	inc eax
	mov ebx, 5
	mul ebx
	mov distanceNumber, eax
	ret


EasyRoundWinner:
	call crlf
	mov edx, OFFSET winnerMsg1
	call writeString
	mov edx, OFFSET easyWinMsg
	call writeString
	mov eax, currentBetAmount
	mov ebx, 2
	mul ebx
	call writeInt
	mov edx, OFFSET winnerMsg2
	call writeString
	add accountBalance, eax
	add moneyWon, eax
	inc correctGuesses
	inc gamesPlayed
	mov currentRound, 1

	call crlf
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


MediumRoundWinner:
	call crlf
	mov edx, OFFSET winnerMsg1
	call writeString
	mov edx, OFFSET mediumWinMsg
	call writeString
	mov eax, currentBetAmount
	mov ebx, 4
	mul ebx
	call writeInt
	mov edx, OFFSET winnerMsg2
	call writeString
	add accountBalance, eax
	add moneyWon, eax
	inc correctGuesses
	inc gamesPlayed
	mov currentRound, 1

	call crlf
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


HardRoundWinner:
	call crlf
	mov edx, OFFSET winnerMsg1
	call writeString
	mov edx, OFFSET hardWinMsg
	call writeString
	mov eax, currentBetAmount
	mov ebx, 8
	mul ebx
	call writeInt
	mov edx, OFFSET winnerMsg2
	call writeString
	add accountBalance, eax
	add moneyWon, eax
	inc correctGuesses
	inc gamesPlayed

	call crlf
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


ErrorStartGameChoice:
	call crlf
	mov edx, OFFSET errorGameMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp StartGame


ErrorStartGameCredits:
	call crlf
	mov edx, OFFSET errorGameCreditsMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


ErrorMinimalCredits:
	call crlf
	mov edx, OFFSET errorMinimalCreditsMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp StartGame


ErrorInvalidGuess:
	call crlf
	mov edx, OFFSET errorInvalidGuessMsg
	call writeString
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


DisplayGameStats:
	call clrscr
	mov edx, OFFSET displayGameStatsMsg
	call writeString
	call StatsDisplayer
	mov edx, OFFSET typeToContinueMsg
	call writeString
	call readChar
	jmp MainMenu


StatsDisplayer:								;Allows this to be used by CloseGame function as well
	mov edx, OFFSET playerDisplayer
	call writeString
	mov edx, OFFSET playerName
	call writeString
	call crlf

	mov edx, OFFSET availableCreditDisplayer
	call writeString
	mov eax, accountBalance
	call writeInt
	call crlf

	mov edx, OFFSET gamesPlayedDisplayer
	call writeString
	mov eax, gamesPlayed
	call writeInt
	call crlf

	mov edx, OFFSET correctGuessesDisplayer
	call writeString
	mov eax, correctGuesses
	call writeInt
	call crlf

	mov edx, OFFSET missedGuessesDisplayer
	call writeString
	mov eax, missedGuesses
	call writeInt
	call crlf

	mov edx, OFFSET moneyWonDisplayer
	call writeString
	mov eax, moneyWon
	call writeInt
	call crlf

	mov edx, OFFSET moneyLostDisplayer
	call writeString
	mov eax, moneyLost
	call writeInt
	call crlf
	call crlf

	ret


CloseGame:
	call clrscr
	mov edx, OFFSET closeGameIntroMsg
	call writeString
	mov edx, OFFSET playerName
	call writeString
	mov edx, OFFSET closeGameOutroMsg
	call writeString

	call StatsDisplayer

	mov edx, OFFSET outroMsg
	call writeString
	call readChar

exit
main endp

end main