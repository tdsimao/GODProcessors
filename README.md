#GODProcessors

Description of class PCSTagger subclass of PCSProcessors


This class has the following atributes

  - dictIdf: an dictionary of idf
    - given a term t it returns the respective idf
  - maxTf: define the max frequence to be considerated
    - float in range [0..1]
  - minTf: define the min frequence to be considerated
    - float in range [0..1]

This class has the following methods


  - tf_idf: receive a term and the respective frequence in the doc and returns the tf-idf
```Smalltalk
tf-idf: aTerm withFrequence: aFrequence
  ^aFrequence * self dict_idf(aTerm)
```

  - createDict_tf(aString): generates the dictionary of terms frequency of the document aString
```Smalltalk
createDict_tf(aString)
  |anArray|
  " convert aString to a collection"
  
  anArray := tokenizer:aString

  " realizes proprocessing
      remove stop words
      lemmatization"
  
  self preprocess: anArray.
  
  "seria interessante colocar o método countIn na class PCSProcessor pois é comum as duas classes
    assim evitariamos ter de instanciar a classe aqui"
  pcs := PCSProcessors new.
  
  " calculates number of ocourrences of each term"
  aDict := pcs countIn: anArray
  
  
  " remove from aDict terms with frequencia out of the interval [min_tf, max_tf]
  #TODO"
  
  
  ^aDict
```
  - training(aCollection): main function of this class
    - defines the dict_idf for the given collection

```Smalltalk
def training(aCollection)

  numDocuments := aCollection size.
  dict_df := Dictionary new.
  
  "gera o dicionario de frequencias de cada documento "
  aCollection do [ :aElement|
    anArray := preprocess: aElement
    anArray asSet do [ term |
      dict_idf[term] := dict_idf[term] + 1
    ]
  
  
  dict_idf := Dictionary new.
  
  "converte dict_df into a Inverse Document Frequency dictionary"
  
  dict_df keysandvalues do: [ term freq|
    dict_idf at: term put: log(freq / numDocuments)
  ]
```

  - tokenizer(aString): returns a collection of tokens
    - splits the string
```Smalltalk
def tokenizer: aString
  |anArray|
  "this method split aString"
  anArray := Array new.
  
  ^ aCollection
```


  -  preprocess: anArray
    - to be defined
    - receives an Array of tokens
    - 
    - may remove common words
    - capitalize tokens
    - may do stemming and lemmatization
```Smalltalk
preprocess: anArray
  |anArray|
  "this method returns realizes comom preprocess methods
    - may remove common words
    - capitalize tokens
    - may do stemming and lemmatization
    
  "
  
```


  - tagCollection: aCollection
    - generate tags to all elements of aCollection
```Smalltalk
tagCollection: aCollection
  self training: aCollection
  aCollection do [ :element |
    self addTagsTo: element.
  ]
  
  
```



##How to use,

###To tag a collection
```Smalltalk
pcsTagger = PCSTagger new.
pcsTagger.tagCollection: aGODDataCollection.
```

###To tag an element
```Smalltalk
pcsTagger = PCSTagger new.
pcsTagger.training: aGODDataCollection.
pcsTagger.addTagsTo: aGODData.
```
