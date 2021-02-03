# ZF(ゼロフラグ)
# 直前に行った演算の結果が0かどうかを判定する、eflagsの中にあるビット
# 下記のプログラムをコンパイルしてgdbで実行し、
# `info registers eax eflags` を実行すると、eaxの値とeflagsで立っているフラグが表示される
# stepin でステップ実行してeaxの値を 2 -> 1 -> 0 と変化させていき、 0になった時に eflagsにZFが着くことが確認できる

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl $2, %eax

	subl $1, %eax # eax(=2) - 1  => result : eax = 1
	subl $1, %eax # eax(=1) - 1  => result : eax = 0

	.global end_of_program
end_of_program:
	int3
	nop
