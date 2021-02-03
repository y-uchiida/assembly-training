# 局所変数とスタックフレーム
# lea 命令と jmp 命令で、関数を呼び出しを実現することができました。
# しかし、呼び出された関数の中でのローカル変数(局所変数)は、レジスタの利用だけでは実装できません。
# ローカル変数のスコープは、複数のスレッドから同時に呼び出されても、それぞれが独立している必要があるためです。
# そこで、スタック領域に「スタックフレーム」を作成します。
# スタック領域はメモリアドレス上に確保された領域で、push 命令と pop 命令でデータの追加と取り出しができます。
# push 命令 はスタック領域の先頭にデータを追加し、pop 命令 はスタック領域の先頭からデータを取り出します。
# pop 命令 でデータを取り出すと、次のpop 命令 で 取り出すことができるデータが変化し、ひとつ前にpush 命令 で保存したデータになります。
# スタック領域に、「スタックフレーム」というデータ構造を作ることで、局所変数を管理することができます。
# スタックフレームは、が関数呼び出しごとに以下のデータを保持しています。
# 1. その関数の呼出し元のアドレス(リターンアドレス)
# 2. 呼出し元関数のスタックフレームの開始位置のアドレス
# 3. 局所変数領域
# 関数の終了時に、ebpが指すメモリアドレス と espが指すメモリアドレスの間が、局所変数として利用可能な領域になります。
# なお、gdbでデバッグする際は、以下のようにするとスタックフレームの中を確認できます。
# 例: ebp-4から = ebp に最も近い4バイト を表示する
# x/1w $ebp-4
#
# 例: ebp-8 = ebpから8バイト離れたところから4バイト を表示する
# x/1w $ebp-8
#
# または、確保した局所変数領域のすべてを表示したい場合は、espを利用して、以下のように指定することもできます。
# 例: 3WORD分 = 12バイトを確保 していた場合
# x/3w $esp


	.data
	.global value
value:
	.long 0

	.text
	.align 4

	.global entry_point
entry_point:
	# create entry_points stack frame
	subl $4, %esp
	movl %ebp, (%esp)
	movl %esp, %ebp
	subl $12, %esp 

	movl $100,  -4(%ebp)
	movl $200,  -8(%ebp)
	movl $300, -12(%ebp)
	int3

	call function_start
	int3
	jmp end_of_program

function_start:
	subl $4, %esp # move esp register to save ebp register value
	movl %ebp, (%esp)

	movl %esp, %ebp # change ebp register value to esp register value to use ebp as head of stack frame
	subl $12, %esp # move esp register to allocate local variable index

	movl $0,  -4(%ebp)
	movl $1,  -8(%ebp)
	movl $2, -12(%ebp)

	int3

	movl %ebp, %esp # move esp value to ebp to reset previous ebp value
	movl (%esp), %ebp # current esp value is previous ebp(caller function's ebp)
	addl $4, %esp # move esp register to reset previous esp(celler function's esp) 

	ret

	.global end_of_program
end_of_program:
	movl %ebp, %esp
	movl (%esp), %ebp
	addl $4, %esp
	int3
	nop
