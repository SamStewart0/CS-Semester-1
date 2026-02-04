
#RPG GAME

#User starts in menu and is asked to select a character from: knight, wizard, musketeer

#User has 3 attributes: health,damage and healing 
#3 = highest attribute 1 = lowest attribute
#Index 1 is health, index 2 damage, index 3 healing
#Knight: 3,2,1 
#Musketeer: 1,3,2 
#Wizard: 2,1,3  
#Attributes are stored in .word arrays

#After user selects character and enters the game, a random enemy spawns from: goblin,  golem, witch
#3 = highest attribute 1 = lowest attribute
#Index 1 is health, index 2 damage, index 3 healing
#Goblin; 1,3,1
#Golem: 3,1,1
#Witch: 1,1,3

#After 5 fights, Slime boss appears
#Index 1 is health, index 2 damage, index 3 healing
#Slime: 3,3,3

#--------------------------------------------------------------------------------------------------------

#Variable map
# s0 = currentPlayer pointer 
# s1 = currentEnemy pointer
# s3 = round count variable
# s4 = battle counter



#--------------------------------------------------------------------------------------------------------

.data

#Character and enemy name strings

#Menu strings
menuStr1: .string "Castle Defence 2025\n"
menuStr2: .string "1 - Start Game\n"
menuStr3: .string "2 - Exit Game\n"


#--------------------------------------------------------------------------------------------------------

#Character and enemy strings
knightStr: .string "Knight"
musketeerStr: .string "Musketeer"
wizardStr: .string "Wizard"
goblinStr: .string "Goblin"
golemStr: .string "Golem"
witchStr: .string "Witch"
slimeStr: .string "Boss Slime"

#--------------------------------------------------------------------------------------------------------

#chooseCharacter strings
chooseBuildStr: .string "\nChoose your build\n\n"

#Choose Knight Strings
chooseKnightStr1: .string "1 - Knight\n"
chooseKnightStr2: .string "Attributes: Health Damage Healing\n"
chooseKnightStr3: .string "               3      2      1    \n\n"
#Choose Musketeer Strings
chooseMusketeerStr1: .string "2 - Musketeer\n"
chooseMusketeerStr2: .string "Attributes: Health Damage Healing\n"
chooseMusketeerStr3: .string "               1      3     2    \n\n"
#Choose Wizard Strings
chooseWizardStr1: .string "3 - Wizard\n"
chooseWizardStr2: .string "Attributes: Health Damage Healing\n"
chooseWizardStr3: .string "               2      1      3    \n\n"

#--------------------------------------------------------------------------------------------------------

#Take input string 
takeInput: .string "Please Select: "
#Invalid input string
invalInput: .string "Invalid input\n"
#new line
newLine: .string "\n"


#--------------------------------------------------------------------------------------------------------
#gameLoop strings

#first round strings
firstRoundStr1: .string "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nA "
firstRoundStr2: .string " HAS APPEARED\n\n"

#not first strings
notFirstStr1: .string "What will you do? \n\n"
notFirstStr2: .string "1 - Attack\n"
notFirstStr3: .string "2 - Heal\n\n"
notFirstStr4: .string "Health: "
#--------------------------------------------------------------------------------------------------------
#strings for player win/loss and end game win/loss

playerWinsStr: .string "You defeated the enemy "
playerLosesStr: .string "You were defeated by the enemy "

endWinStr: .string "Well done you won the game"
endLossStr: .string "Well done you lost the game"

#--------------------------------------------------------------------------------------------------------
#strings for enemy and player actions

#print user damage

userDmgStr1: .string "You dealt "
userDmgStr2: .string " amount of damage\n\n"
userDmgStr3: .string "Enemy "
userDmgStr4: .string " has "
userDmgStr5: .string " health left"

#prints user heal

userHealStr1: .string "You healed for "
userHealStr2: .string " amount of health\n\n"
userHealStr3: .string "Your total health is "

#prints enemy damage

enemyDmgStr1: .string "You were dealt "
enemyDmgStr2: .string " amount of damage by enemy\n"

#prints enemy heal 

enemyHealStr1: .string "Enemy "
enemyHealStr2: .string " healed for "
enemyHealStr3: .string " amount of healing\n"

#--------------------------------------------------------------------------------------------------------
.align 2 #tells RARS 4-byte boundary

#Format to allow easy and consistent data access across all arrays
#label : health, damage, healing, name pointer

#Character arrays
knight: .word 3, 2, 1, knightStr
musketeer: .word 1, 3, 2, musketeerStr
wizard: .word 2, 1, 3, wizardStr

#Enemy arrays
goblin: .word 1, 3, 1, goblinStr
golem: .word 3, 1, 1, golemStr
witch: .word 1, 1, 3, witchStr
slime: .word 3,3,1, slimeStr

