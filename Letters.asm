#Eric Grant
#ewgrant
#create a 2d array of characters given three inital integers
#1.number of rows
#2.number of columns
#3.default letter
#
#1&2 [1-40]
#3 [0-25]
#
#once array is set, let user pick a point in the array to advance character

.text
#assign user input to t0
li $v0, 5
syscall
move $t0, $v0

blt $t0, 1, exit #exit if out of range [1-40]
bgt $t0, 40, exit #

#assign user input to t1
li $v0, 5
syscall
move $t1, $v0

blt $t1, 1, exit #exit if out of range [1-40]
bgt $t1, 40, exit #

#assign user input to t2
li $v0, 5
syscall
move $t2, $v0

blt $t2, 0, exit #exit if out of range [0-25]
bgt $t2, 25, exit #

addi $t2, $t2, 65 #change to ascii code

#set val for use later
li $t3, 0
addi $t4, $t1, 1

#set loop inital data
li $s0, 0 #loop start
mul $s1, $t0, $t1 #loop end
la $s2, arr #starting point in memory

#fill array with default character
loop1:
	sb $t2, 0($s2) #save character to point in array
	
	addi $s0, $s0, 1 #move to next count
	addi $s2, $s2, 1 #move to next point in memory
	
	#test if end of row, if yes, add null terminator
	div $s0, $t1
	mfhi $s3
	bnez $s3, skip1
	sb $t3, 0($s2)
	addi $s2, $s2, 1 #move to next point in memory
	
	skip1:
	blt $s0, $s1, loop1 #loop if array not full

#user select points to advance
loop3:
	#assign user input to t5
	li $v0, 5
	syscall
	move $t5, $v0
	
	bltz $t5, final #exit if less than 0
	bge $t5, $t0, final #exit if greater than rows
	
	#assign user input to t6
	li $v0, 5
	syscall
	move $t6, $v0
	
	bltz $t6, final #exit if less than 0
	bge $t6, $t1, final #exit if greater than columns
	
	#advance character
	la $s2, arr #array starting pointer
	mul $s6, $t5, $t4 #count to selected row
	add $s6, $s6, $t6 #count to selected column in row
	add $s2, $s2, $s6 #move pointer to selected point
	
	lb $s5, 0($s2) #load character at point
	addi $s5, $s5, 1 #advance character
	
	#prevent overflow
	ble $s5, 90, skip2
	li $s5, 65
	
	skip2:
	sb $s5, 0($s2) #re-save character
	
	b loop3

final:
#print new line
addi $a0, $0, 10
li $v0, 11
syscall

#set loop inital data
li $s0, 0 #loop start
move $s1, $t0 #loop end
la $s2, arr #starting point in memory

#print array
loop2:
	move $a0, $s2 #print row
	li $v0, 4
	syscall
	
	#print new line
	addi $a0, $0, 10
	li $v0, 11
	syscall
	
	add $s0, $s0, 1 #move to next count
	add $s2, $s2, $t4 #move to next row address
	blt $s0, $s1, loop2 #loop if array not fully printed

exit:
li $v0, 10
syscall

.data
arr: .space 1640