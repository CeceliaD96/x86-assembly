; Computer Architecture Project 1
; Cecelia Dahlinger
; String Project
; Prompt the user to enter a string then prompt them to pick a provided function
; Allow the user to continue to choose functions until Function 0 or exit function is chosen

	.MODEL	SMALL
	.586
	.STACK	100h
	.DATA
String_Prompt		DB	13,10,'Please enter a string: $'
Function_Prompt		DB	13,10, 'Pick a function: $'
Menu				DB	13,10,'Function 1: Determine the first occurrence of a character.',13,10,
						'Function 2: Determine the number of occurrences of a character.',13,10,
						'Function 3: Determine the length of the string.',13,10,
						'Function 4: Determine the number of alphanumeric characters.',13,10,
						'Function 5: Replace each occurance of a char with another.',13,10,
						'Function 6: Make each letter uppercase.',13,10,'$'
Menu2				DB	'Function 7: Make each letter lowercase.',13,10,
						'Function 8: Toggle case of each letter.',13,10,
						'Function 9: Input new string.',13,10,
						'Function 10: Undo last action.',13,10,
						'Function 100: Output Menu',13,10,
						'Function 0: Exit Program',13,10,'$'
Function_Choice		DW	?						
Function1_Prompt	DB	13,10,'Enter the character which to find: $'
Function2_Prompt	DB	13,10,'Enter the character which to find the number of occurances: $'
Function5_Prompt1	DB	13,10,'Enter the character to be replaced: $'
Function5_Prompt2	DB	13,10,'Enter the character which to replace it with: $'
Function1_Message1	DB	13, 10,'The first $'
Function1_Message2	DB	' occurs in position $'
Function1_Message3	DB	' in the string: $'
Function1_Error		DB 	13, 10, 'This character is not in the String.$'
Function2_Message1	DB	13, 10, 'The character $'
Function2_Message2	DB	' occurs $'
Function2_Message3	DB	' times in the string: $'
Function3_Message1	DB	13, 10, 'There are $'
Function3_Message2	DB	' characters in the string: $'
Function4_Message1	DB	13, 10, 'There are $'
Function4_Message2	DB	' alphanumeric characters in the string: $'
Function5_Message1	DB	13, 10, 'Replacing all the $'
Function5_Message2	DB	' characters in the string: ',13,10,'$' 
Function5_Message3	DB	13,10, 'With $'
Function5_Message4	DB	' yields: ',13,10,'$'
Function6_Message1	DB	13, 10, 'Making each letter uppercase in the string: ',13,10,'$'
Function6_Message2	DB	13,10,'Yields: ',13,10,'$'
Function7_Message1	DB	13, 10, 'Making each letter lowercase in the string: ',13,10,'$'
Function7_Message2	DB	13,10,'Yields: ',13,10,'$'
Function8_Message1	DB	13, 10, 'Toggling each letter in the string: ',13,10,'$'
Function8_Message2	DB	13,10,'Yields: ',13,10,'$'
LastStringEndPos	DW	0
PastStrings			DB	2FEh dup('$')
CurrentString		DB	33h dup('$')
Function1_char		DB	?
Function1_Result	DW	?
Function2_char		DB	?
Function2_Result	DW	?
Function3_Result	DW	?
Function4_Result	DW	?
Function5_char1		DB	?
Function5_char2		DB	?
InvalidChoice		DB	'That is an invalid function choice. Please try again.',13,10,'$'
Function10_message	DB	'The current string is now: ',13,10,'$'
Function0output		DB	'End Program', 13, 10, '$'
	.CODE
	EXTRN getdec: near, putdec: near
;Main Procedure
	Main PROC
			mov	ax, @DATA
			mov	ds, ax
			
GetString:	mov dx, OFFSET String_Prompt
			mov ah, 09h
			int 21h
			
			mov cx, 32h
			
			mov bx, OFFSET CurrentString
			
StringLoop:	mov ah, 01h
			int 21h
			;check al for alphanumeric/punctuation, if not the jmp loopdone
			cmp al, 20h
			jl LoopDone
			cmp al, 7Eh
			jg LoopDone
			
			mov  [bx], al
			inc bx
			dec cx
			jcxz LoopDone
			jmp StringLoop
			
LoopDone:	

			mov dx, OFFSET Menu
			mov ah, 09h
			int 21h
			mov dx, OFFSET Menu2
			mov ah, 09h
			int 21h
Prompt:		mov dx, OFFSET Function_Prompt
			mov ah, 09h
			int 21h
			
			call getdec
			mov Function_Choice, ax
			
			cmp Function_Choice, 1h
			jne tryFunction2
			call Function1
			jmp DoneWithFunction
			