#Current arrays
#16 bytes to hold 4 x 4-byte pieces of data
currentPlayer: .space 16
currentEnemy: .space 16

.text

#--------------------------------------------------------------------------------------------------------

main:

#load pointers to currentPlayer and currentEnemy to s0 and s1 respectively

la s0, currentPlayer
la s1, currentEnemy
li s3,0
li s4,0

#output menu strings and take input to system 

li a7,4

la a0,menuStr1
ecall
la a0,menuStr2
ecall
la a0,menuStr3
ecall
la a0,takeInput
ecall

#get user input 
li a7,5
ecall
mv t0,a0

#validate user input 

#if input 1 or 2 branch respectively 
li t1,1
beq t1,t0,chooseCharacter
li t1,2
beq t1,t0,exit

#else return to main
li a7,4
la a0,invalInput
ecall
b main

#--------------------------------------------------------------------------------------------------------

gameLoop:


endBattleCheck:

#get user health stat
lw t1,0(s0)
#get enemy health stat
lw t2,0(s1)

#branch to player win/loses respectively

blez t1,userLosesBattle
blez t2,userWinsBattle

#else
ret

battleLoop:


userTurn:


#check if first round 
firstRoundCheck:
bnez s3,notFirst

#only output these strings if it is the first round of the fight

firstRound:
#prints first round strings
jal ra, firstRoundPrint



notFirst:

#check if enemy or player health is zero
jal ra,endBattleCheck
#use print function to print strings
jal ra,notFirstPrint
#take user input and store in t0
li a7,5
ecall
#move user input to safe place
mv t0,a0
#move pointer to array addresses to a0 and a1 for use in apply damage and apply heal
mv a0,s0
mv a1,s1
#li 1 and 2 for checking user input for branching
li t1,1
li t2,2
#perform branch checks and branch to label otherwise loop
beq t0,t1,useApplyDmg
beq t0,t2,useApplyHeal
#print invalid input message and loop
li a7,4
la a0,invalInput
ecall
b userTurn


useApplyDmg:
#apply damage and print strings, then branch to enemy turn
jal ra applyDmg
jal ra printUserDmg
jal ra endBattleCheck 
b enemyTurn

useApplyHeal:
#apply heal and strings, then branch to enemy turn
jal ra applyHeal
jal ra printUserHeal
jal ra endBattleCheck
b enemyTurn

enemyTurn:
#get random number 0 or 1 and store in t0
li t2,2
jal ra getRandom
mv t0,a0
#move pointers for use in apply damage/heal
mv a0,s1
mv a1,s0
#load immediate 0 and 1 for apply damage/heal
li t1,0
li t2,1
beq t0,t1,enemyApplyDmg
beq t0,t2,enemyApplyHeal

enemyApplyDmg:
#print and apply damage
jal ra applyDmg
jal ra printEnemyDmg
jal ra endBattleCheck
#increment round count
addi s3,s3,1
#branch to end battle check
b userTurn
enemyApplyHeal:
jal ra applyHeal
jal ra printEnemyHeal
jal ra endBattleCheck
addi s3,s3,1
b userTurn

#--------------------------------------------------------------------------------------------------------


chooseCharacter:

#print character selection information
jal ra chooseCharacterStrings

#output take input string and then take input 
la a0, takeInput
li a7,4
ecall
li a7,5
ecall
#move user input for character selection to t0
mv t0,a0
#compare user input with value in t1 and branch appropriately
li t1,1
beq t1,t0,selectKnight
li t1,2
beq t1,t0,selectMusketeer
li t1,3 
beq t1,t0,selectWizard
#else output inval message and loop to chooseCharacter
li a7,4
la a0,invalInput
ecall
b chooseCharacter


#--------------------------------------------------------------------------------------------------------
#functions
#--------------------------------------------------------------------------------------------------------

#gameLoop print functions

firstRoundPrint:
#print first round strings
li a7,4
la a0,firstRoundStr1
ecall
#get name of enemy and print
lw a0,12(s1)
ecall

la a0,firstRoundStr2
ecall

ret

notFirstPrint:

#print notFirst strings
li a7,4
la a0,notFirstStr1
ecall
la a0,notFirstStr2
ecall
la a0,notFirstStr3
ecall
la a0,notFirstStr4
ecall

#load player health value 
li a7,1
lw a0,0(s0)
ecall

li a7,4
la a0,newLine
ecall

#print take input
li a7,4
la a0,newLine
ecall
la a0,takeInput
ecall

ret
#--------------------------------------------------------------------------------------------------------

#print functions for user and enemy damage/heal

#print user damage

printUserDmg:

li a7,4
la a0,newLine
ecall
#print "You dealt [damage] amount of damage"

la a0,userDmgStr1
ecall
#get player damage using offset 4
li a7,1
lw a0,4(s0)
ecall

li a7,4
la a0,userDmgStr2
ecall

