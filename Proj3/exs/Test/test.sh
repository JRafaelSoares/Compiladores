#!/bin/bash 

MAKE=../../  	#make directory
RUN=../../run
LIB=diy

make -C $MAKE &> /dev/null
make -C $RUN &> /dev/null

for f in *.diy
do
	../../diy $f &> /dev/null
	nasm -felf32 "${f%.*}.asm" -o "${f%.*}.o" &> /dev/null
	ld -melf_i386 -o temp "${f%.*}.o" -L"$RUN" -l"$LIB" &> /dev/null

	printf "${f%.*}:\n"
	./temp
	printf "\n\n"

	rm -f temp "${f%.*}.asm" "${f%.*}.o" &> /dev/null
	read -n1 -r -p "Press any key to continue..." key
done