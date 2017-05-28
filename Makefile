PDF=memoria.pdf transparencias.pdf

all: $(PDF)

memoria.pdf: memoria.md citas.bib
	pandoc --to latex --latex-engine xelatex -N -o $@ $< --filter pandoc-citeproc

transparencias.pdf: transparencias.md
	pandoc -t beamer $< -o $@

clean:
	rm -f $(PDF)