#print "Enemy [enemy name] has [enemy health] health left"
la a0,userDmgStr3
ecall
#get enemy name pointer using offset 12
lw a0,12(s1)
ecall

la a0,userDmgStr4
ecall
#print enemy health value
li a7,1
lw a0,0(s1)
ecall

li a7,4
la a0,userDmgStr5
ecall

li a7,4
la a0,newLine
ecall


ret

#print user heal 

printUserHeal:

li a7,4
la a0,newLine
ecall

#print "You healed for [healing] amount of health"

li a7,4
la a0,userHealStr1
ecall
#get healing using offset 8
li a7,1
lw a0,8(s0)
ecall

li a7,4
la a0, userHealStr2
ecall

#print "Your total health is [health]"

la a0,userHealStr3
ecall
#get total health using offset 0
li a7,1
lw a0,0(s0)
ecall

li a7,4
la a0,newLine
ecall



ret 

#print enemy damage

printEnemyDmg:

li a7,4
la a0,newLine
ecall
#print "You were dealt [damage] amount of damage by enemy"
li a7,4
la a0,enemyDmgStr1
ecall

#get enemy damage stat using offset 4 of 
li a7,1
lw a0,4(s1)
ecall

li a7,4
la a0,enemyDmgStr2
ecall

li a7,4
la a0,newLine
ecall


ret

printEnemyHeal:

li a7,4
la a0,newLine
ecall
#print "Enemy [enemy name] healed for [healing] amount of healing"
li a7,4
la a0,enemyHealStr1
ecall

#get enemy name pointer using offset 12 
lw a0,12(s1)
ecall

la a0,enemyHealStr2
ecall

#get enemy healing stat using offset 8 
li a7,1
lw a0,8(s1)
ecall

li a7,4
la a0,enemyHealStr3
ecall

li a7,4
la a0,newLine
ecall


ret

userWinsBattle:

li a7,4
la a0,newLine
ecall
#print "You defeated the enemy [enemy name]"
li a7,4
la a0,playerWinsStr
ecall

#get enemy name pointer using offset 12 
lw a0,12(s1)
ecall

li a7,4
la a0,newLine
ecall

#reset round counter 
li s3,0
#increment battle counter
addi s4,s4,1
li t1,5 
#check if five battles have happened 
beq t1,s4,bossBattle
#check if six battles have happened
li t1,6
beq t1,s4,endGameWin

#else

li t2,3
jal ra getRandom
b spawnEnemy

userLosesBattle:
li a7,4
la a0,newLine
ecall

#print "You were defeated by the enemy [enemy name]"
li a7,4
la a0,playerLosesStr
ecall

#get enemy name pointer using offset 12 of 
lw a0,12(s1)
ecall

li a7,4
la a0,newLine
ecall

#exit program
b endGameLoss
#--------------------------------------------------------------------------------------------------------

#functions for boss battle and game win/loss

bossBattle:

la t1,slime
mv t6,s1
jal ra copyFromArray
b userTurn

endGameWin:

li a7,4
la a0,endWinStr
ecall
b exit

endGameLoss:
li a7,4 
la a0,endLossStr
ecall 
b exit

#--------------------------------------------------------------------------------------------------------
#functions to apply damage and healing

#attacker address/healer address = a0
#targer address for attack = a1

applyDmg:

#get attacker damage stat
lw t2,4(a0)
#get target health
lw t3,0(a1)
#subtract attack from health and update
sub t3,t3,t2
sw t3, 0(a1)

ret

applyHeal:

#get healing stat
lw t2,8(a0)
#get healers health
lw t3,0(a0)
#apply healing and update
add t3,t3,t2
sw t3,0(a0)
ret

#--------------------------------------------------------------------------------------------------------

#function to copy from one array to another

copyFromArray:

#t1 is pointer to selected character array
#t6 is array to be copied to

#load health multiplier
li t5,50
#copy health and save in currentXX array (s0)
lw t4,0(t1)
mul t4,t5,t4
sw t4,0(t6)

#load damage multiplier
li t5,20
#copy damage and save in currentXX array (s0)
lw t4,4(t1)
mul t4,t5,t4
sw t4,4(t6)

#load healing multiplier
li t5,20
#copy healing and save in currentXX array (s0)
lw t4,8(t1)
mul t4,t5,t4
sw t4,8(t6)

#copy name address and save in currentXX array (s0)
lw t4,12(t1)
sw t4,12(t6)

ret



#--------------------------------------------------------------------------------------------------------

#function to get random enemy spawn
getRandom:

#get a random number within the range 0 and t2
#t2 is upper range of random
li a7,42
li a0,0
mv a1,t2
ecall

ret

#--------------------------------------------------------------------------------------------------------

#check random number and branch appropriately
spawnEnemy:

