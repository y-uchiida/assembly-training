# CF(キャリーフラグ)
# 演算の結果、値域越えが発生した際に立つフラグです
# 32ビット領域に対して、0xffffffff + 1 で 0x00000000 になったり、  
# 0x00000000 - 1 で0xffffffff になったりなど、
# 表現できる上限値を越えたときにキャリーフラグが立ちます。
# 下記のプログラムをコンパイルしたのち、gdbを起動します。
# stepi で処理を進めていき、info registers eax eflags でレジスタの値を観察します。
# 0xffffffffが0x0になった時や、0x0が0xffffffffになったときにCFがセットされるのが確認できます。

	.text
	.align 4

	.global entry_point
entry_point:
	int3

	movl $0xffffffff, %eax # maximum of long(32bit)

	addl $1, %eax # eax(=0xffffffff=-1) + 1 = 0 (over flow)
	addl $1, %eax # eax(=0) + 1 = 1

	subl $2, %eax # eax(=1) - 2 = 0xffffffff(=-1)

	.global end_of_program
end_of_program:
	int3
	nop
