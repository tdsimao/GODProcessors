#GODProcessors

##PCSTagger
Description of class PCSTagger subclass of PCSProcessors

###Atributes
This class has the following atributes

  - dictIdf: an dictionary of idf
    - given a term t it returns the respective idf
  - maxTf: define the max frequence to be considerated
    - float in range [0..1]
  - minTf: define the min frequence to be considerated
    - float in range [0..1]
  - minRelevance
    - define the min value of relevance that will be accepted as a tag
    - float in range [0..1]


###Methods

This class has the following methods

  - tf_idf: receive a term and the respective frequence in the doc and returns the tf-idf
```Smalltalk
tf-idf: aTerm withFrequence: aFrequence
  ^(aFrequence * self dict_idf(aTerm))
```

  - createDict_tf(aString): generates the dictionary of terms frequency of the document aString
```Smalltalk
createDictTf: aString
  	|aBag aDictTf|
	
  	" convert aString to an Bag of tokens"
  	aBag := self preprocess: aString.

  	" calculates number of ocourrences of each token"
  	aDictTf := self countIn: aBag.

  	"TODO:
		 remove from aDictTf token with frequence out of the interval [min_tf, max_tf]
  	"

   	^aDictTf
```
  - createDictIdf: aStringCollection
    - defines the dict_idf for the given collection

```Smalltalk
createDictIdf: aStringCollection
  	|numDocuments dictDf aBag|
  	numDocuments := aStringCollection size.
  	dictDf := Dictionary new.
	
  	"gera o dicionario de frequencias de cada documento "
  	aStringCollection do: [ :aElement |
		aBag := self  preprocess: aElement.
		aBag asSet do: [ :token |
      		dictDf at: token put: ((dictIdf at: token) + 1)
		]
    	].

  	"converte dict_df into a Inverse Document Frequency dictionary"
  	dictIdf := Dictionary new.
  	dictDf keysAndValuesDo: [ :token :freq |
    		dictIdf at: token put: ((freq / numDocuments) log)
  	].
```

  - tokenizer(aString): returns a collection of tokens
    - splits the string
```Smalltalk
tokenizer: aString
  	|aBag|
	"this method split aString and return a Bag of tokens"
	
	"we decide to use a Bag, once the order of the tokens doesn't matter"
	aBag := (aString subStrings) asBag.
	^aBag.
```

  - preprocess: anArray (must be better defined)
    - receives an Array of tokens
    - optional
      - may remove common words
      - capitalize tokens
      - may do stemming and lemmatization
```Smalltalk
preprocess: aString
  | aBag |
  "this method realizes comom preprocess methods over the String
	1- tokenizes the String 
    - may remove common words
    - capitalize tokens
    - may do stemming and lemmatization
	anArray := self tokenizer: aS. 
  "
	aBag := self tokenizer: aString. 
	
	
	^aBag
```

  - getMoreRelevantsOf: aString
    - generate tags to aElement
```Smalltalk
getMoreRelevantsOf: aString
 
	|dictTf tfIdfDict tfidf|

	"TODO check if dictIdf is not empty
	in this case raise error
		message: dictIdf is Empty, make shure of call 'training' before call this method
	"
  	dictTf :=  self createDictTf: aString.
  	"calcula o tfidf de cada termo de aDict"
  	tfIdfDict := Dictionary new.
  	dictTf keysAndValuesDo: [ :token :tf |
    		tfidf := self tfIdf: token withFrequence: tf.
   		 (tfidf > minRelevance)
			ifTrue: [
      			tfIdfDict at: token put: tf
    			]
  	].
  	^(tfIdfDict keys).
```

The methods training, addTagsTo and tagCollection are specialized to deal with GODData
```Smalltalk
training: aGODDataCollection
	|aStringCollection|
	
  	"it extacts the aGODDataCollection's contents"
	aStringCollection := Bag new.
  	aGODDataCollection do: [ :aElement |
		aStringCollection add: aElement content.
    	].
  	"it trains the algorithm with the given aGODDataCollection contents"
	self createDictIdf: aStringCollection.
```



  - addTagsTo: aGodData
    - generate tags to aGodData
```Smalltalk
addTagsTo: aGodData
	|tags|
	" Get most relevants tokens in aGodData and add it as tags of aGodData "
	tags := self getMoreRelevantsOf: aGodData content.
	aGodData tags: tags.
```

  - tagCollection: aCollection
    - generate tags to all elements of aCollection
```Smalltalk
tagCollection: aGODDataCollection

  self training: aGODDataCollection.
  aGODDataCollection do: [ :element |
    self addTagsTo: element
  ].
```
###How to use

####To tag all element of a collection
```Smalltalk
pcsTagger = PCSTagger new.
pcsTagger.tagCollection: aGODDataCollection.
```
####To tag an element
```Smalltalk
pcsTagger = PCSTagger new.
pcsTagger.training: aGODDataCollection.
pcsTagger.addTagsTo: aGODData.
```


###TODO

- [ ] Criar um método para configurar os parametros de treinamento;
- [ ] Criar um método de inicialização da classe que define a configuração padrão dos parâmetros;
- [ ] Em createDictTf, remover os tokens que estejam fora do intervalo desejado;
- [ ] Em getMoreRelevant precisamos checar se o dicionário de idf esta vazio;
- [ ] Ao realizar o treinamento excluit o dictIdf antigo (createDictIdf);
- [ ] Checar a necessidade de adicionar 1 objeto a um conjunto já treinado, nesse caso pensar em como fazer isso.
- [ ] Verificar o caso em que tentamos taggear um objeto que não participou do treinamento e que possui um token distinto.
- [ ] Em 'getMoreRelevantsOf' realizar uma normalização do tf-idf calculados, para posteriormente poder retornar apenas aqueles com relevância maior que minRelevance
