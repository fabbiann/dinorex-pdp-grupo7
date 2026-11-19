"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxRanking',
	#superclass : 'Object',
	#instVars : [
		'registros'
	],
	#classInstVars : [
		'actual'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acceso' }
DxRanking class >> actual [
	actual ifNil: [
		actual := self new.
		actual cargarDesdeArchivo ].
	^ actual
]

{ #category : 'acceso' }
DxRanking class >> reiniciarActual [
	actual := self new.
]

{ #category : 'acciones' }
DxRanking >> agregarNombre: unNombre puntaje: unPuntaje [
	"Agrega el registro si es récord, ordena de mayor a menor, recorta a 3 y guarda en archivo"
	(self esRecord: unPuntaje) ifFalse: [ ^ self ].
	registros add: (Dictionary new
		at: #nombre put: unNombre;
		at: #puntaje put: unPuntaje;
		yourself).
	registros := registros asSortedCollection: [ :a :b |
		(a at: #puntaje) >= (b at: #puntaje) ].
	registros := registros asOrderedCollection.
	registros size > 3 ifTrue: [
		registros := registros first: 3 ].
	self guardarEnArchivo.
]

{ #category : 'consultas' }
DxRanking >> archivoRanking [
	"Devuelve la referencia al archivo de texto en la carpeta de trabajo"
	^ FileSystem workingDirectory / 'dinorex_ranking.txt'
]

{ #category : 'acciones' }
DxRanking >> cargarDesdeArchivo [
	"Lee el archivo de ranking si existe y reconstruye la lista ordenada del Top 3"
	| archivo |
	registros := OrderedCollection new.
	archivo := self archivoRanking.
	archivo exists ifFalse: [ ^ self ].
	archivo readStreamDo: [ :stream |
		[ stream atEnd ] whileFalse: [
			| linea partes |
			linea := stream nextLine.
			linea isEmpty ifFalse: [
				partes := linea splitOn: $;.
				partes size = 2 ifTrue: [
					registros add: (Dictionary new
						at: #nombre put: partes first;
						at: #puntaje put: partes second asInteger;
						yourself) ] ] ] ].
]

{ #category : 'consultas' }
DxRanking >> esRecord: unPuntaje [
	"Devuelve true si el puntaje es mayor a 0 y entra en el Top 3"
	unPuntaje <= 0 ifTrue: [ ^ false ].
	registros size < 3 ifTrue: [ ^ true ].
	^ unPuntaje > (registros last at: #puntaje)
]

{ #category : 'acciones' }
DxRanking >> guardarEnArchivo [
	"Escribe el Top 3 en un archivo de texto, una línea por jugador con formato nombre;puntaje"
	self archivoRanking writeStreamDo: [ :stream |
		stream truncate.
		registros do: [ :cadaRegistro |
			stream
				nextPutAll: (cadaRegistro at: #nombre);
				nextPut: $;;
				nextPutAll: (cadaRegistro at: #puntaje) asString;
				lf ] ].
]

{ #category : 'initialize' }
DxRanking >> initialize [
	super initialize.
	registros := OrderedCollection new.
]

{ #category : 'acciones' }
DxRanking >> limpiar [
	registros := OrderedCollection new.
	self guardarEnArchivo.
]

{ #category : 'acceso' }
DxRanking >> registros [
	^ registros
]
