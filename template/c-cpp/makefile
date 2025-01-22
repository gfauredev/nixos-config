CC=gcc
PARAMS=-Wall -Werror -g -fanalyzer

MAIN=main
LIBS=

run: $(MAIN)
	./$<

$(MAIN): $(MAIN).o $(LIBS)
	$(CC) $(PARAMS) $^ -o $@

%.o: %.c
	$(CC) $(PARAMS) -c $< -o $@

clean:
	trash $(MAIN) *.o

.PHONY: run clean
