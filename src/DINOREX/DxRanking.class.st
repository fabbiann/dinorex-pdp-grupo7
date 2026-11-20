"
Administra el historial de los 3 mejores puntajes y los guarda en un archivo de texto para que persistan entre sesiones.
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
			| linea partes textoPuntaje |
			linea := stream nextLine.
			linea isEmpty ifFalse: [
				partes := linea splitOn: $;.
				partes size = 2 ifTrue: [
					textoPuntaje := partes second trimBoth.
					(textoPuntaje notEmpty and: [ textoPuntaje allSatisfy: #isDigit ]) ifTrue: [
						registros add: (Dictionary new
							at: #nombre put: partes first;
							at: #puntaje put: textoPuntaje asInteger;
							yourself) ] ] ] ] ].
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
	"Escribe el Top 3 en un archivo de texto, una linea por jugador con formato nombre;puntaje"
	self archivoRanking writeStreamDo: [ :stream |
		stream truncate.
		registros do: [ :cadaRegistro |
			| nombreLimpio |
			nombreLimpio := (cadaRegistro at: #nombre) copyReplaceAll: ';' with: ' '.
			stream
				nextPutAll: nombreLimpio;
				nextPut: $;;
				nextPutAll: (cadaRegistro at: #puntaje) asString;
				lf ] ].
]

{ #category : 'inicializacion' }
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
