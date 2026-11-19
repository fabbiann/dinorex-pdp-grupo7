"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxJuego',
	#superclass : 'Morph',
	#instVars : [
		'ticksTransicion',
		'ticks',
		'dinosaurio',
		'mapa',
		'obstaculos',
		'generador',
		'jugador',
		'estado',
		'menu',
		'bonos'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxJuego >> cerrarJuego [
	self stopStepping.
	self owner
		ifNotNil: [ self owner delete ]
		ifNil: [ self delete ].
]

{ #category : 'dibujo' }
DxJuego >> drawOn: aCanvas [
	super drawOn: aCanvas.
	estado = #menu ifTrue: [
		menu dibujarEn: aCanvas origen: self position.
		^ self ].

	mapa dibujarEn: aCanvas origen: self position.
	obstaculos do: [ :cadaUno | cadaUno dibujarEn: aCanvas origen: self position ].
	bonos do: [ :cadaBono | cadaBono dibujarEn: aCanvas origen: self position ].
	dinosaurio dibujarEn: aCanvas origen: self position.

	aCanvas
		drawString: 'Vidas: ', dinosaurio vidas asString
		at: self position + (20 @ 20)
		font: StandardFonts defaultFont
		color: Color black.
	aCanvas
		drawString: 'Puntaje: ', jugador puntuacion asString
		at: self position + (730 @ 20)
		font: StandardFonts defaultFont
		color: Color black.

	estado = #transicion ifTrue: [
		| offsetBarrido anchoRestante |
		offsetBarrido := (ticksTransicion * 110) min: 880.
		anchoRestante := 880 - offsetBarrido.
		anchoRestante > 0 ifTrue: [
			aCanvas
				fillRectangle: ((self position + (offsetBarrido @ 0)) extent: (anchoRestante @ 495))
				color: (Color r: 0.96 g: 0.78 b: 0.35 alpha: 0.85) ].
		^ self ].

	estado = #fin ifTrue: [
		aCanvas
			drawString: 'GAME OVER'
			at: self position + (390 @ 180)
			font: StandardFonts defaultFont
			color: Color red.
		aCanvas
			drawString: 'Puntaje final: ', jugador puntuacion asString, ' | Presiona ENTER para volver al menu'
			at: self position + (280 @ 210)
			font: StandardFonts defaultFont
			color: Color black ].
]

