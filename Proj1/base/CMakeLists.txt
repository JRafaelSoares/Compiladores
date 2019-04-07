cmake_minimum_required(VERSION 3.13)
project(base)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)
include_directories(lib)

add_executable(base
        "diy files/factorial.diy"
        "diy files/iter.diy"
        "diy files/mean.diy"
        "diy files/rand.diy"
        "diy files/recurs.diy"
        "diy files/string.diy"
        "diy files/test.diy"
        exs/ack.diy
        exs/hello.diy
        exs/Makefile
        lib/libutil.a
        lib/main.c
        lib/main.o
        lib/Makefile
        lib/node.c
        lib/node.h
        lib/node.o
        lib/postfix.h
        lib/postfix.html
        lib/tabid.c
        lib/tabid.h
        lib/tabid.o
        run/dbl.asm
        run/lib.asm
        run/linux.asm
        run/Makefile
        run/sys.asm
        tests/test1.in
        tests/test1.out
        tests/test2.in
        tests/test2.out
        tests/test3.in
        tests/test3.out
        tests/test4.in
        tests/test4.out
        tests/test5.in
        tests/test5.out
        tests/test6.in
        ack.txt
        bola.txt
        diy.brg
        diy.l
        factorial.c
        inicial.y
        lex.yy.c
        Makefile
        string.c
        y.output
        y.tab.c
        y.tab.h
        yyselect.c)
