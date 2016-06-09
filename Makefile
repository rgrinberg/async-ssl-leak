OCAMLBUILD = ocamlbuild -use-ocamlfind -tag debug -tag thread -tag 'package(async_ssl)'

all:
	$(OCAMLBUILD) leaker.native

clean:
	$(OCAMLBUILD) -clean

.PHONY: all clean
