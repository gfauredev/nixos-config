CC = gcc
CFLAGS = -Wall -Werror -g

EXE=ex1 ex2

run: $(lastword $(EXE))
	./$<

%: %.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	trash $(EXE) *.o

.PHONY: clean
