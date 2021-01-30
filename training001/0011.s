# 分岐命令
# eflagsの値を参照し、条件に合う場合にプログラムカウンタ(次の命令が記述されているメモリアドレスを保持しているレジスタ)の値を
# 指定した内容に書き換える命令です。
# 比較命令(compl)などと組み合わせて、条件分岐の挙動を実現します。
# jのうしろに判断する条件を表す文字をつなげた条件分岐命令と、無条件分岐命令jmp があります。
# 条件分岐命令は、指定した条件が成り立つ場合にプログラムカウンタを変更し、無条件分岐命令は常にプログラムカウンタを変更します。

	.data
	.align 4

	.global value
value:
	.long 1 # value = 1;
	.align 4

	.global result
result:
	.long 0 # result = 0;
	.align 4

	.text
	.align 4
	.global entry_point

entry_point:
	int3

	cmpl $0, value # if (value == 0) => false
	jne not_matched # false, then goto not_matched

matched:
	movl $1, result
	jmp end_of_program

not_matched:
	movl $-1, result
	jmp end_of_program

	.global end_of_program
end_of_program:
	int3
	nop
