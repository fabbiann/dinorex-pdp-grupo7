"
Carga las imagenes PNG desde la carpeta sprites y las conserva en memoria para reutilizarlas rapidamente; si falta una imagen, el juego dibuja un rectangulo.
"
Class {
	#name : 'DxSprites',
	#superclass : 'Object',
	#instVars : [
		'imagenes'
	],
	#classInstVars : [
		'actual'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acceso' }
DxSprites class >> actual [
	actual ifNil: [ actual := self new ].
	^ actual
]

{ #category : 'acceso' }
DxSprites class >> reiniciarActual [
	actual := self new.
]

{ #category : 'consultas' }
DxSprites >> carpetaSprites [
	^ FileSystem workingDirectory / 'sprites'
]

{ #category : 'acceso' }
DxSprites >> imagenCompletaNombrada: unNombre [
	"Carga un PNG completo sin recortar bordes (ideal para fondos y texturas de suelo)."
	^ imagenes at: ('completo_', unNombre) ifAbsentPut: [
		| archivo |
		archivo := self carpetaSprites / (unNombre, '.png').
		archivo exists
			ifTrue: [ ImageReadWriter formFromFileNamed: archivo fullName ]
			ifFalse: [ nil ] ]
]

{ #category : 'acceso' }
DxSprites >> imagenCompletaNombrada: unNombre escaladaA: unPunto [
	"Devuelve la imagen completa ya escalada y guardada en caché para dibujar sin lag."
	| clave |
	clave := 'esc_', unNombre, '_', unPunto x asString, 'x', unPunto y asString.
	^ imagenes at: clave ifAbsentPut: [
		| base |
		base := self imagenCompletaNombrada: unNombre.
		base ifNotNil: [ base scaledToSize: unPunto ] ]
]

{ #category : 'acceso' }
DxSprites >> imagenNombrada: unNombre [
	"Carga el PNG y recorta los bordes vacíos tomando el color de la esquina (0@0) como fondo."
	^ imagenes at: unNombre ifAbsentPut: [
		| archivo form colorFondo bordes |
		archivo := self carpetaSprites / (unNombre, '.png').
		archivo exists
			ifTrue: [
				form := ImageReadWriter formFromFileNamed: archivo fullName.
				colorFondo := form colorAt: 0 @ 0.
				bordes := form rectangleEnclosingPixelsNotOfColor: colorFondo.
				(bordes width > 0 and: [ bordes height > 0 ])
					ifTrue: [ form copy: bordes ]
					ifFalse: [ form ] ]
			ifFalse: [ nil ] ]
]

{ #category : 'inicializacion' }
DxSprites >> initialize [
	super initialize.
	imagenes := Dictionary new.
]

{ #category : 'acceso' }
DxSprites >> spriteRecortado: unNombre escaladoA: unPunto [
	"Devuelve el sprite recortado ya escalado y guardado en caché para dibujar a 50 FPS."
	| clave |
	clave := 'rec_', unNombre, '_', unPunto x asString, 'x', unPunto y asString.
	^ imagenes at: clave ifAbsentPut: [
		| base |
		base := self imagenNombrada: unNombre.
		base ifNotNil: [ base scaledToSize: unPunto ] ]
]
