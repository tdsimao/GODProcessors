"Script para carregar documentos da pasta corpus
e recuperar os principais termos desses arquivos"

"Nome diretório com arquivos"
dirName := (FileDirectory default pathName),'/corpus/'.
corpusDir := FileDirectory forFileName: dirName.
aGODCollection := Bag new.

corpusDir fileAndDirectoryNames do:[:f | ios := FileStream oldFileNamed: dirName,f.
	aString := ''.
	[(x := ios nextLine) notNil]
	whileTrue: [aString := aString,x.].
	aGODData := GODData new.
	aGODData content: aString.
	aGODData title: f.
	aGODCollection add: aGODData.
	Transcript show: f, ' loaded'; cr.
].
Transcript show: aGODCollection size, ' files loaded'; cr;cr.


"Config tagger and preprocessor"
godTagger := PCSGODTagger new.
tagger := PCSTagger new.
p := PCSEnglishPreprocessor new.
p fileType: 'HTML'.
tagger preprocessor: p.
godTagger tagger: tagger.

"traine with aGODCollection"
godTagger training: aGODCollection.

"add tags do elements of aGODData"
aGODCollection do:[ :aGODData |
	godTagger addTagsTo: aGODData.
	].

aGODCollection do:[ :aGODData |
	Transcript show: aGODData title, ' -> '; show: aGODData tags;cr.	
	].

