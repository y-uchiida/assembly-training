# 論理積の実装
# 条件がすべてtrue のとき、つまり、すべて condition != 0 の場合だけ実行されるので、
# それぞれの条件について順番に0ではないことを確認し、全てを通過したら実行する、とすれば実現できます。
# C言語で以下のようなコードを作成した場合、アセンブラが出力するコードの例はこのような形になります。
# ※ サンプルなので、動きません！！
#
# if (a && b && c) {
#	num = 1;
# }

	.data
	.align 4

	.global num
num:
	.long -1
	.align 4

	.global entry_point
entry_point:
	int3

	cmpl $0, a # check condition a is 0(==false)?
	je not_matched # a == 0, then goto not_matched

	cmpl $0, b # check condition b is 0(==false)?
	je not_matched # b == 0, then goto not_matched

	cmpl $0, c # check condition c is 0(==false)?
	je not_matched # c == 0, then goto not_matched

	movl $1, num # if (a && b && c) is true, this will execute

not_matched:
	# if (a && b && c) is false, jump here

	.global end_of_program
end_of_program:
	int3
	nop
