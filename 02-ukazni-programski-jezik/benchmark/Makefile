COMM = $(HOME)/Documents/plzoo/comm.native

default: bench
	@echo "----- C -----"
	@time ./bench
	@echo "----- Python -----"
	@time python3 ./bench.py
	@echo "----- comm -----"
	@time $(COMM) ./bench.comm

bench: bench.c
	gcc -O3 bench.c -o bench
