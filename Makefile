BINDIR=$(PWD)/bin

all: warning

warning:
	@echo "Make sure you have installed all required dependencies/using the given container. Then use 'make compile'."

compile: BitmatrixShuffle reorder_json kmindex

binary:
	mkdir -p ./bin

BitmatrixShuffle: binary
	make -C ./BitmatrixShuffle
	ln -sf $(PWD)/BitmatrixShuffle/reorder $(BINDIR)/reorder
	ln -sf $(PWD)/BitmatrixShuffle/reverse_reorder $(BINDIR)/reverse_reorder

reorder_json: binary
	make -C ./reorder_json
	ln -sf $(PWD)/reorder_json/bin/reorder_json $(BINDIR)/reorder_json

kmindex: binary
	(cd kmindex/thirdparty/kmtricks && ./install.sh -p -q) #Compile mainBlock(Dec/C)ompressorZSTD
	(cd kmindex && ./install.sh)
	ln -sf $(PWD)/kmindex/thirdparty/kmtricks/bin/mainBlockCompressorZSTD $(BINDIR)/mainBlockCompressorZSTD
	ln -sf $(PWD)/kmindex/thirdparty/kmtricks/bin/mainBlockDecompressorZSTD $(BINDIR)/mainBlockDecompressorZSTD
	ln -sf $(PWD)/kmindex/kmindex_install/bin/kmindex $(BINDIR)/kmindex
	ln -sf $(PWD)/kmindex/kmindex_install/bin/kmindex-server $(BINDIR)/kmindex-server
