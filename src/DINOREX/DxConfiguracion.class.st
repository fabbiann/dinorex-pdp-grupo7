"
Centraliza las constantes del juego (dimensiones de pantalla, altura del suelo, vidas, invulnerabilidad y velocidades) para evitar valores repetidos en el codigo.
"
Class {
	#name : 'DxConfiguracion',
	#superclass : 'Object',
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'consultas' }
DxConfiguracion class >> altoPantalla [
	^ 495
]

{ #category : 'consultas' }
DxConfiguracion class >> alturaSuelo [
	^ 400
]

{ #category : 'consultas' }
DxConfiguracion class >> anchoPantalla [
	^ 880
]

{ #category : 'consultas' }
DxConfiguracion class >> ticksInvulnerabilidad [
	^ 60
]

{ #category : 'consultas' }
DxConfiguracion class >> velocidadInicial [
	^ 8
]

{ #category : 'consultas' }
DxConfiguracion class >> velocidadMaxima [
	^ 18
]

{ #category : 'consultas' }
DxConfiguracion class >> vidasIniciales [
	^ 3
]
