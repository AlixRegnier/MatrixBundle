FLAGS=-Wall -pedantic -O3
CPPFLAG=-std=c++17
CFLAG=-std=c99
OUTDIR=../bin

all: reorder_index

json:
	make -C ./json

reorder_index: json reorder_index.cpp
	g++ $(CPPFLAG) $(FLAGS) -o $(OUTDIR)/reorder_index reorder_index.cpp
