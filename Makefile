BINDIR=$(PWD)/bin

all: binary BitmatrixShuffle reorder_json kmindex

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
	(cd kmindex && ./install.sh)
	ln -sf $(PWD)/kmindex/kmindex_install/bin/kmindex $(BINDIR)/kmindex
	ln -sf $(PWD)/kmindex/kmindex_install/bin/kmindex-server $(BINDIR)/kmindex-server