mv t0,a0
li t1,0
beq t1,t0,selectGoblin
li t1,1
beq t1,t0,selectGolem
li t1,2
beq t1,t0,selectWitch

#else try again

b getRandom

#--------------------------------------------------------------------------------------------------------

#functions to load Character array pointers to t1 for copyFromArray 

selectKnight:
la t1,knight
mv t6,s0
jal ra copyFromArray
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

selectMusketeer:
la t1,musketeer
mv t6,s0
jal ra copyFromArray
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

selectWizard:
la t1,wizard
mv t6,s0
jal ra copyFromArray
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

#--------------------------------------------------------------------------------------------------------

#functions to load enemy array pointers to t1 for set copyFromArray

selectGoblin:
la t1,goblin
mv t6,s1
jal ra copyFromArray
b battleLoop

selectGolem:
la t1,golem
mv t6,s1
jal ra copyFromArray
b battleLoop

selectWitch:
la t1,witch
mv t6,s1
jal ra copyFromArray
b battleLoop

#--------------------------------------------------------------------------------------------------------
#function to print all strings for chooseCharacter without cluttering
chooseCharacterStrings:

#load print string syscall to a7
li a7,4
#load pointers to a0 and print
la a0,chooseBuildStr
ecall

la a0,chooseKnightStr1
ecall

la a0,chooseKnightStr2
ecall

la a0,chooseKnightStr3
ecall

la a0,chooseMusketeerStr1
ecall

la a0,chooseMusketeerStr2
ecall

la a0,chooseMusketeerStr3
ecall

la a0,chooseWizardStr1
ecall

la a0,chooseWizardStr2
ecall

la a0,chooseWizardStr3
ecall
#return to choose character
ret

#--------------------------------------------------------------------------------------------------------

#function to exit
exit:
li a7,10
ecall


5.4.5

#RPG GAME

#--------------------------------------------------------------------------------------------------------

#Variable map
# s0 = currentPlayer pointer 
# s1 = currentEnemy pointer
# s2 = XP varibable
# s3 = round count variable
# s4 = battle counter
# s5 = max XP variable 
# s6 = player level
# s7 = player max health
# s8 = currentEnemy max health
# s9 = dodge flag
# s10 = dodge cooldown




#--------------------------------------------------------------------------------------------------------

.data

#Character and enemy name strings

#Menu strings
menuStr1: .string "Castle Defence 2025\n"
menuStr2: .string "1 - Start Game\n"
menuStr3: .string "2 - Exit Game\n"


#--------------------------------------------------------------------------------------------------------

#Character and enemy strings
knightStr: .string "Knight"
musketeerStr: .string "Musketeer"
wizardStr: .string "Wizard"
goblinStr: .string "Goblin"
golemStr: .string "Golem"
witchStr: .string "Witch"
slimeStr: .string "Boss Slime"

#--------------------------------------------------------------------------------------------------------
#dodge strings

dodgeCooldownStr1: .string "Dodge is on cooldown for "
dodgeCooldownStr2: .string " rounds\n\n"

dodgeAttackStr: .string "You dodged the attack\n"
dodgeHealStr: .string "\nThe enemy did not attack, dodge ineffective"

#--------------------------------------------------------------------------------------------------------
#upgradeAttribute strings 

upgAttStr1: .string "\nYou have reached level "
upgAttStr2: .string "\n\nSelect an attribute to upgrade\n\n"
upgAttStr3: .string "1 - Health\n"
upgAttStr4: .string "2 - Damage\n"
upgAttStr5: .string "3 - Healing\n\n"


upgHealthStr: .string "Your max health is now: "
upgDmgStr1: .string "You now deal: "
upgDmgStr2: .string "damage"
upgHealStr: .string "Your healing stat is now: "

#--------------------------------------------------------------------------------------------------------
#chooseCharacter strings
chooseBuildStr: .string "\nChoose your build\n\n"

#Choose Knight Strings
chooseKnightStr1: .string "1 - Knight\n"
chooseKnightStr2: .string "Attributes: Health Damage Healing\n"
chooseKnightStr3: .string "               3      2      1    \n\n"
#Choose Musketeer Strings
chooseMusketeerStr1: .string "2 - Musketeer\n"
chooseMusketeerStr2: .string "Attributes: Health Damage Healing\n"
chooseMusketeerStr3: .string "               1      3     2    \n\n"
#Choose Wizard Strings
chooseWizardStr1: .string "3 - Wizard\n"
chooseWizardStr2: .string "Attributes: Health Damage Healing\n"
chooseWizardStr3: .string "               2      1      3    \n\n"

#--------------------------------------------------------------------------------------------------------

#Take input string 
takeInput: .string "Please Select: "
#Invalid input string
invalInput: .string "\nInput is not a valid number!\n"
#new line
newLine: .string "\n"
#input out of range string 
inputOOR: .string "Input is not an option!\n"
#press enter to continue
continueStr: .string "\nPress enter to continue "

