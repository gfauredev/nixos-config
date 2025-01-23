# CC=gcc
CFLAGS=-Wall -Werror -g -fanalyzer
OBJS=lib.o
# LDFLAGS=-lm
EXE=dump_base

run: $(EXE)
	./$<

all: $(EXE)

$(EXE): %: %.o $(OBJS)

%.zip: *.c *.h makefile
	zip -r $@ $^

clean:
	trash main $(EXE) *.o *.so *.zip 

.PHONY: run clean
