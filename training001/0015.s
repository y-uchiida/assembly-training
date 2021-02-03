# 関数の呼出しの原理...処理する命令の位置の変更と復帰
# あるプログラムを実行中に、別のファイルやライブラリ内で記述されているプログラム(関数)を実行させることができます。
# これを機械語のレベルでとらえなおしてみると、以下のような動作をしていることになります。
# 
# 1. 呼出し元プログラムが記述されているメモリのアドレスを記憶しておく
# 2. 呼出されるプログラムが記述されているメモリのアドレスへ、処理を遷移させる(jmp)
# 3. 呼出されるプログラムの内容を実行する
# 4. 記憶しておいた呼出し元プログラムが記述されている部分へ、処理を遷移させる(jmp)
#
# これを lea 命令とjmp 命令で実装すると、以下のような形になります。
# ※ lea 命令: メモリ上の場所のアドレス値をレジスタに格納する (Load Effective Address)  例によって、末尾1文字は保存するバイト長
# 以下のプログラムをコンパイルしてgdbでデバッグします。
# entry_point での処理で value = 100 になったあと、function_startの処理に移って value = 200 に変更されるのがわかります。

	.data
	.align 4

	.global value
value:
	.long 0

	.text
	.align 4

	.global entry_point
entry_point:
	int3
	movl $100, value # value = 100;
	leal return_point, %eax # *eax = &(return_point)
	jmp function_start
return_point:
	int3
	jmp end_of_program

function_start:
	movl $200, value # value = 200;
	jmp *%eax # goto *eax(= memory address of "return point")

	.global end_of_program
end_of_program:
	int3
	nop