#--------------------------------------------------------------------------------------------------------
#gameLoop strings

#first round strings
firstRoundStr1: .string "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nA "
firstRoundStr2: .string " HAS APPEARED!\n\n"

#not first strings
notFirstStr1: .string "What will you do? \n\n"
notFirstStr2: .string "1 - Attack\n"
notFirstStr3: .string "2 - Heal\n"
notFirstStr4: .string "Your Health: "
notFirstStr5: .string "3 - Dodge\n\n"
notFirstStr6: .string "\nYour Level: "
#--------------------------------------------------------------------------------------------------------
#strings for player win/loss and end game win/loss

playerWinsStr: .string "You defeated the enemy "
playerLosesStr: .string "You were defeated by enemy "

endWinStr: .string "\nYou mighty soldier\n\nYou beat the game!"
endLossStr: .string "\nUnlucky brave soldier\n\nYou were defeated"

#--------------------------------------------------------------------------------------------------------
#strings for enemy and player actions

#print user damage

userDmgStr1: .string "You dealt "
userDmgStr2: .string " amount of damage\n\n"
userDmgStr3: .string "Enemy "
userDmgStr4: .string " has "
userDmgStr5: .string " health remaining"

#prints user heal

userHealStr1: .string "You healed for "
userHealStr2: .string " health\n\n"
userHealStr3: .string "Your total health is "

#prints enemy damage

enemyDmgStr1: .string "You were dealt "
enemyDmgStr2: .string " amount of damage by enemy\n"

#prints enemy heal 

enemyHealStr1: .string "\nEnemy "
enemyHealStr2: .string " healed for "
enemyHealStr3: .string " amount of healing\n"

#--------------------------------------------------------------------------------------------------------
.align 2 #tells RARS 4-byte boundary

#Format to allow easy and consistent data access across all arrays
#label : health, damage, healing, name pointer

#Character arrays
knight: .word 3, 2, 1, knightStr
musketeer: .word 1, 3, 2, musketeerStr
wizard: .word 2, 1, 3, wizardStr

#Enemy arrays
goblin: .word 1, 3, 1, goblinStr
golem: .word 3, 1, 1, golemStr
witch: .word 1, 1, 3, witchStr
slime: .word 4, 1, 2, slimeStr

#Current arrays
#16 bytes to hold 4 x 4-byte pieces of data
currentPlayer: .space 16
currentEnemy: .space 16
#for input validation
inputBuffer: .space 4
continueBuffer: .space 4
.text

#--------------------------------------------------------------------------------------------------------

main:

#load pointers to currentPlayer and currentEnemy to s0 and s1 respectively

la s0, currentPlayer
la s1, currentEnemy
li s2,0
li s3,0
li s4,0
#load max xp value 
li s5,2

#output menu strings and take input to system 
mainLoop:
li a7,4

la a0,menuStr1
ecall
la a0,menuStr2
ecall
la a0,menuStr3
ecall


#get user input 
jal ra takeInputConversion
mv t0,a0

#validate user input 

#if input 1 or 2 branch respectively 
li t1,1
beq t1,t0,chooseCharacter
li t1,2
beq t1,t0,exit

#else return to main
li a7,4
la a0,inputOOR
ecall
b mainLoop

#--------------------------------------------------------------------------------------------------------

gameLoop:


endBattleCheck:

#get user health stat
lw t1,0(s0)
#get enemy health stat
lw t2,0(s1)

#branch to player win/loses respectively

blez t1,userLosesBattle
blez t2,userWinsBattle

#else
ret

battleLoop:


userTurn:


#check if first round 
firstRoundCheck:
bnez s3,notFirst

#only output these strings if it is the first round of the fight

firstRound:
#prints first round strings
jal ra, firstRoundPrint



notFirst:

#check if enemy or player health is zero
jal ra,endBattleCheck
#use print function to print strings
jal ra,notFirstPrint
#take user input and store in t0
jal ra takeInputConversion
#move user input to safe place
mv t0,a0
#move pointer to array addresses to a0 and a1 for use in apply damage and apply heal
mv a0,s0
mv a1,s1
mv t4,s7
#li 1 and 2 for checking user input for branching
li t1,1
li t2,2
li t3,3
#perform branch checks and branch to label otherwise loop
beq t0,t1,useApplyDmg
beq t0,t2,useApplyHeal
beq t0,t3,useDodge
#print invalid input message and loop
li a7,4
la a0,inputOOR
ecall
b userTurn


useApplyDmg:
#apply damage and print strings, then branch to enemy turn
jal ra applyDmg
jal ra printUserDmg
#press any to continue
li a7,4 
la a0,continueStr
ecall
la a0,continueBuffer
li a7,8
ecall

jal ra endBattleCheck 
b enemyTurn

