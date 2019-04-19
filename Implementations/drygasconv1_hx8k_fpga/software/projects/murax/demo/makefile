PROJ_NAME=demo
DEBUG=no
BENCH=no
MULDIV=no


SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp)  \
		$(wildcard src/*.S)


INC += -I../../../libs/
INC += -I../libs/
LDSCRIPT = ../libs/linker.ld
#LDSCRIPT = ./src/linker.ld

include ../../../resources/gcc.mk
include ../../../resources/subproject.mk


			