tryFunction2:cmp Function_Choice, 2h
			jne tryFunction3
			call Function2
			jmp DoneWithFunction
			
tryFunction3:cmp Function_Choice, 3h
			jne tryFunction4
			call Function3
			jmp DoneWithFunction
			
tryFunction4:cmp Function_Choice, 4h
			jne tryFunction5
			call Function4
			jmp DoneWithFunction
			
tryFunction5:cmp Function_Choice, 5h
			jne tryFunction6
			call Function5
			jmp DoneWithFunction
			
tryFunction6:cmp Function_Choice, 6h
			jne tryFunction7
			call Function6
			jmp DoneWithFunction
			
tryFunction7:cmp Function_Choice, 7h
			jne tryFunction8
			call Function7
			jmp DoneWithFunction
			
tryFunction8:cmp Function_Choice, 8h
			jne tryFunction9
			call Function8
			jmp DoneWithFunction
			
tryFunction9:cmp Function_Choice, 9h
			jne tryFunction10
			call Function9
			jmp DoneWithFunction
			
tryFunction10:cmp Function_Choice, 0Ah
			jne tryFunction100
			call Function10
			jmp DoneWithFunction
			
tryFunction100:cmp Function_Choice, 64h
			jne tryFunction0
			call Function100
			jmp DoneWithFunction
			
tryFunction0:cmp Function_Choice, 0h
			jne InvalidOption
			call Function0
			jmp DoneWithFunction
			
InvalidOption:mov dx, OFFSET InvalidChoice
			mov ah, 09h
			int 21h
			jmp Prompt
			
DoneWithFunction:
			
			jmp Prompt
	Main ENDP
	
	Function1 PROC
			mov dx, OFFSET Function1_Prompt
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			
			mov Function1_char, al
			mov bx, OFFSET CurrentString
			xor cx, cx
			
StartLoop1:	mov ah, [bx]
			inc cx
			cmp ah, al
			
			je EndLoop1
			inc bx
			
			cmp cx, 32h
			
			jge NotInString
			jmp StartLoop1
			
EndLoop1:	
			mov ah, 09h
			mov dx, OFFSET Function1_Message1
			int 21h
			
			mov dl, Function1_char
			mov ah, 02h
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET Function1_Message2
			int 21h
			
			mov ax,cx
			call putdec
			
			mov ah, 09h
			mov dx, OFFSET Function1_Message3
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			jmp F1Done

NotInString:	
			mov dx, OFFSET Function1_Error
			mov ah, 09h
			int 21h
F1Done:		ret
	Function1 ENDP

	Function2 PROC
			mov dx, OFFSET Function2_Prompt
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			
			mov Function2_char, al
			mov bx, OFFSET CurrentString
			mov cx, 32h
			
StartLoop2:	mov ah, [bx]
			cmp ah, al
			
			je addtotot
			dec cx
			jcxz EndLoop2
			jmp StartLoop2
AddToTot:	inc Function2_Result
			dec cx
			jcxz EndLoop2
			jmp StartLoop2
EndLoop2:	mov ah, 09h
			mov dx, OFFSET Function2_Message1
			int 21h
			
			mov dl, Function2_char
			mov ah, 02h
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET Function2_Message2
			int 21h
			
			mov ax, Function2_Result
			call putdec
			
			mov ah, 09h
			mov dx, OFFSET Function2_Message3
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function2 ENDP

	Function3 PROC
			mov bx, OFFSET CurrentString
			xor cx, cx
StartLoop3:	mov ah, [bx]
			cmp ah, '$'
			je Done3
			inc bx
			inc cx
			jmp StartLoop3
			
Done3:		
			mov Function3_Result, cx
			
			mov ah, 09h
			mov dx, OFFSET Function3_Message1
			int 21h
			
			mov ax, Function3_Result
			call putdec
			
			mov ah, 09h
			mov dx, OFFSET Function3_Message2
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function3 ENDP

	Function4 PROC
			mov Function4_Result, 0
			mov bx, OFFSET CurrentString
			mov cx, 32h
cmp1:		dec cx
			mov ah, [bx]
			cmp ah, '0'
			jge cmp2
			jcxz done4
			jmp cmp1
cmp2:		cmp ah, '9'
			jle IncTot
			jmp cmp3
cmp3:		cmp ah, 'A'
			jge cmp4
			jcxz done4
			jmp cmp1
cmp4:		cmp ah, 'Z'
			jle IncTot
			jmp cmp5
cmp5:		cmp ah, 'a'
			jge cmp6
			jcxz done4
			jmp cmp1
