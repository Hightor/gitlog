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
localgin = gitHeadLocal.gin
bibfile = $(pkg).sample.bib

codelist = $(pkg).sty $(pkg).bbx $(pkg).dbx
madelist = $(pkg).pdf $(localgin) $(bibfile)
docslist = $(pkg).tex $(madelist)
morelist = README.md
dirtlist = $(madelist) $(archive)
dirtlist = $(pkg).pdf 

list = $(codelist) $(docslist) $(morelist)

auxdir = .auxfiles

ship: $(archive)

view: $(pkg).view

$(archive): $(list)
	# texlua build.lua ctan
	# chmod -R 644 $^ testfiles/* 
	chmod 644 $^
	perl `which ctanify` $^
	chmod 644 $@

clean $(ginfile):
	$(git) checkout $(dirtlist)

$(pkg).pdf: $(pkg).tex $(codelist) $(localgin) $(bibfile)
	rm -f $@ $(auxdir)/*
	$(lmkexec) -outdir=$(auxdir) $(silent) -pdf -pdflatex="xelatex -interaction=batchmode %O %S" "$<"
	chmod a+rw $(auxdir) $(auxdir)/*
	mv $(auxdir)/$@ ./

%.view: %.pdf
	$(viewpdf) $<

$(localgin): $(ginfile)
	cp $< $@
	chmod 644 $@

$(bibfile): $(ginfile)
	git --no-pager log --reverse --pretty="format:@gitcommit{%h,%n author = {%an},%n date = {%ad},%n title = {%B},%n commithash = {%H} }" --date=short > $@
	chmod 644 $@
