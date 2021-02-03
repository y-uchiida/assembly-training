# 関数呼び出しのための命令: callとret
# CPUには、関数呼び出しを行うための専用の命令が実装されています。
# call 命令 は、指定したアドレスへ処理を遷移させる命令です。
# jmp 命令 と違うのは、呼出し元の位置へ戻ってこられるように処理をしてくれることです。
# プログラムカウンタ(インストラクションポインタともいう)と呼ばれる、次に実行する命令を保持するレジスタの値をいったんスタック領域に退避してから、
# プログラムカウンタの値を指定されたアドレスに書き換えます。
# call 命令で遷移した場合、ret 命令で呼出し元に帰ることができます。
# ret 命令は、スタック領域に保存された呼出し元の命令のドレスをプログラムカウンタにpop してくれます。
# 0015.s で作成したアセンブリは、call 命令 と ret 命令 を利用して、以下のように書き換えることができます。

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
	call function_start # save eip (next instruction address) to stack area, and goto "function_start"
	int3
	jmp end_of_program

function_start:
	int3
	movl $200, value # value = 200;
	ret # goto return address get from stack area

	.global end_of_program
end_of_program:
	int3
	nop