{ #category : 'acciones' }
DxJuego >> finalizarPartida [
	| puntajeFinal nombreIngresado |
	estado := #fin.
	self stopStepping.
	self changed.
	puntajeFinal := jugador puntuacion.
	(DxRanking actual esRecord: puntajeFinal) ifTrue: [
		nombreIngresado := UIManager default
			request: 'Nuevo record (', puntajeFinal asString, ' pts)! Ingresa tu nombre:'
			initialAnswer: 'Jugador'.
		(nombreIngresado notNil and: [ nombreIngresado trimBoth isEmpty not ]) ifTrue: [
			jugador nombre: nombreIngresado trimBoth.
			DxRanking actual agregarNombre: jugador nombre puntaje: puntajeFinal.
			self changed ] ].
]

{ #category : 'teclado' }
DxJuego >> handlesKeyboard: anEvent [
	^ true
]

{ #category : 'teclado' }
DxJuego >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'acciones' }
DxJuego >> iniciarPartida [
	| primerCactus |
	estado := #transicion.
	ticks := 0.
	ticksTransicion := 0.
	jugador reiniciar.
	dinosaurio := DxDinosaurio new.
	mapa := DxMapa new.
	obstaculos := OrderedCollection new.
	primerCactus := DxCactus new.
	obstaculos add: primerCactus.
	bonos := OrderedCollection new.
	generador := DxGenerador new.
	self startStepping.
]

{ #category : 'initialize' }
DxJuego >> initialize [
	super initialize.
	estado := #menu.
	menu := DxMenu new.
	ticks := 0.
	ticksTransicion := 0.
	jugador := DxJugador new.
	dinosaurio := DxDinosaurio new.
	mapa := DxMapa new.
	obstaculos := OrderedCollection new.
	bonos := OrderedCollection new.
	generador := DxGenerador new.
	self extent: 880 @ 495.
	self color: (Color r: 0.25 g: 0.14 b: 0.12).
]

{ #category : 'initialize' }
DxJuego >> intoWorld: aWorld [
	super intoWorld: aWorld.
	self startStepping.
	self takeKeyboardFocus.
]

{ #category : 'dibujo' }
DxJuego >> isOpaque [
	"Le avisa a Morphic que el fondo es sólido y no hace falta redibujar lo que hay detrás"
	^ true
]

{ #category : 'teclado' }
DxJuego >> keyDown: anEvent [
	| tecla esEnter esArriba esAbajo esSalto |
	tecla := anEvent keyValue.
	esEnter := tecla = 13 or: [ anEvent key name = #RETURN or: [ anEvent key name = #KP_ENTER ] ].
	esArriba := tecla = 30 or: [ anEvent key name = #UP ].
	esAbajo := tecla = 31 or: [ anEvent key name = #DOWN ].
	esSalto := tecla = 32 or: [ esArriba ].

	estado = #menu ifTrue: [
		esArriba ifTrue: [ menu subir. self changed ].
		esAbajo ifTrue: [ menu bajar. self changed ].
		esEnter ifTrue: [ menu elegirEn: self ].
		^ self ].

	estado = #jugando ifTrue: [
		esSalto ifTrue: [ dinosaurio saltar ].
		^ self ].

	estado = #fin ifTrue: [
		esEnter ifTrue: [ self volverAlMenu ] ].
]

{ #category : 'teclado' }
DxJuego >> mouseDown: anEvent [
	self takeKeyboardFocus.
	estado = #menu ifTrue: [
		menu clicEn: (anEvent position - self position) juego: self ].
]

{ #category : 'ciclo del juego' }
DxJuego >> step [
	| vel |
	estado = #transicion ifTrue: [
		ticksTransicion := ticksTransicion + 1.
		mapa actualizar.
		dinosaurio actualizar.
		obstaculos do: [ :cadaUno | cadaUno actualizar ].
		ticksTransicion >= 8 ifTrue: [
			estado := #jugando ].
		self changed.
		^ self ].

	estado = #jugando ifFalse: [ ^ self ].
	ticks := ticks + 1.
	vel := self velocidadActual.
	mapa velocidad: vel.
	mapa actualizar.
	dinosaurio actualizar.
	generador actualizarEn: obstaculos.
	generador actualizarBonosEn: bonos.
	obstaculos do: [ :cadaUno |
		cadaUno velocidad: vel.
		cadaUno actualizar ].
	bonos do: [ :cadaBono |
		cadaBono velocidad: vel.
		cadaBono actualizar ].
	self verificarChoques.
	self verificarBonos.
	obstaculos removeAllSuchThat: [ :cadaUno | cadaUno estaFuera ].
	bonos removeAllSuchThat: [ :cadaBono | cadaBono estaFuera ].
	dinosaurio estaVivo
		ifTrue: [
			(ticks \\ 3) = 0 ifTrue: [ jugador sumarPuntos: 1 ] ]
		ifFalse: [
			self finalizarPartida ].
	self changed.
]

{ #category : 'ciclo del juego' }
DxJuego >> stepTime [
	"20 ms = ~50 cuadros por segundo para un movimiento más fluido"
	^ 20
]

{ #category : 'consultas' }
DxJuego >> velocidadActual [
	"Arranca en 8 y sube 1 por cada 100 puntos, con tope en 18"
	^ (8 + (jugador puntuacion // 100)) min: 18
]

{ #category : 'acciones' }
DxJuego >> verificarBonos [
	| rectDino recogidos |
	rectDino := dinosaurio rectanguloDeChoque.
	recogidos := bonos select: [ :cadaBono |
		rectDino intersects: cadaBono rectanguloDeChoque ].
	recogidos do: [ :cadaBono |
		cadaBono aplicarA: dinosaurio ].
	bonos removeAll: recogidos.
]

{ #category : 'acciones' }
DxJuego >> verificarChoques [
	| rectDino |
	dinosaurio estaInvulnerable ifTrue: [ ^ self ].
	rectDino := dinosaurio rectanguloDeChoque.
	obstaculos do: [ :cadaObstaculo |
		(rectDino intersects: cadaObstaculo rectanguloDeChoque) ifTrue: [
			dinosaurio perderVida.
			^ self ] ].
]

{ #category : 'acciones' }
DxJuego >> volverAlMenu [
	estado := #menu.
	self stopStepping.
	self changed.
]
