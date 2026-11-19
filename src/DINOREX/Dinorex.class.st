"
Clase del proyecto Dinorex
"
Class {
	#name : 'Dinorex',
	#superclass : 'Object',
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'accessing' }
Dinorex class >> jugar [
	| juego |
	DxSprites actual imagenCompletaNombrada: 'fondo_menu' escaladaA: (880 @ 495).
	juego := DxJuego new.
	juego openInWindowLabeled: 'DINOREX'.
	^ juego
]
