# 論理和の実装
# 条件のうちひとつでもtrue であるとき、つまりひとつでも condition != 0 であれば実行されます。
# それぞれの条件について順番に0 ではないことを確認し、一つでも 0でなければ実行する、とすれば実現できます。
# C言語で以下のようなコードを作成した場合、アセンブラが出力するコードの例はこのような形になります。
# ※ サンプルなので、動きません！！
#
# if (a || b || c) {
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
	jne matched # a != 0, then goto matched
	
	cmpl $0, b # check condition b is 0(==false)?
	jne matched # b != 0, then goto matched
	
	cmpl $0, c # check condition c is 0(==false)?
	jne matched # c != 0, then goto matched

	jmp not_matched

matched: # if (a || b || c) is true, jump here
	movl $1, num

not_matched:
	# if (a || b || c) is false, jump here

	.global end_of_program
end_of_program:
	int3
	nop