useApplyHeal:
#apply heal and strings, then branch to enemy turn
jal ra applyHeal
jal ra printUserHeal
#press any to continue
li a7,4 
la a0,continueStr
ecall
la a0,continueBuffer
li a7,8
ecall

jal ra endBattleCheck
b enemyTurn

useDodge:
#if cooldown is active, no dodge
bgtz s10,noDodge
#set dodge flag to 1 
li s9,1
#set cooldown to 3
li s10,3
b enemyTurn

noDodge:
#print strings to tell user dodge cooldown info
li a7,4
la a0,dodgeCooldownStr1
ecall 

li a7,1
mv a0,s10
ecall

li a7,4
la a0,dodgeCooldownStr2
ecall

#press any to continue
li a7,4 
la a0,continueStr
ecall
la a0,continueBuffer
li a7,8
ecall

b notFirst

enemyTurn:
#get random number 0 or 1 and store in t0
li t2,2
jal ra getRandom
mv t0,a0
#move pointers for use in apply damage/heal
mv a1,s0
mv t4,s8
#load immediate 0 and 1 for apply damage/heal
li t1,0
li t2,1
beq t0,t1,enemyApplyDmg
beq t0,t2,enemyApplyHeal

enemyApplyDmg:
#check for dodge
beq s9,zero,takeDmg
li s9,0
#print dodged attack string
li a7,4
la a0,dodgeAttackStr
ecall
b skipDmg
#print and apply damage
takeDmg:
mv a0,s1
jal ra applyDmg
jal ra printEnemyDmg
skipDmg:
#press any to continue
li a7,4 
la a0,continueStr
ecall
la a0,continueBuffer
li a7,8
ecall
jal ra endBattleCheck
#increment round count
addi s3,s3,1
#deal with dodge cooldown
jal ra updateCooldown
b userTurn


enemyApplyHeal:
#check for dodge
beq s9,zero, skipDodgeHeal
#print dodge failed string
li a7,4
la a0,dodgeHealStr
ecall
li s9,0
skipDodgeHeal:
mv a0,s1
jal ra applyHeal
jal ra printEnemyHeal
#press any to continue
li a7,4 
la a0,continueStr
ecall
la a0,continueBuffer
li a7,8
ecall
jal ra endBattleCheck
addi s3,s3,1
#deal with dodge cooldown
jal ra updateCooldown
b userTurn



#--------------------------------------------------------------------------------------------------------


chooseCharacter:

#print character selection information
jal ra chooseCharacterStrings

#output take input string and then take input 
jal ra takeInputConversion
#move user input for character selection to t0
mv t0,a0
#compare user input with value in t1 and branch appropriately
li t1,1
beq t1,t0,selectKnight
li t1,2
beq t1,t0,selectMusketeer
li t1,3 
beq t1,t0,selectWizard
#else output inval message and loop to chooseCharacter
li a7,4
la a0,inputOOR
ecall
b chooseCharacter


#--------------------------------------------------------------------------------------------------------
#functions
#--------------------------------------------------------------------------------------------------------

#gameLoop print functions

firstRoundPrint:
#print first round strings
li a7,4
la a0,firstRoundStr1
ecall
#get name of enemy and print
lw a0,12(s1)
ecall

la a0,firstRoundStr2
ecall

ret

notFirstPrint:

#print notFirst strings
li a7,4
la a0,notFirstStr1
ecall
la a0,notFirstStr2
ecall
la a0,notFirstStr3
ecall
la a0,notFirstStr5
ecall
la a0,notFirstStr4
ecall

#load player health value 
li a7,1
lw a0,0(s0)
ecall

li a7,4
la a0,notFirstStr6
ecall
#display player level
li a7,1
mv a0,s6
ecall

li a7,4
la a0,newLine
ecall

#print take input
li a7,4
la a0,newLine
ecall

ret
#--------------------------------------------------------------------------------------------------------

#print functions for user and enemy damage/heal

#print user damage

printUserDmg:

li a7,4
la a0,newLine
ecall
#print "You dealt [damage] amount of damage"

la a0,userDmgStr1
ecall
#get player damage using offset 4
li a7,1
lw a0,4(s0)
ecall

li a7,4
la a0,userDmgStr2
ecall

#print "Enemy [enemy name] has [enemy health] health left"
la a0,userDmgStr3
ecall
#get enemy name pointer using offset 12
lw a0,12(s1)
ecall

la a0,userDmgStr4
ecall
#print enemy health value
li a7,1
lw a0,0(s1)
ecall

li a7,4
la a0,userDmgStr5
ecall

li a7,4
la a0,newLine
ecall


ret

#print user heal 

printUserHeal:

li a7,4
la a0,newLine
ecall

#print "You healed for [healing] amount of health"

li a7,4
la a0,userHealStr1
ecall
#get healing using offset 8
li a7,1
lw a0,8(s0)
ecall

