.section .data
message:
	.ascii ": "
command:
	.space 255
.section .text
	.globl _start
end:
	mov $60, %rax
	mov $0, %rdi
	syscall
find_n:
	lea command, %rdi
strip_n:
	cmpb $10, (%rdi)
	je replace_n
	inc %rdi
	jmp strip_n
replace_n:
	movb $0, (%rdi)
	ret
child:
	mov $59, %rax
	lea command, %rdi
	xor %rsi, %rsi
	xor %rdx, %rdx
	syscall
	
	mov $60, %rax
	mov $0, %rdi
	syscall
loop:
	mov $1, %rax
	lea message, %rsi
	mov $1, %rdi 
	mov $2, %rdx
	syscall

	mov $0, %rax
	mov $0, %rdi
	lea command, %rsi
	mov $255, %rdx
	syscall

	call find_n	

	mov $57, %rax
	syscall
	test %rax, %rax
	jz child
	jmp loop
	ret
_start:
	call loop
	mov $60, %rax
	mov $0, %rdi
	syscall
