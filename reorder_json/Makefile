FLAGS=-Wall -pedantic -O3
CPPFLAG=-std=c++17
CFLAG=-std=c99
OUTDIR=./bin

all: reorder_json

binary:
	mkdir -p ./bin

json:
	make -C ./json

reorder_json: binary json reorder_json.cpp
	g++ $(CPPFLAG) $(FLAGS) -o ./bin/reorder_json reorder_json.cpp
