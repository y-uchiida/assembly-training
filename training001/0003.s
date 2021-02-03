	.data
	.align 4

	.global value
value:
	.long 1

	.text
	.align 4

	.global entry_point
entry_point:
	int3 # stop program

	# 転送元: value 領域の「格納値」(間接)
	# 転送先: eaxレジスタ(直接)
	movl value, %eax
	int3

	# 転送元: value 領域の「アドレス」(直接)
	# 転送先: eaxレジスタ(直接)
	movl $value, %eax
	int3

	# 転送元: eaxレジスタの参照先領域の格納値(間接)
	# 転送先: ebxレジスタ(直接)
	movl (%eax), %ebx
	int3

	# 転送元: 即値(直接)
	# 転送先: eax レジスタの参照先領域の格納値(間接)
	movl $0xffffff, (%eax)
	int3

	# 転送元: 即値 (直接)
	# 転送先: value 領域(間接)
	movl $0x12345678, value
	int3

	# 転送元: eax レジスタ (直接)
	# 転送先: value 領域(間接)
	movl %eax, value
	int3

	.global end_of_program
end_of_program:
	int3
	nop