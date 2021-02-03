# 関数の引数と戻り値
# 0018.sの内容で、関数内のローカル変数を宣言・管理する方法がわかりました。
# 次は、別の関数どうしの値の受け渡し…呼出し元の関数から与えられる引数と、呼出し先の関数からの戻り値について扱います。
# 引数は、①レジスタに格納する ②スタックフレームに格納する　の2つのパターンが考えられます。
# 参考にした書籍「アセンブラで読み解くプログラムのしくみ」では、②を紹介しています。 
# x86ではレジスタが少ないので、スタックを使って引数をやり取りするのが一般的、とのこと。
# x64環境で、C言語との連携を考えた場合は、①レジスタに格納する　の方法がよいようです。
# 呼出し先関数から、呼出し元のスタックフレームを読み取る場合、リターンアドレスと呼出し元関数のEBPアドレスが保存されている分、
# 呼出し元関数で設定した位置から8バイトだけずらした数値を参照することに注意が必要です。

	.text
	.align 4
	.global entry_point
entry_point:
	# create entry_points stack frame, local variable size = 8bytes
	enter $8, $0
	movl $0, %eax
	movl $100, 0(%esp) # set a value into stackframe
	movl $200, 4(%esp) # set a value into stackframe
	int3

	call function_sum_2_args # goto function_sum_2_args
	jmp end_of_program

function_sum_2_args:
	enter $0, $0
	movl 8(%ebp), %eax # load a value from stackframe(%esp-0) of entry_point to eax register
	addl 12(%ebp), %eax # add value of stackframe(%esp-4) to eax register
	int3

	leave
	ret

	.global end_of_program
end_of_program:
	leave
	int3
	nop
