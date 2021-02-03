# switch 構文の実装例
#
# 以下のようなswitchのブロックをアセンブリで表現する場合の処理を考えてみます。
# switch(x)
# {
# 	case 2:
#		a = 1; break;
# 	case 5:
#		a = 2; break;
# 	case 8:
#		a = 3; break;
# 	default:
#		a = 4; break;
# }
#
# 処理内容は以下のようになります。
# 1. switchブロックで判定する条件の最小値から最大値までの範囲の大きさの配列を用意します
# 2. 条件に含められている値の場合はその処理を記述した位置へのラベルを設定します
# 3. それ以外の値の場合は、デフォルト処理を記述した位置へのラベルを設定します
# 4. 条件判定する値が、条件に合致する最小値よりも小さいか、最大値よりも大きい場合はデフォルトの処理へ遷移させます
# 5. 判定する値から条件の最小値を減算し、配列の先頭からの差(= 配列のインデックス値)を得ます
# 6. 配列の先頭のアドレスとインデックス値を使って、該当する値の処理が書かれているアドレスへ遷移します
# 
# 以下のプログラムをコンパイルしてgdbで動作を確認してみます。
# run でプログラムを実行させ、entry_pointのint3 まで処理を進めます。
# set var x=N で 変数xに値を代入します
# stepi で分岐処理( jmp *(%ebx, %eax, 4) )の位置まで進めます
# info registers ebx eax でレジスタの値を確認します
# 最後に、switchのブロックの処理の結果、変数aの値を確認します
# 
	.data
	.align

	.global x
x:
	.long 0

	.global a
a:
	.long 0

addr_table:
	.long switch_case_2  # 2 (MIN + 0)
	.long switch_default # 3 (MIN + 1)
	.long switch_default # 4 (MIN + 2)
	.long switch_case_5  # 5 (MIN + 3)
	.long switch_default # 6 (MIN + 4)
	.long switch_default # 7 (MIN + 5)
	.long switch_case_8  # 8 (MIN + 6)

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl x, %eax

	cmpl $2, %eax
	jl switch_default # if (x < 2), then goto switch_defalut

	cmpl $8, %eax
	jg switch_default # if (x > 8), then goto switch_defalut

	leal addr_table, %ebx # set address of "addr_table" to register ebx 
	subl $2, %eax
	jmp *(%ebx, %eax, 4) # goto *(addr_table) + (x - 2) * 4

switch_case_2:
	movl $1, a
	jmp switch_eob
switch_case_5:
	movl $2, a
	jmp switch_eob
switch_case_8:
	movl $3, a
	jmp switch_eob
switch_default:
	movl $4, a
	jmp switch_eob
switch_eob: # end_of_block

	.global end_of_program
end_of_program:
	int3
	nop
