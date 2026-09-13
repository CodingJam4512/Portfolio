#Program: Etch-A-Sketch.asm
#Author: Jace Richardson
#DateStarted: 4/13/2024
#Purpose: Write a program that emulates an Etch-A-Sketch

#For Bitmap Display
	.eqv BASEADDRESS 0x10040000
	.eqv LILAC 0xc8a2cb
	.eqv SAFFRON 0xF4C430
	.eqv RED 0xff0000
	.eqv BLUE 0x0000ff
	.eqv GREEN 0x00ff00
	.eqv BLACK 0x000000
	.eqv BANANA 0xffe135

#For MMIO Keyboard
	.eqv CONTROL_REGISTER 0xffff0000
	.eqv DATA_REGISTER 0xffff0004

.text
.globl main
main:
		RewindTime:
		jal Border				#First generate a border
		jal Initlize				#Then initlize he middle dot which is saffron			
		li a3, SAFFRON				#The default color, no color will make the program fail
		mv t3, $v1				#The current postition is stored in $t3
		while:
			jal Keyboard			#In order to establish inputs from the user
			mv $t2, $v0			#move the current key into t2
			sne $t1, $t2, 0x72		#Exit program if r key is pressed
			beqz $t1, endWhile
			#True Code Block
			
			#Regular Inputs
			Wif: 				#if w key is pressed then go up
				seq $t1, $t2, 0x77	#First check key
				beqz $t1, WendIf
				lw $t8, -256($t3)	#Then check collision
				seq $t1, $t8, LILAC
				beq $t1, 1, WendIf
				#True code block
				move $a2, $t3		#Move the current location of the address into a2
				jal Up			#Go up
				move $v1, $t3		#Update the position
			WendIf:
			Aif: 				#if a key is pressed then go left
				seq $t1, $t2, 0x61
				beqz $t1, AendIf
				lw $t8, -4($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, AendIf
				#True code block
				move $a2, $t3
				jal Left
				move $v1, $t3
			AendIf:
			Sif: 				#if s key is pressed then go down
				seq $t1, $t2, 0x73
				beqz $t1, SendIf
				lw $t8, 256($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, SendIf
				#True code block
				move $a2, $t3
				jal Down
				move $v1, $t3
			SendIf:
			Dif: 				#if d key is pressed then go right
				seq $t1, $t2, 0x64
				beqz $t1, DendIf
				lw $t8, 4($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, DendIf
				#True code block
				move $a2, $t3
				jal Right
				move $v1, $t3
			DendIf:
			Qif: 				#if q key is pressed then go up left
				seq $t1, $t2, 0x71
				beqz $t1, QendIf
				lw $t8, -260($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, QendIf
				#True code block
				move $a2, $t3
				jal UpLeft
				move $v1, $t3
			QendIf:
			Eif: 				#if e key is pressed then go up right
				seq $t1, $t2, 0x65
				beqz $t1, EendIf
				lw $t8, -252($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, EendIf
				#True code block
				move $a2, $t3
				jal UpRight
				move $v1, $t3
			EendIf:
			Zif: 				#if z key is pressed then go down left
				seq $t1, $t2, 0x7A
				beqz $t1, ZendIf
				lw $t8, 252($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, ZendIf
				#True code block
				move $a2, $t3
				jal DownLeft
				move $v1, $t3
			ZendIf:
			Cif: 				#if c key is pressed then go down right
				seq $t1, $t2, 0x63
				beqz $t1, CendIf
				lw $t8, 260($t3)
				seq $t1, $t8, LILAC
				beq $t1, 1, CendIf
				#True code block
				move $a2, $t3
				jal DownRight
				move $v1, $t3
			CendIf:
			
			#Color Inputs
			Kif: 				#if k key is pressed then delete the pixel
				seq $t1, $t2, 0x6B	#Check for input
				beqz $t1, KendIf
				#True code block
				move $a2, $t3		#set current position
				jal Delete		#Turn the current black into BLACK
			KendIf:
			Iif: 				#if i key is pressed then switch color to red
				seq $t1, $t2, 0x69	#Check for input
				beqz $t1, IendIf
				#true code block
				li $a3, RED		#Set the address to red
			IendIf:
			Oif: 				#if o key is pressed then switch color to green
				seq $t1, $t2, 0x6F
				beqz $t1, OendIf
				#true code block
				li $a3, GREEN		#Green
			OendIf:		
			Pif: 				#if p key is pressed then switch color to blue
				seq $t1, $t2, 0x70
				beqz $t1, PendIf
				#true code block
				li $a3, BLUE		#Blue
			PendIf:
			
			#Special Keys
			#Randomize
			Lif: 				#if j key is pressed then switch color to blue
				seq $t1, $t2, 0x6C
				beqz $t1, LendIf
				#true code block
				jal Randomize		#Go to randomize and then go back to the beginning
				b RewindTime
			LendIf:	
			
			#Reset
			Jif: 				#if j key is pressed then switch color to blue
				seq $t1, $t2, 0x6A
				beqz $t1, JendIf
				#true code block
				jal Reset		#Reset the entire program
				b RewindTime
			JendIf:		
			
			#Save
			Gif:				#if g key is pressed then save current screen
				seq $t1, $t2, 0x67
				beqz $t1, GendIf
				#true code block
				jal Save		#Save the current bitmap into a text file
				jal RewindTime
			GendIf:	
			j while				#Go back to keyboard and do again!
		endWhile:
		jal Exit				#Terminate program :(

#------------------------------------------------------------------------------

#Subprogram: Border
#Author: Jace
#Purpose: To produce a border around the program interface
#input: Nothing
#output: Nothing
.text
Border:						#Using 256 we can make the bottom and top rows
	li $t4, BASEADDRESS			#This part involves incrementing the pixel
	li $t2, LILAC				#By four to set the current square to the
	li $t3, 0
	borderWhileTop:				#Fill the top layer
		slti $t0, $t3, 64		#When top is filled
		beqz $t0, borderTopEnd		#Stop
		#true code block
		sw $t2, 0($t4)			#Save the current postiiton to Lilac
		add $t4, $t4, 4			#Then move to the next bit
		#Update the loop
		addi $t3, $t3, 1
		b borderWhileTop
	borderTopEnd:
	add $t4, $t4, 15872			#This is tha ammount needed for the bottom
	li $t3, 0
	borderWhileBottom:			#Fill the bottom layer
		slti $t0, $t3, 64		#Same way as done for top layer
		beqz $t0, borderBottomEnd
		#true code block
		sw $t2, 0($t4)
		addi $t4, $t4, 4
		
		#Update the loop
		addi $t3, $t3, 1
		b borderWhileBottom
	borderBottomEnd:
	sub $t4, $t4, 16128
	li $t5, 0				#The sides will be different!
	li $t3, 0				#This part will do both sides in one while loop.
	borderWhileSides:			#First do the left side
		slti $t0, $t5, 124		#t3 is switched to 1
		beqz $t0, borderEndSides	#Then do right side
		#true code block		Repeat
		ifLeftSide:
			slti $t8, $t3, 1	# t3 < 1
			beqz $t8, elseRightSide
			#true code block
			sw $t2, 0($t4)
			add $t4, $t4, 252
			li $t3, 2
			b endSideIf
		elseRightSide:
			sw $t2, 0($t4)
			add $t4, $t4, 4
			li $t3, 0
		endSideIf:
		#Update the loop
		addi $t5, $t5, 1
		b borderWhileSides
	borderEndSides:
	jr $ra

#------------------------------------------------------------------------------
#Subprogram: Initilize
#Author: Jace
#Purpose: Initlize the middle dot
#input: Nothing
#output: Nothing
.text
Initlize:
	li $t0, BASEADDRESS	#Load the position
	li $t7, SAFFRON		#Load the color
	add $t0, $t0, 8316	#Set the middle pixel to our start pixel
	sw $t7, 0($t0)		#Store the current bit's value as the color
	move $v1, $t0		#Move the new position to v1
	jr $ra			#Return
#------------------------------------------------------------------------------
#Subprogram: up
#Author: Jace
#Purpose: Go up
#input: $a2 = address/heap, $a3 = color
#output: $v1 = address/heap
.text
Up:
	move $t3, $a2		#Each direction has it's own number value to switch to
	move $t7, $a3		#in this case to go up, its -256
	add $t3, $t3, -256	#Store the current color chosen
	sw $t7, 0($t3)		#in the bit
	move $v1, $t3		#of course return the postion
	jr $ra			#Not making comments for every direction!
#------------------------------------------------------------------------------
#Subprogram: down
#Author: Jace
#Purpose: Go down
#input: $a2, $a3
#output: $v1
.text
Down:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, 256
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: left
#Author: Jace
#Purpose: Go left
#input: $a2, $a3
#output: $v1
.text
Left:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, -4
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra	
#------------------------------------------------------------------------------
#Subprogram: right
#Author: Jace
#Purpose: Go right
#input: $a2, $a3
#output: $v1
.text
Right:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, 4
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: upleft
#Author: Jace
#Purpose: go up and left
#input: $a2, $a3
#output: $v1
.text
UpLeft:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, -260
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra	
#------------------------------------------------------------------------------
#Subprogram: downleft
#Author: Jace
#Purpose: go down and left
#input: $a2, $a3
#output: $v1
.text
DownLeft:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, 252
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: upright
#Author: Jace
#Purpose: go up and right
#input: $a2, $a3
#output: $v1
.text
UpRight:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, -252
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: downright
#Author: Jace
#Purpose: go down and right
#input: $a2, $a3
#output: $v1
.text
DownRight:
	move $t3, $a2
	move $t7, $a3
	add $t3, $t3, 260
	sw $t7, 0($t3)
	move $v1, $t3
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: delete
#Author: Jace
#Purpose: delete the current bit
#input: $a2
#output: None
.text
Delete:
	move $t3, $a2		#Special 5th color, BLACK!
	li $t7 BLACK
	sw $t7, 0($t3)
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: Keyboard
#Author: Jace
#Purpose: For using the MMIO Keyboard
#input: Nothing
#output: $v0 = keyboard
.text
Keyboard:
	li $t9, CONTROL_REGISTER	#We gotta load the key!
	li $t8, DATA_REGISTER		#These two will help us get the ascii
	checkBoardLoop:
		lw $t6, 0($t9)		#load the word on the control register
	#now let's check the lab bit
	#by making all the bits equal to 0 except the ls bit 
		andi $t5, $t6, 0x1	#and it with 0x1
		beqz $t5 checkBoardLoop
	#true code block
	#read the data register
	lw $t4, 0($t8)			#the ascii code of the key is in $t4
	move $v0, $t4			#Move the key to v0
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: Reset
#Author: Jace
#Purpose: Reset the entire program
#input: None
#output: None
.text
Reset:
	li $t0, BASEADDRESS		
	li $t7, BLACK
	li $t3, 0
	ResetWhile:
		slti $t1, $t3, 4100	#Go from top to bottom
		beqz $t1, ResetDone	#and delete every key with black until done
		#True Code Block
		sw $t7, 0($t0)
		add $t0, $t0, 4
		add $t3, $t3, 1
		b ResetWhile
	ResetDone:
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: Randomize
#Author: Jace
#Purpose: Randomize everything
#input: Nothing
#output: Nothing
.text
Randomize:
	li $t0, BASEADDRESS			#For this program, we need
	add $t0, $t0, 256			#This exact location
	li $t3, 0
	Randomizing:
		slti $t1, $t3, 4000		#Until the end
		beqz $t1, Randomized		#The whole screen shall be colored!
		#True Code Block
			#skip if current bit equals lilac
			lw $t4, 0($t0)
			seq $t1, $t4, LILAC
			beq $t1, 1, Skip
		li $a1, 5			#This is the max numger, 5 for 5 colors
		li $v0, 42			#Roll a number
		syscall				#perform syscall
		
		#if
			seq $t1, $a0, 0		#RNG = 0
			beqz $t1, Oneelse
			li $t7, BLACK
			b endElse
		Oneelse:
			seq $t1, $a0, 1		#RNG = 1
			beqz $t1, Twoelse
			li $t7, SAFFRON
			b endElse
		Twoelse:
			seq $t1, $a0 2		#RNG = 2
			beqz $t1, Threeelse
			li $t7, RED
			b endElse
		Threeelse:
			seq $t1, $a0, 3		#RNG = 3
			beqz $t1, Fourelse
			li $t7, GREEN
			b endElse
		Fourelse:
			li $t7, BLUE		#RNG = 4
		endElse:
		sw $t7, 0($t0)			#Then color one of the five colors
		Skip:
		add $t0, $t0, 4			#Update the loop
		add $t3, $t3, 1
		b Randomizing
	Randomized:
	jr $ra
#------------------------------------------------------------------------------
#Subprogram: Save
#Author: Jace
#Purpose: Takes each number and puts its address in a text document
#input: None
#output: None
.data
	fout: .asciiz "Etch-A-Save.txt"
	done: .asciiz "done"
.text
Save:
	# Open (for writing) a file that does not exist
	addi $sp, $sp, -4			#First push before anything else
	sw $s6, 0($sp)				#Before accessing the save registers
	li $v0, 13 				# system call for open file
	la $a0, fout 				# output file name
	li $a1, 1				# Open for writing (flags are 0: read, 1: write)
	li $a2, 0 				# mode is ignored
	syscall					# open a file (file descriptor returned in $v0)
	move $s6, $v0 				# save the file descriptor
	li $t0, BASEADDRESS			#Load the first part of the address, and 0
	li $t3, 0
	# Write to file just opened
	li $v0, 15 				# system call for write to file
	move $a0, $s6 				# file descriptor
	move $a1, $t0	 			# address of buffer from which to write
	li $a2, 16384				# hardcoded buffer length
	syscall 				# write to file
	# Close the file
	li $v0, 16 				# system call for close file
	move $a0, $s6				# file descriptor to close
	syscall 				# close file
	lw $s6, 0($sp)				#Finally pop the stack!
	addi $sp, $sp, 4
	jr $ra
#-------------------------------------------------------------------------------------------
.include "utils.asm"
