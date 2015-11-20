#!make -rRf
# -------------------------------------------------------------
# gitlog
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
latexmk = /cygdrive/d/Programs/TeX.Live/texmf-dist/scripts/latexmk/latexmk.pl
viewpdf = /cygdrive/c/Program\ Files/Tracker\ Software/PDF\ Viewer/PDFXCview.exe
lmkexec = latexmk
git = git
# git = /cygdrive/c/Program\ Files\ \(x86\)/Git/bin/git.exe
silent =
include ~/.make/Makefile

pkg = gitlog
archive = $(pkg).tar.gz
ginfile = .git/gitHeadInfo.gin
pseudofile = gitHeadLocal.gin
bibfile = $(pkg).sample.bib

codelist = $(pkg).sty $(pkg).bbx $(pkg).dbx
docslist = $(pkg).tex $(pkg).pdf $(pseudofile) $(bibfile)
morelist = README
dirtlist = $(pkg).pdf $(pkg).tar.gz $(pseudofile)
dirtlist = $(pkg).pdf 

list = $(codelist) $(docslist) $(morelist)

auxdir = .auxfiles

ship: $(archive)

$(archive): $(list)
	# texlua build.lua ctan
	# chmod -R 644 $^ testfiles/* 
	perl `which ctanify` $^
	chmod 644 $@

clean $(ginfile):
	$(git) checkout $(dirtlist)

$(pkg).pdf: $(pkg).tex $(codelist) $(pseudofile)
	rm -f $@ $(auxdir)/*
	$(lmkexec) -outdir=$(auxdir) $(silent) -pdf -pdflatex="xelatex --shell-escape %O %S" "$<"
	chmod a+rw $(auxdir) $(auxdir)/*
	mv $(auxdir)/$@ ./

%.view: %.pdf
	$(viewpdf) $<

$(pseudofile): $(ginfile)
	cp $< $@
	chmod 644 $@
