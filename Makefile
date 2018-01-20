.PHONY: all

all: fleet

interaction.cmi: interaction.mli
	ocamlc -c interaction.mli
interaction.cmo: interaction.ml interaction.cmi
	ocamlc -c interaction.ml
interaction.cma: interaction.cmo
	ocamlc -o interaction.cma -a graphics.cma interaction.cmo
fleet.cmi: fleet.mli
	ocamlc -c fleet.mli
fleet.cmo: interaction.cmi fleet.ml
	ocamlc -c fleet.ml
fleet: interaction.cma fleet.cmo
	ocamlc -o fleet interaction.cma fleet.cmo


