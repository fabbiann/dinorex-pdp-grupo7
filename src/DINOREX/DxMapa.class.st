"
Dibuja y desplaza continuamente el fondo del escenario y el suelo para dar sensacion de movimiento.
"
Class {
	#name : 'DxMapa',
	#superclass : 'Object',
	#instVars : [
		'ancho',
		'velocidad',
		'desplazamiento'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxMapa >> actualizar [
	desplazamiento := desplazamiento + velocidad.
]

{ #category : 'dibujo' }
DxMapa >> dibujarEn: unCanvas origen: puntoOrigen [
	| fondoSprite fondoEsc anchoTileFondo sueloSprite tileEsc posX |
	fondoSprite := DxSprites actual imagenCompletaNombrada: 'fondo'.
	fondoSprite
		ifNotNil: [
			anchoTileFondo := ((fondoSprite width * 400) // fondoSprite height) max: 1.
			fondoEsc := DxSprites actual imagenCompletaNombrada: 'fondo' escaladaA: (anchoTileFondo @ 400).
			posX := 0 - ((desplazamiento // 2) \\ anchoTileFondo).
			[ posX < ancho ] whileTrue: [
				unCanvas drawImage: fondoEsc at: puntoOrigen + (posX @ 0).
				posX := posX + anchoTileFondo ] ]
		ifNil: [
			unCanvas
				fillRectangle: (puntoOrigen extent: (ancho @ 400))
				color: (Color r: 0.96 g: 0.97 b: 0.99) ].

	sueloSprite := DxSprites actual imagenCompletaNombrada: 'suelo'.
	sueloSprite
		ifNotNil: [
			tileEsc := DxSprites actual imagenCompletaNombrada: 'suelo' escaladaA: (95 @ 115).
			posX := 0 - (desplazamiento \\ 95).
			[ posX < ancho ] whileTrue: [
				unCanvas drawImage: tileEsc at: puntoOrigen + (posX @ 400).
				posX := posX + 95 ] ]
		ifNil: [
			unCanvas
				fillRectangle: ((puntoOrigen + (0 @ 400)) extent: (ancho @ 115))
				color: (Color r: 0.92 g: 0.87 b: 0.76).
			unCanvas
				line: puntoOrigen + (0 @ 400)
				to: puntoOrigen + (ancho @ 400)
				width: 2
				color: (Color r: 0.55 g: 0.45 b: 0.30).
			posX := 0 - (desplazamiento \\ 40).
			[ posX < ancho ] whileTrue: [
				unCanvas
					line: puntoOrigen + (posX @ 416)
					to: puntoOrigen + ((posX + 14) @ 416)
					width: 2
					color: (Color r: 0.65 g: 0.55 b: 0.40).
				posX := posX + 40 ] ].
]

{ #category : 'inicializacion' }
DxMapa >> initialize [
	super initialize.
	ancho := 880.
	velocidad := 8.
	desplazamiento := 0.
]

{ #category : 'acceso' }
DxMapa >> velocidad: unNumero [
	velocidad := unNumero.
]
