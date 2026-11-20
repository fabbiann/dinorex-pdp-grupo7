"
Ventana principal del juego (hereda de Morph). Dibuja la escena, recibe teclado y mouse, y coordina los estados menu, transicion, jugando y fin.
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
DxJuego >> drawOn: unCanvas [
	super drawOn: unCanvas.
	estado = #menu ifTrue: [
		menu dibujarEn: unCanvas origen: self position.
		^ self ].

	mapa dibujarEn: unCanvas origen: self position.
	obstaculos do: [ :cadaUno | cadaUno dibujarEn: unCanvas origen: self position ].
	bonos do: [ :cadaBono | cadaBono dibujarEn: unCanvas origen: self position ].
	dinosaurio dibujarEn: unCanvas origen: self position.

	unCanvas
		drawString: 'Vidas: ', dinosaurio vidas asString
		at: self position + (20 @ 20)
		font: StandardFonts defaultFont
		color: Color black.
	unCanvas
		drawString: 'Puntaje: ', jugador puntuacion asString
		at: self position + (730 @ 20)
		font: StandardFonts defaultFont
		color: Color black.

	estado = #transicion ifTrue: [
		| anchoPantalla offsetBarrido anchoRestante |
		anchoPantalla := DxConfiguracion anchoPantalla.
		offsetBarrido := (ticksTransicion * (anchoPantalla // 8)) min: anchoPantalla.
		anchoRestante := anchoPantalla - offsetBarrido.
		anchoRestante > 0 ifTrue: [
			unCanvas
				fillRectangle: ((self position + (offsetBarrido @ 0)) extent: (anchoRestante @ DxConfiguracion altoPantalla))
				color: (Color r: 0.96 g: 0.78 b: 0.35 alpha: 0.85) ].
		^ self ].

	estado = #fin ifTrue: [
		unCanvas
			drawString: 'GAME OVER'
			at: self position + (390 @ 180)
			font: StandardFonts defaultFont
			color: Color red.
		unCanvas
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
DxJuego >> handlesKeyboard: unEvento [
	^ true
]

{ #category : 'teclado' }
DxJuego >> handlesMouseDown: unEvento [
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

{ #category : 'inicializacion' }
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
	self extent: (DxConfiguracion anchoPantalla @ DxConfiguracion altoPantalla).
	self color: Color white.
]

{ #category : 'ciclo del juego' }
DxJuego >> intoWorld: unMundo [
	super intoWorld: unMundo.
	self startStepping.
	self takeKeyboardFocus.

]

{ #category : 'dibujo' }
DxJuego >> isOpaque [
	"Le avisa a Morphic que el fondo es sólido y no hace falta redibujar lo que hay detrás"
	^ true
]

{ #category : 'teclado' }
DxJuego >> keyDown: unEvento [
	| tecla esEnter esArriba esAbajo esSalto |
	tecla := unEvento keyValue.
	esEnter := tecla = 13 or: [ unEvento key name = #RETURN or: [ unEvento key name = #KP_ENTER ] ].
	esArriba := tecla = 30 or: [ unEvento key name = #UP ].
	esAbajo := tecla = 31 or: [ unEvento key name = #DOWN ].
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
DxJuego >> mouseDown: unEvento [
	self takeKeyboardFocus.
	estado = #menu ifTrue: [
		menu clicEn: (unEvento position - self position) juego: self ].
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
	^ (DxConfiguracion velocidadInicial + (jugador puntuacion // 100)) min: DxConfiguracion velocidadMaxima
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
