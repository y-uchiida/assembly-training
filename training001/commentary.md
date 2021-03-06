# commentary of training001
書籍 "アセンブラで読み解くプログラムのしくみ"の掲載内容をもとに、アセンブリ言語の基本に触れてみました。  
書籍の指定により、asコマンドでコンパイルするAT&T構文を利用します。

## データ転送命令(mov)
move を語源とした命令で、値を指定した領域(レジスタ)へ移動(コピー)させます。
movの後ろに1文字、データ長を表す文字をつけることができます。  
- movb: (byte) 8ビット(1バイト)分のデータをコピー
- movw: (word) 16ビット(2バイト)分のデータをコピー
- movl: (long) 32ビット(4バイト)分のデータをコピー

## int3
プログラムの動作を一時停止する割込み命令です
intは、"integer"の頭文字じゃなくて "interrupt"の頭文字のようです

## 境界整合(ここ、いまいちわかってない)
領域に値を格納する際、メモリの先頭位置に気を遣わなければいけない、という話のようです。  
4バイトデータなら4の倍数のメモリから始める…といった処理が必要で、その位置調整のために `.align N`を使用する、、、ようです。  
しかし、試しに作ってみたコードが思ったような挙動になっておらず、なにかを勘違いしているのだと思います…  

## フラグによる条件判定
演算実行時に、その実行結果に応じて値が変化するフラグ(レジスタ上のビット)によって、条件分岐を行うことができます。
intel系CPUはEFLAGSというレジスタを持っており、これを見ることで演算した結果がどうだったのかを判断することができます。

### 演算結果が0かどうかを判定する: ゼロフラグ(ZF)
演算結果が0の場合に立つフラグです。  

### 演算結果に値域超えが発生したかどうかを判定する: キャリーフラグ(CF)
32ビット領域に対して、0xffffffff + 1 で 0x00000000 になったり、  
0x00000000 - 1 で0xffffffff になったりなど、  
表現できる上限値を越えたときにキャリーフラグが立ちます。

### 符号付きの場合の演算結果に値域越えが発生したかどうかを判定する: オーバーフローフラグ(OF)
符号付き演算で値域越えが発生した場合に立つフラグです。  
たとえば32bit符号付き整数の場合、 0x80000000(min) <--> 0x7fffffff(max) の間でセットされます。

### 符号ビットの値を判定する: サインフラグ(SF)
演算結果を符号付き数値と考えた場合に、マイナスの値かどうかを判別します。  
最上位ビット(sign bit)が1の場合にSFが立ち、0の場合は倒れます。

## 比較命令と分岐命令
プログラミング言語における、if ... else の実装に必要となる処理として、  
アセンブリには比較命令と分岐命令があります。

### 比較命令
与えられた2つの内容を比較し、その結果をeflagsに反映します。  
これまで用いてきた演算命令(addlとかsubl)は、レジスタに保持されている値を変化させていましたが、比較命令cmplは  
eflagsに演算結果を反映するのみで、レジスタの値を変更しません。  
現在の内容によって、処理を分岐させる場合などに活用できる命令です。
`cmp`のうしろに、比較するバイト列の長さを示す接尾字をつけます。
- cmpb: 1バイトの比較
- cmpw: 2バイトの比較
- cmpl: 4バイトの比較

### 分岐命令
その時点のeflagsの状態をみて、次に実行する命令が格納されているアドレスを示すレジスタ(プログラムカウンタという)を  
書き換えるのが、分岐命令です。
jumpをしめす`j`の後ろに、評価する条件を表す文字をつなげる形式になっています。  
命令の後ろに、比較する2つの値もしくはレジスタを記述します。
また、条件を指定せず、つねにプログラムカウンタを変更する無条件分岐命令`jmp`もあります。

- je:  等しい(Equal)
- jne: 等しくない(Not Equal)
- jg:  符号付きの値としてみたとき、比較値より大きい(Greater)
- jle: 符号付きの値としてみたとき、比較値より小さい(Less or Equal)
- jge: 符号付きの値としてみたとき、比較値より大きい(Greater or Equal)
- jl:  符号付きの値としてみたとき、比較値未満(Less)
- ja:  符号なしの値としてみたとき、比較値より大きい(Above)
- jna: 符号なしの値としてみたとき、比較値以下(Not Above)
- jae: 符号なしの値としてみたとき、比較値以上(Above or Equal)
- jb:  符号なしの値としてみたとき、比較値未満(Below)

### 論理積・論理和とjne命令
論理積や論理和は、jne命令をうまく使うことで実現できます。  
論理積の場合は、ひとつでもfalseがあればifブロックを飛ばして次の処理に移ればいいので、falseならnot_matchの位置に遷移するようにします。  
論理和の場合は、ひとつでもtrueがあればifブロックの内部を処理させればいいので、 trueなら matchの位置に遷移するようにします。  
いずれも、条件を `cmpl $0, condition` で比較して、eflagsに結果を反映した後、jne命令を記述することで対応できます。  

## アセンブリでの関数の実装
jmp 命令を用いた簡易的な関数呼び出しから、引数、戻り値の実装までの考え方を学習しました。

### 関数の呼出し
関数の呼出しを機械語のレベルでとらえなおしてみると、以下のような動作になります。  
1. 呼出し元プログラムが記述されているメモリのアドレスを記憶しておく
2. 呼出されるプログラムが記述されているメモリのアドレスへ、処理を遷移させる(jmp)
3. 呼出されるプログラムの内容を実行する
4. 記憶しておいた呼出し元プログラムが記述されている部分へ、処理を遷移させる(jmp)

jmp 命令を利用することでも実現できますが、関数呼び出しの動作をかんたんに行うための専用の命令が用意されています。  
呼出しのためのcall 命令と、呼出し元への復帰のための ret 命令です。  
この2つを利用することで、上記の関数の呼び出しから復帰までの処理が実現できます。  

### ローカル変数とスタックフレーム
関数内でのローカル変数(局所変数)の実現のために、スタック領域に値を保持します。  
どの関数で宣言されたものなのかが分かるように、スタックフレームという構造が一般的に用いられます。  
呼出し元の処理のアドレスとスタックフレームの位置を覚えておき、それをスタック構造(先入れ後出し構造)で保存することで、  
関数の呼び出し順の通りにローカル変数を取り扱うことができるようになります。  

### 関数の引数
関数を呼び出す際に、関数に対して値を渡す(引数指定)をする場合も、スタックフレームに値を入れておくようにします。(x86の場合)  
スタックフレームは、スタック領域上の連続したアドレス上に存在するため、  
呼出し先の関数から呼出し元の関数のスタックフレームの値を読み取ることが可能です。  
x64においては、レジスタを用いて値を引き渡すような規約になっているらしいですが、  
参考にした書籍はx86環境を前提にしているため、ここではスタックフレームを用いる方法でサンプルコードを作成しました。

### 関数の戻り値
関数の戻り値は、eaxレジスタに格納するという規約になっているようです。  
戻り値にしたい内容をeaxレジスタに入れてret 命令を実行し、呼出し元ではeaxレジスタの値を戻り値とみなして処理します。