# SF(サインフラグ)
# 演算結果を符号付き数値と考えた場合に、マイナスの値かどうかを判別します。
# 最上位ビット(sign bit)が1の場合にSFが立ち、0の場合は倒れます。

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl $0, %eax

	subl $1, %eax # => -1, result is negative value
	addl $2, %eax # => +1, result is positive value

	.global end_of_program
end_of_program:
	int3
	nop
