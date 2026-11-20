"
Punto de entrada principal del juego. El mensaje de clase jugar abre la ventana de DINOREX.
"
Class {
	#name : 'Dinorex',
	#superclass : 'Object',
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acceso' }
Dinorex class >> jugar [
	| juego |
	DxSprites actual
		imagenCompletaNombrada: 'fondo_menu'
		escaladaA: (DxConfiguracion anchoPantalla @ DxConfiguracion altoPantalla).
	juego := DxJuego new.
	juego openInWindowLabeled: 'DINOREX'.
	^ juego
]
