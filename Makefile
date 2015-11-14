sphere.out: spheremain.o spheredriver.o 
	gcc -m64 -o sphere.out spheredriver.o spheremain.o

spheremain.o: spheremain.asm
	nasm -f elf64 -l spheremain.lis -o spheremain.o spheremain.asm

spheredriver.o:
	gcc -c -m64 -Wall -std=c99 -l spheredriver.lis -o spheredriver.o spheredriver.c

clean:
	rm -f spheremain.lis spheremain.o spheredriver.o sphere.out
