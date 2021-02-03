# 0002.s データ長の指定
# AT&T構文では、レジスタの名称を指定する場合はプリフィックスとして%記号をつける
# mov系の命令では、書込みするデータ長を指定する1文字を末尾につける
# movb: 1バイト(8 bit)(byte のb)
# movw: 2バイト(16bit)(word のw)
# movl: 4バイト(32bit)(long のl)
#
# レジスタの値の確認は、gdb実行時に "info register regster_name" で表示できる

	.text
	.align 4

	.global entry_point
entry_point:
	int3	# stop program
	
	movl $0x12345678, %eax # copy a value of imediate(0x12345678) registar "eax"
	movl %eax, %ebx # copy a value of eax to ebx	
	movl %eax, %ecx # copy a value of eax to ecx
	int3	# stop program

	movw $0xffffffff, %ebx # 2byte copy a value to register "ebx", result is 0x1234ffff
	movb $0xffffffff, %ecx # 1byte copy a value to register "ecx",  result is 0x123456ff
	int3	# stop program

	.global end_of_program
end_of_program:
	int3 # stop program
	nop # not oparation (nothing to do)
