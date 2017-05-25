PDF=memoria.pdf transparencias.pdf

all: $(PDF)

memoria.pdf: memoria.md citas.bib
	pandoc --filter pandoc-citeproc $< -s -o $@

transparencias.pdf: transparencias.md
	pandoc -t beamer $< -o $@

clean:
	rm -f $(PDF)
