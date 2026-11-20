"
Obstaculo terrestre concreto que se desplaza por el suelo hacia el dinosaurio.
"
Class {
	#name : 'DxCactus',
	#superclass : 'DxObstaculo',
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'dibujo' }
DxCactus >> dibujarEn: unCanvas origen: puntoOrigen [
	| spriteEscalado posY rectangulo |
	spriteEscalado := DxSprites actual spriteRecortado: 'cactus' escaladoA: (34 @ 52).
	spriteEscalado
		ifNotNil: [
			posY := (y + alto) - spriteEscalado height.
			unCanvas
				translucentImage: spriteEscalado
				at: puntoOrigen + (x @ posY) ]
		ifNil: [
			rectangulo := (puntoOrigen + (x @ y)) extent: (ancho @ alto).
			unCanvas fillRectangle: rectangulo color: Color green muchDarker ].
]

{ #category : 'inicializacion' }
DxCactus >> initialize [
	super initialize.
	ancho := 28.
	alto := 48.
	y := 400 - alto.
]
