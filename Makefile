PDF=memoria.pdf

all: $(PDF)

%.pdf: %.md citas.bib
	pandoc --filter pandoc-citeproc $< -s -o $@

clean:
	rm -f $(PDF)
