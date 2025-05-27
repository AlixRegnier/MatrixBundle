BINDIR=./bin

all: binary BitmatrixShuffle reorder_json kmindex

binary: bin
	mkdir -p ./bin

BitmatrixShuffle: binary
	make -C ./BitmatrixShuffle
	ln -s ./BitmatrixShuffle/reorder $(BINDIR)/reorder  
        ln -s ./BitmatrixShuffle/reverse_reorder $(BINDIR)/reverse_reorder

reorder_json: binary
	make -C ./reorder_json
	ln -s ./reorder_json/bin/reorder_json $(BINDIR)/reorder_json

kmindex: binary
	(cd kmindex && ./install.sh) #Subcommand
