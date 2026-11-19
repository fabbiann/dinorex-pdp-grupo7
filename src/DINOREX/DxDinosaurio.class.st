"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxDinosaurio',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'ancho',
		'alto',
		'velocidadY',
		'enElSuelo',
		'vidas',
		'ticksInvulnerable',
		'ticksAnimacion'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxDinosaurio >> actualizar [
	ticksAnimacion := ticksAnimacion + 1.
	enElSuelo ifFalse: [
		y := y + velocidadY.
		velocidadY := velocidadY + 1.
		y >= self sueloY ifTrue: [
			y := self sueloY.
			velocidadY := 0.
			enElSuelo := true ] ].
	ticksInvulnerable > 0 ifTrue: [
		ticksInvulnerable := ticksInvulnerable - 1 ].
]

{ #category : 'dibujo' }
DxDinosaurio >> dibujarEn: unCanvas origen: puntoOrigen [
	| rectangulo debeDibujarse spriteEscalado posY |
	debeDibujarse := self estaInvulnerable not
		or: [ (ticksInvulnerable // 5) even ].
	debeDibujarse ifTrue: [
		spriteEscalado := self spriteActual.
		spriteEscalado
			ifNotNil: [
				posY := (y + alto) - spriteEscalado height.
				unCanvas
					translucentImage: spriteEscalado
					at: puntoOrigen + (x @ posY) ]
			ifNil: [
				rectangulo := (puntoOrigen + (x @ y)) extent: (ancho @ alto).
				unCanvas fillRectangle: rectangulo color: Color green darker ] ].
]

{ #category : 'consultas' }
DxDinosaurio >> estaInvulnerable [
	^ ticksInvulnerable > 0
]

{ #category : 'consultas' }
DxDinosaurio >> estaVivo [
	^ vidas > 0
]

{ #category : 'acciones' }
DxDinosaurio >> ganarVida [
	"Recupera 1 vida sin superar el máximo de 3"
	vidas < 3 ifTrue: [
		vidas := vidas + 1 ].
]

{ #category : 'initialize' }
DxDinosaurio >> initialize [
	super initialize.
	ancho := 40.
	alto := 50.
	x := 80.
	y := self sueloY.
	velocidadY := 0.
	enElSuelo := true.
	vidas := 3.
	ticksInvulnerable := 0.
	ticksAnimacion := 0.
]

{ #category : 'acciones' }
DxDinosaurio >> perderVida [
	"Resta 1 vida si no es invulnerable y activa 2 segundos (60 ticks) de protección"
	self estaInvulnerable ifFalse: [
		vidas > 0 ifTrue: [
			vidas := vidas - 1.
			ticksInvulnerable := 60 ] ].
]

{ #category : 'consultas' }
DxDinosaurio >> rectanguloDeChoque [
	^ (x @ y) extent: (ancho @ alto)
]

{ #category : 'acciones' }
DxDinosaurio >> saltar [
	"Solo salta si está apoyado en el suelo"
	enElSuelo ifTrue: [
		velocidadY := -16.
		enElSuelo := false ].
]

{ #category : 'consultas' }
DxDinosaurio >> spriteActual [
	| nombreSprite |
	enElSuelo
		ifFalse: [ nombreSprite := 'dino_saltar' ]
		ifTrue: [
			nombreSprite := ((ticksAnimacion // 6) even)
				ifTrue: [ 'dino_correr1' ]
				ifFalse: [ 'dino_correr2' ] ].
	^ DxSprites actual spriteRecortado: nombreSprite escaladoA: (48 @ 54)
]

{ #category : 'consultas' }
DxDinosaurio >> sueloY [
	^ 400 - alto
]

{ #category : 'consultas' }
DxDinosaurio >> vidas [
	^ vidas
]
