PDF=memoria.pdf

all: $(PDF)

%.pdf: %.md citas.bibtex
	pandoc --filter pandoc-citeproc $< -s -o $@

clean:
	rm -f $(PDF)
