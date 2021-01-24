# 0005.s 境界整合(データアラインメント)　※内容不適
# データを一定のサイズで整えること
# たとえば4バイトのデータを転送する場合、格納先アドレスが4の倍数になっている必要がある
# 直前に2バイト分のデータが入っていて、格納しようとしているアドレスが(4n+2)になっているとしたら、
# 2バイト分はなした位置からデータを格納しなければならない(4n+2の位置から+2して4の倍数にする)
# ".align N" は、直後に記述した内容がメモリ上に配置される場合、空白領域を設けるなどして
# 格納先のアドレスが指定された整数Nの倍数になるように調整を行ってくれる？
# 試してみたけど違うっぽい、間違っているので封印したい…

	.data

	.align 4
	.global val_long
val_long:
	.long 1

	.align 2
	.global va_word
val_word:
	.word 2

	.align 1
	.global val_string
val_string:
	.ascii "string"

	.align 1
	.global va_string2
val_string2:
	.ascii "string2"

	.align 4
	.global val_long2
val_long2:
	.long 3

	.text
	.align 4
	.global entry_point
entry_point:
	int3
	nop
