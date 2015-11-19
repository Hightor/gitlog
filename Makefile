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

archive = gitlog.tar.gz
ginfile = .git/gitHeadInfo.gin
bibfile = gitlog.sample.bib

codelist = gitlog.sty gitlog.bbx gitlog.dbx
docslist = gitlog.tex gitlog.pdf $(bibfile)
morelist = README
dirtlist = gitlog.pdf gitlog.tar.gz

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

gitlog.pdf: gitlog.tex $(codelist) $(ginfile)
	rm -f $@ $(auxdir)/*
	$(lmkexec) -outdir=$(auxdir) $(silent) -pdf -pdflatex="xelatex --shell-escape %O %S" "$<"
	chmod a+rw $(auxdir) $(auxdir)/*
	mv $(auxdir)/$@ ./

%.view: %.pdf
	$(viewpdf) $<
