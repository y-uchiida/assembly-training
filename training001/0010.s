# 比較命令
# 与えられた2つの内容を比較し、その結果をeflagsに反映します。
# これまで用いてきた演算命令(addlとかsubl)は、レジスタに保持されている値を変化させていましたが、比較命令cmplは
# eflagsに演算結果を反映するのみで、レジスタの値を変更しません。
# 現在の内容によって、処理を分岐させる場合などに活用できる命令です。

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl $0, %eax
	subl $1, %eax # => -1(0xffffffff), eflags: [ CF PF AF SF IF ]

	cmpl $0xffffffff, %eax # compare 0xffffffff and eax. its same, eflags: [ PF ZF IF ]

	.global end_of_program
end_of_program:
	int3
	nop
