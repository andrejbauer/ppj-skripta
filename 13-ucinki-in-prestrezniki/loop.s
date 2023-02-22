	.file ""
	.section __TEXT,__literal16,16byte_literals
	.align	4
_caml_negf_mask:
	.quad	0x8000000000000000
	.quad	0
	.align	4
_caml_absf_mask:
	.quad	0x7fffffffffffffff
	.quad	-1
	.data
	.globl	_camlLoop__data_begin
_camlLoop__data_begin:
	.text
	.globl	_camlLoop__code_begin
_camlLoop__code_begin:
	nop
	.data
	.quad	1792
	.globl	_camlLoop
_camlLoop:
	.quad	1
	.data
	.globl	_camlLoop__gc_roots
_camlLoop__gc_roots:
	.quad	_camlLoop
	.quad	0
	.text
	.align	4
	.globl	_camlLoop__loop_1002
_camlLoop__loop_1002:
	.cfi_startproc
L102:
	cmpq	$1, %rbx
	je	L101
	movq	%rbx, %rdi
	addq	$-2, %rdi
	leaq	-1(%rbx,%rax), %rax
	movq	%rdi, %rbx
	jmp	L102
	.align	2
L101:
	ret
	.cfi_endproc
	.text
	.align	4
	.globl	_camlLoop__fun_1011
_camlLoop__fun_1011:
	.cfi_startproc
L104:
	movq	%rax, %rdi
	movq	16(%rbx), %rax
	movq	%rdi, %rbx
	jmp	_camlLoop__loop_1002
	.cfi_endproc
	.data
	.quad	4087
_camlLoop__1:
	.quad	_caml_curry2
	.quad	5
	.quad	_camlLoop__loop_1002
	.text
	.align	4
	.globl	_camlLoop__entry
_camlLoop__entry:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
L105:
	movq	_camlLoop__1@GOTPCREL(%rip), %rax
	movq	_camlLoop@GOTPCREL(%rip), %rbx
	movq	%rax, (%rbx)
	movq	$201, %rdi
	movq	(%rbx), %rbx
	movq	$40, %rax
	call	_caml_allocN
L106:
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	_camlLoop__fun_1011@GOTPCREL(%rip), %rsi
	movq	%rsi, (%rax)
	movq	$3, 8(%rax)
	movq	%rdi, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	$1, %rax
	addq	$8, %rsp
	.cfi_adjust_cfa_offset -8
	ret
	.cfi_adjust_cfa_offset 8
	.cfi_adjust_cfa_offset -8
	.cfi_endproc
	.data
	.text
	nop
	.globl	_camlLoop__code_end
_camlLoop__code_end:
	.data
				/* relocation table start */
	.align	3
				/* relocation table end */
	.data
	.quad	0
	.globl	_camlLoop__data_end
_camlLoop__data_end:
	.quad	0
	.align	3
	.globl	_camlLoop__frametable
_camlLoop__frametable:
	.quad	1
	.quad	L106
	.word	16
	.word	1
	.word	3
	.align	3
