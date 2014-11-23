	
"Load files from the folder corpus to GODProcessorFiles a WAFileLibrary subclass "
dirName := (FileDirectory default pathName),FileDirectory slash,'corpus',FileDirectory slash.
corpusDir := FileDirectory forFileName: dirName.
corpusDir fileAndDirectoryNames do:[:f |
	GODProcessorFiles add: dirName,f.
	Transcript show: f, ' loaded'; cr.
].