cmp6:		cmp ah, 'z'
			jle IncTot
			jcxz done4	
			jmp cmp1
			
IncTot:		inc Function4_Result
			inc bx
			jmp cmp1
			

done4:		mov ah, 09h
			mov dx, OFFSET Function4_Message1
			int 21h
			
			mov ax, Function4_Result
			call putdec
			
			mov ah, 09h
			mov dx, OFFSET Function4_Message2
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function4 ENDP

	Function5 PROC
			mov dx, OFFSET Function5_Prompt1
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			
			mov Function5_char1, al
			
			mov dx, OFFSET Function5_Prompt2
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			
			mov Function5_char2, al
			
			mov ah, 09h
			mov dx, OFFSET Function5_Message1
			int 21h
			
			mov dl, Function5_char1
			mov ah, 02h
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET Function5_Message2
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h	
						
			mov ah, 09h
			mov dx, OFFSET Function5_Message3
			int 21h
			
			mov dl, Function5_char2
			mov ah, 02h
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET Function5_Message4
			int 21h
			
			mov Function5_char2, al
			mov bx, OFFSET CurrentString
			mov	ah, Function5_char2
			mov al, Function5_char1
			
			mov cx, 32h
StartLoop5:	mov dl, [bx]
			cmp dl, al
			je ReplaceChar
			dec cx
			inc bx
			
			jcxz done5
			jmp StartLoop5
			
ReplaceChar:mov [bx], ah
			inc bx
			dec cx
			jcxz done5
			jmp StartLoop5
			
done5:		mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h			
			ret
	Function5 ENDP

	Function6 PROC
			mov ah, 09h
			mov dx, OFFSET Function6_Message1
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h	
						
			mov ah, 09h
			mov dx, OFFSET Function6_Message2
			int 21h

			mov bx, OFFSET CurrentString
StartLoop6:	mov ah, [bx]
			cmp ah, '$'
			je done6
			cmp ah, 'a'
			jge continue
			inc bx 
			jmp StartLoop6
continue:	cmp ah, 'z'
			jle continue2
			inc bx
			jmp StartLoop6
continue2:	XOR ah, 20h
			mov [bx], ah
			inc bx
			jmp StartLoop6

done6:		mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function6 ENDP

	Function7 PROC
			mov ah, 09h
			mov dx, OFFSET Function7_Message1
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h	
						
			mov ah, 09h
			mov dx, OFFSET Function7_Message2
			int 21h

			mov bx, OFFSET CurrentString
			
StartLoop7:	mov ah, [bx]
			cmp ah, '$'
			je done7
			cmp ah, 'A'
			jge continue3
			inc bx 
			jmp StartLoop7
continue3:	cmp ah, 'Z'
			jle continue4
			inc bx
			jmp StartLoop7
continue4:	XOR ah, 20h
			mov [bx], ah
			inc bx
			jmp StartLoop7

done7:		mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function7 ENDP

	Function8 PROC
			mov ah, 09h
			mov dx, OFFSET Function8_Message1
			int 21h
			
			mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h	
						
			mov ah, 09h
			mov dx, OFFSET Function8_Message2
			int 21h

			mov bx, OFFSET CurrentString
			
StartLoop8:	mov ah, [bx]
			cmp ah, '$'
			je done8
			cmp ah, 'A'
			jge compare1
			inc bx 
			jmp StartLoop8
compare1:	cmp ah, 'Z'
			jle Toggle
			jmp compare2
compare2:	cmp ah, 'a'
			jge compare3
			inc bx
			jmp StartLoop8
compare3:	cmp ah, 'z'
			jle Toggle
			inc bx
			jmp StartLoop8
Toggle:		XOR ah, 20h
			mov [bx], ah
			inc bx
			jmp StartLoop8

done8:		mov ah, 09h
			mov dx, OFFSET CurrentString
			int 21h
			ret
	Function8 ENDP

	Function9 PROC
			mov bx, OFFSET CurrentString
			mov cx, 32h
			
ClearLoop:	mov [bx], '$' 
			dec cx
			jcxz GetNew
			jmp ClearLoop
			
GetNew:		jmp GetString
		ret
	Function9 ENDP

	Function10 PROC

			
			ret
	Function10 ENDP

	Function100 PROC
			mov dx, OFFSET Menu
			mov ah, 09h
			int 21h
			mov dx, OFFSET Menu2
			mov ah, 09h
			int 21h
			ret
	Function100 ENDP

	Function0 PROC
			mov ah, 09h
			mov dx, OFFSET Function0output
			int 21h
			mov ah, 4Ch
			int 21h
			ret
	Function0 ENDP
	
END Main					