# 0004.s バイトオーダー
# アドレス内のデータビットの格納方式
# 最上位ビットを含むバイトがアドレス低位に書き込まれる方式をビッグエンディアン(MSB First)
# 最下位ビットを含むバイトがアドレス低位に書き込まれる方式をリトルエンディアン(LSB First)
# 0x12345678のデータの場合、
# ビッグエンディアンなら、アドレス低位(起点アドレスに近いところから) 0x12 0x34 0x56 0x78
# リトルエンディアンなら、アドレス低位(起点アドレスに近いところから) 0x78 0x56 0x34 0x12
# 以下をコンパイルして、gdbで "x/4bx &value" と実行するとvalueのアドレス4バイト分を
# 4分割して1バイトずつ表示させることができる(4つの8ビット値(4b)を16進数(x)で表示　という意味)

	.data
	.align 4

	.global value
value:
	.long 0x12345678

	.text
	.align 4

	.global entry_point
entry_point:
	int3
	nop
	