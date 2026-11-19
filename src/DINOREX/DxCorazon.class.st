"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxCorazon',
	#superclass : 'DxBono',
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxCorazon >> aplicarA: unDinosaurio [
	unDinosaurio ganarVida.
]

{ #category : 'dibujo' }
DxCorazon >> dibujarEn: unCanvas origen: puntoOrigen [
	| spriteEscalado rectangulo |
	spriteEscalado := DxSprites actual spriteRecortado: 'corazon' escaladoA: (26 @ 26).
	spriteEscalado
		ifNotNil: [
			unCanvas
				translucentImage: spriteEscalado
				at: puntoOrigen + (x @ y) ]
		ifNil: [
			rectangulo := (puntoOrigen + (x @ y)) extent: (ancho @ alto).
			unCanvas fillRectangle: rectangulo color: Color red.
			unCanvas
				drawString: '+'
				at: rectangulo origin + (8 @ 4)
				font: StandardFonts defaultFont
				color: Color white ].
]
