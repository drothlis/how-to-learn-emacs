chapters := $(shell awk '/^[0-9A-Z]+\. / {print $$2}' toc)

chapters_haml := $(chapters:%=%.haml)
chapters_html := $(chapters:%=%.html)

all: $(chapters_html)

haml := haml/bin/haml --format html5 --autofilter markdown

$(chapters_html): %.html: %.haml toc layout.html
	@echo $@: $^
	@set -o pipefail; \
	cat $< |\
	bin/footnotes |\
	bin/tables |\
	$(haml) |\
	bin/layout layout.html |\
	bin/title $< |\
	bin/updated $(chapters_haml) |\
	bin/toc toc $(<:%.haml=%) |\
	bin/glossarylinks $(filter glossary.haml,$<) |\
	bin/next toc $(<:%.haml=%) \
	> $@

layout.html: layout.haml
	@echo $@: $^
	@$(haml) $< > $@

clean:
	rm -f *.html
.PHONY: clean

wc: basic_c.haml
	sed -Ee '/^ *(\.figure|\.window|\.modeline|\.echoarea)/,/^$$/ d' \
	  $^ | wc
.PHONY: wc

.DELETE_ON_ERROR:
