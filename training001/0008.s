# OF(オーバーフローフラグ)
# 符号付き演算で値域越えが発生した場合に立つフラグです。
# 32bit符号付き整数の場合、 0x80000000(min) <--> 0x7fffffff(max)の間でセットされます。

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl $0x7fffffff, %eax # 2147483647, maximum of signed integer in 32bit
	addl $1, %eax # => 0x80000000 = -2147483648, minimum of signed integer of 32bit
	addl $1, %eax # => 0x80000001 = -2147483647

	movl $0x80000000, %eax # -2147483648
	subl $1, %eax # => 0x7fffffff = 2147483647

	.global end_of_program
end_of_program:
	int3
	nop