li a7,4
la a0, userHealStr2
ecall

#print "Your total health is [health]"

la a0,userHealStr3
ecall
#get total health using offset 0
li a7,1
lw a0,0(s0)
ecall

li a7,4
la a0,newLine
ecall



ret 

#print enemy damage

printEnemyDmg:

li a7,4
la a0,newLine
ecall
#print "You were dealt [damage] amount of damage by enemy"
li a7,4
la a0,enemyDmgStr1
ecall

#get enemy damage stat using offset 4 of 
li a7,1
lw a0,4(s1)
ecall

li a7,4
la a0,enemyDmgStr2
ecall

li a7,4
la a0,newLine
ecall


ret

printEnemyHeal:

li a7,4
la a0,newLine
ecall
#print "Enemy [enemy name] healed for [healing] amount of healing"
li a7,4
la a0,enemyHealStr1
ecall

#get enemy name pointer using offset 12 
lw a0,12(s1)
ecall

la a0,enemyHealStr2
ecall

#get enemy healing stat using offset 8 
li a7,1
lw a0,8(s1)
ecall

li a7,4
la a0,enemyHealStr3
ecall

li a7,4
la a0,newLine
ecall


ret

#--------------------------------------------------------------------------------------------------------

userWinsBattle:

#battle win strings 
li a7,4
la a0,newLine
ecall
#print "You defeated the enemy [enemy name]"
li a7,4
la a0,playerWinsStr
ecall

#get enemy name pointer using offset 12 
lw a0,12(s1)
ecall

li a7,4
la a0,newLine
ecall

#reset round counter 
li s3,0
#increment battle counter
addi s4,s4,1


#DEAL WITH XP
#add 2xp
addi s2,s2,2
#if player xp is greater than or equal or equal to max XP
bge s2,s5,upgradeAttribute

#label to return to after upgrade attribute
afterUpgrade:
#BOSS CHECKS
#check if five battles have happened 
li t1,5 
beq t1,s4,bossBattle
#check if six battles have happened
li t1,6
beq t1,s4,endGameWin

#else

li t2,3
jal ra getRandom
b spawnEnemy



userLosesBattle:
li a7,4
la a0,newLine
ecall

#print "You were defeated by the enemy [enemy name]"
li a7,4
la a0,playerLosesStr
ecall

#get enemy name pointer using offset 12 of 
lw a0,12(s1)
ecall

li a7,4
la a0,newLine
ecall

#exit program
b endGameLoss
#--------------------------------------------------------------------------------------------------------

#functions for boss battle and game win/loss

bossBattle:

la t1,slime
mv t6,s1
jal ra copyFromArray
b userTurn

endGameWin:

li a7,4
la a0,endWinStr
ecall
b exit

endGameLoss:
li a7,4 
la a0,endLossStr
ecall 
b exit

#--------------------------------------------------------------------------------------------------------
#functions to apply damage and healing

#attacker address/healer address = a0
#targer address for attack = a1

applyDmg:

#get attacker damage stat
lw t2,4(a0)
#get target health
lw t3,0(a1)
#subtract attack from health and update
sub t3,t3,t2
#deal with resulting health less than zero
li t6,0
#if 0 is less than health, continue
blt t6,t3,continueDmg
#set t3 to zero if health is below zero
li t3,0
continueDmg:
sw t3,0(a1)
ret



applyHeal:
#t4 is max healing stat

#get healing stat
lw t2,8(a0)
#get healers health
lw t3,0(a0)
#apply healing and update
add t3,t3,t2
#check if healing is greater than max health 
blt t3,t4,continueHeal
mv t3,t4

continueHeal:
sw t3,0(a0)
ret

#--------------------------------------------------------------------------------------------------------

#function to copy from one array to another

copyFromArray:

#t1 is pointer to selected character array
#t6 is array to be copied to

#load health multiplier
li t5,10
#copy health and save in currentXX array (s0)
lw t4,0(t1)
mul t4,t5,t4
#add base stat
addi t4,t4,100
sw t4,0(t6)

#load damage multiplier
li t5,4
#copy damage and save in currentXX array (s0)
lw t4,4(t1)
mul t4,t5,t4
#add base stat
addi t4,t4,40
sw t4,4(t6)

#load healing multiplier
li t5,6
#copy healing and save in currentXX array (s0)
lw t4,8(t1)
mul t4,t5,t4
#add base stat
addi t4,t4,20
sw t4,8(t6)

#copy name address and save in currentXX array (s0)
lw t4,12(t1)
sw t4,12(t6)

ret



#--------------------------------------------------------------------------------------------------------

#function to get random enemy spawn
getRandom:

#get a random number within the range 0 and t2
#t2 is upper range of random
li a7,42
li a0,0
mv a1,t2
ecall

ret

#--------------------------------------------------------------------------------------------------------

#check random number and branch appropriately
spawnEnemy:

