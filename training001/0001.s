# 0001.s データの代入
# AT&T 構文では、即値(imidiate value)にはプリフィックスとして$記号をつける
# 即値はレジスタに書き込まれる値であり、参照される内容となる
# 即値はmov命令によってレジスタへ書き込まれる(コピーされる)

	.data
	.align 4

	.global value
value:
	.long 1 

	.text
	.align 4

	.global entry_point
entry_point:
	int3
	movl $2, value

	.globl end_of_program
end_of_program:
	int3
	nop
