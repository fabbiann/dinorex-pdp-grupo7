"
Maneja las opciones del menu principal (COMENZAR JUEGO, BORRAR RANKING, SALIR) y dibuja la portada junto con el Top 3.
"
Class {
	#name : 'DxMenu',
	#superclass : 'Object',
	#instVars : [
		'opciones',
		'opcionElegida'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxMenu >> bajar [
	opcionElegida := opcionElegida + 1.
	opcionElegida > opciones size ifTrue: [ opcionElegida := 1 ].
]

{ #category : 'acciones' }
DxMenu >> clicEn: unPuntoRelativo juego: unJuego [
	| indice |
	indice := self opcionEnPunto: unPuntoRelativo.
	indice > 0 ifTrue: [
		opcionElegida := indice.
		self elegirEn: unJuego ].
]

{ #category : 'dibujo' }
DxMenu >> dibujarEn: unCanvas origen: puntoOrigen [
	| fondoMenu fuenteTitulo registrosTop posY panelRanking |
	fondoMenu := DxSprites actual imagenCompletaNombrada: 'fondo_menu' escaladaA: (880 @ 495).
	fondoMenu ifNotNil: [
		unCanvas drawImage: fondoMenu at: puntoOrigen ].

	fuenteTitulo := LogicalFont familyName: 'Source Sans Pro' pointSize: 38.
	unCanvas
		drawString: 'DINOREX'
		at: puntoOrigen + (348 @ 33)
		font: fuenteTitulo
		color: (Color black alpha: 0.45).
	unCanvas
		drawString: 'DINOREX'
		at: puntoOrigen + (345 @ 30)
		font: fuenteTitulo
		color: (Color r: 0.10 g: 0.45 b: 0.12).

	1 to: opciones size do: [ :i |
		| rect texto colorFondo colorTexto |
		rect := (self rectanguloOpcion: i) translateBy: puntoOrigen.
		texto := opciones at: i.
		i = opcionElegida
			ifTrue: [
				colorFondo := (texto = 'BORRAR RANKING')
					ifTrue: [ Color r: 0.80 g: 0.22 b: 0.20 ]
					ifFalse: [ Color green darker ].
				colorTexto := Color white ]
			ifFalse: [
				colorFondo := (Color white alpha: 0.88).
				colorTexto := Color black ].
		unCanvas fillRectangle: rect color: colorFondo.
		unCanvas frameRectangle: rect width: 2 color: (Color black alpha: 0.5).
		unCanvas
			drawString: texto
			at: rect origin + (70 @ 10)
			font: StandardFonts defaultFont
			color: colorTexto ].

	panelRanking := (puntoOrigen + (290 @ 265)) extent: (300 @ 110).
	unCanvas fillRectangle: panelRanking color: (Color white alpha: 0.85).
	unCanvas frameRectangle: panelRanking width: 1 color: (Color black alpha: 0.35).

	unCanvas
		drawString: 'TOP 3 MEJORES PUNTAJES'
		at: puntoOrigen + (355 @ 275)
		font: StandardFonts defaultFont
		color: Color green muchDarker.

	registrosTop := DxRanking actual registros.
	registrosTop isEmpty
		ifTrue: [
			unCanvas
				drawString: 'Todavia no hay puntajes guardados'
				at: puntoOrigen + (335 @ 305)
				font: StandardFonts defaultFont
				color: Color darkGray ]
		ifFalse: [
			posY := 302.
			1 to: registrosTop size do: [ :i |
				| reg linea |
				reg := registrosTop at: i.
				linea := i asString, '. ', (reg at: #nombre), ' - ', (reg at: #puntaje) asString, ' pts'.
				unCanvas
					drawString: linea
					at: puntoOrigen + (370 @ posY)
					font: StandardFonts defaultFont
					color: Color black.
				posY := posY + 20 ] ].

	unCanvas
		drawString: 'Usa FLECHAS + ENTER o hace CLIC para elegir'
		at: puntoOrigen + (295 @ 455)
		font: StandardFonts defaultFont
		color: Color white.
]

{ #category : 'acciones' }
DxMenu >> elegirEn: unJuego [
	| elegida |
	elegida := self opcionActual.
	elegida = 'COMENZAR JUEGO' ifTrue: [ unJuego iniciarPartida ].
	elegida = 'BORRAR RANKING' ifTrue: [
		(UIManager default confirm: '¿Seguro que queres borrar el historial del Top 3?') ifTrue: [
			DxRanking actual limpiar.
			unJuego changed ] ].
	elegida = 'SALIR' ifTrue: [ unJuego cerrarJuego ].
]

{ #category : 'inicializacion' }
DxMenu >> initialize [
	super initialize.
	opciones := #('COMENZAR JUEGO' 'BORRAR RANKING' 'SALIR').
	opcionElegida := 1.
]

{ #category : 'consultas' }
DxMenu >> opcionActual [
	^ opciones at: opcionElegida
]

{ #category : 'consultas' }
DxMenu >> opcionEnPunto: unPuntoRelativo [
	"Devuelve el índice de la opción si se hizo clic encima, o 0 si fue afuera"
	1 to: opciones size do: [ :i |
		((self rectanguloOpcion: i) containsPoint: unPuntoRelativo) ifTrue: [ ^ i ] ].
	^ 0
]

{ #category : 'consultas' }
DxMenu >> rectanguloOpcion: indice [
	"Centrado horizontalmente en 880 px (x = 300, ancho = 280)"
	^ (300 @ (115 + ((indice - 1) * 44))) extent: (280 @ 36)
]

{ #category : 'acciones' }
DxMenu >> subir [
	opcionElegida := opcionElegida - 1.
	opcionElegida < 1 ifTrue: [ opcionElegida := opciones size ].
]
