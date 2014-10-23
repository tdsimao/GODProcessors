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
def tf-idf(t, tf ) 
  ^ tf*dict_idf(ti)
```

  - createDict_tf(d): generates the dictionary of terms frequency of the document d
```Smalltalk
def createDict_tf(d)
  " convert d to a collection"
  anArray := tokenizer:d

  " realizes proprocessing
  #    remove stop words
  #    lemmatization"
  
  self preprocess: anArray.
  
  pcs := PCSProcessors new.
  
  " calculates number of ocourrences of each term"
  aDict := pcs countIn: anArray
  
  
  " remove from aDict terms with frequencia out of the interval [min_tf, max_tf]
  #TODO"
  
  ^ aDict
```
  - training(aCollection): main function of this class
    - defines the dict_idf for the given collection

```Smalltalk
def training(aCollection)

  numDocuments := aCollection size.
  dict_df := Dictionary new.
  
  "gera o dicionario de frequencias de cada documento "
  for d in aCollection:
    anArray := preprocess:d
    
    for term in anArray asSet:
      "checar se em caso de dict_idf[term] não existir ele retorna 0"
      dict_idf[term] := dict_idf[term] + 1
  
  
  dict_idf := Dictionary new.
  
  "converte dict_df into a Inverse Document Frequency dictionary"
  
  for term, freq in dict_df keys:
    dict_idf[term] := log(freq / numDocuments)
  
  ^ idf
```

  - tokenizer(aString): returns a collection of tokens
    - splits the string
```Smalltalk
def tokenizer: aString
  |aCollection|
  
  ^ aCollection
```


##How to use,

Code example :smile:


```Smalltalk
pcsTagger = PCSTagger new.

pcs.training: aGODDataCollection.

pcs.addTagsTo: aGODData.
pcs.addTagsTo: anotherGODData.



```