mv t0,a0
li t1,0
beq t1,t0,selectGoblin
li t1,1
beq t1,t0,selectGolem
li t1,2
beq t1,t0,selectWitch

#else try again

b getRandom

#--------------------------------------------------------------------------------------------------------

#functions to load Character array pointers to t1 for copyFromArray 

selectKnight:
la t1,knight
mv t6,s0
jal ra copyFromArray
#save max health 
lw s7, 0(s0)
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

selectMusketeer:
la t1,musketeer
mv t6,s0
jal ra copyFromArray
#save max health 
lw s7, 0(s0)
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

selectWizard:
la t1,wizard
mv t6,s0
jal ra copyFromArray
#save max health 
lw s7, 0(s0)
#branch to getEnemySpawnID for enemy spawning
li t2,3
jal ra getRandom
b spawnEnemy

#--------------------------------------------------------------------------------------------------------

#functions to load enemy array pointers to t1 for set copyFromArray

selectGoblin:
la t1,goblin
mv t6,s1
jal ra copyFromArray
lw s8, 0(s1)
b battleLoop

selectGolem:
la t1,golem
mv t6,s1
jal ra copyFromArray
lw s8, 0(s1)
b battleLoop

selectWitch:
la t1,witch
mv t6,s1
jal ra copyFromArray
lw s8, 0(s1)
b battleLoop

#--------------------------------------------------------------------------------------------------------
#function to print all strings for chooseCharacter without cluttering
chooseCharacterStrings:

#load print string syscall to a7
li a7,4
#load pointers to a0 and print
la a0,chooseBuildStr
ecall

la a0,chooseKnightStr1
ecall

la a0,chooseKnightStr2
ecall

la a0,chooseKnightStr3
ecall

la a0,chooseMusketeerStr1
ecall

la a0,chooseMusketeerStr2
ecall

la a0,chooseMusketeerStr3
ecall

la a0,chooseWizardStr1
ecall

la a0,chooseWizardStr2
ecall

la a0,chooseWizardStr3
ecall
#return to choose character
ret

#--------------------------------------------------------------------------------------------------------
upgradeAttribute:

#add 1 to player level variable
addi s6,s6,1
#multiply max xp by 2
li t0,2
mul s5,s5,t0
#set xp to zero
mv s2,zero

#ask user what attribute they want to upgrade and branch 

li a7,4

la a0,upgAttStr1
ecall

li a7,1 
mv a0,s6
ecall

li a7,4

la a0,upgAttStr2
ecall

la a0,upgAttStr3
ecall

la a0,upgAttStr4
ecall

la a0,upgAttStr5
ecall

jal ra takeInputConversion
#move user input to t0
mv t0,a0
#check input and branch appropriately
li t1,1
beq t1,t0,upgHealth
li t1,2
beq t1,t0,upgDmg
li t1,3
beq t1,t0,upgHeal

#else
li a7,4 
la a0,inputOOR
ecall
b upgradeAttribute

upgHealth:

#get player max health and add 10
addi s7,s7,10
#heal player to full
sw s7,0(s0)
#print info to user 
li a7,4
la a0,upgHealthStr
ecall

li a7,1
mv a0,s7
ecall

b afterUpgrade

upgDmg:
#get player damage and add 4
lw t3,4(s0)
addi t3,t3,4
#save in currentPlayer array
sw t3,4(s0)

#print info to user
li a7,4
la a0,upgDmgStr1
ecall

li a7,1
lw a0,4(s0)
ecall

li a7,4
la a0,upgDmgStr2

b afterUpgrade

upgHeal:
#get player healing and add 6
lw t3,8(s0)
addi t3,t3,6
#save in currentPlayer array
sw t3,8(s0)
#print info to user
li a7,4
la a0,upgHealStr
ecall

li a7,1
lw a0,8(s0)
ecall

b afterUpgrade

#--------------------------------------------------------------------------------------------------------

#deal with dodge cooldown
updateCooldown:
ble s10,zero,updateCooldownDone
addi s10,s10,-1
updateCooldownDone:
ret
#--------------------------------------------------------------------------------------------------------

invalidInput:
#print invalid input string 
li a7,4
la a0,invalInput 
ecall
#take input and convert
takeInputConversion:
#print please select string
li a7,4
la a0,takeInput
ecall
#take input as string
la a0, inputBuffer
li a1,4
li a7,8
ecall
#load the first byte from inputBuffer to t0
la t0,inputBuffer
lbu t0,0(t0)
#subtract 0x30 (48) from a0
addi t0,t0,-48
#check if input is valid
li t1,9
bgt t0,t1,invalidInput
li t1,0
blt t0,t1,invalidInput
#move t0 to a0 and return
mv a0,t0
ret

#--------------------------------------------------------------------------------------------------------
#function to exit
exit:
li a7,10
ecall
