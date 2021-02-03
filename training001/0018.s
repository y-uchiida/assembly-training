# 関数スタックフレーム作成のための命令: enter 命令 とleave 命令
# 0017.s では、function_startラベルでのスタックフレームを実現するために、subl, addl やmovlを組み合わせました。
# これらと同様の動作をまとめて行ってくれるのが、enter 命令と leave 命令 です。
# 関数の最初でenter 命令を実行することで、オペランドで指定されただけの領域を確保し、ebpとespの位置を適切に変更します。
# leaveとebpを元の位置に戻して、呼出し元のスタックフレームが参照できるように変更します。
# 0017.sのソースは、enter 命令と leave 命令を用いて、以下のように書き換えることができます。

	.data
	.global value
value:
	.long 0

	.text
	.align 4

	.global entry_point
entry_point:
	# create entry_points stack frame, local variable size = 12bytes
	enter $12, $0

	movl $100,  -4(%ebp)
	movl $200,  -8(%ebp)
	movl $300, -12(%ebp)
	int3

	call function_start
	int3
	jmp end_of_program

function_start:
	enter $12, $0

	movl $0,  -4(%ebp)
	movl $1,  -8(%ebp)
	movl $2, -12(%ebp)
	int3

	leave
	ret

	.global end_of_program
end_of_program:
	leave
	int3
	nop
