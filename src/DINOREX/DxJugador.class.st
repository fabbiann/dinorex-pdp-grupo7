"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxJugador',
	#superclass : 'Object',
	#instVars : [
		'nombre',
		'puntuacion'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'initialize' }
DxJugador >> initialize [
	super initialize.
	nombre := 'Jugador'.
	puntuacion := 0.
]

{ #category : 'acceso' }
DxJugador >> nombre [
	^ nombre
]

{ #category : 'acceso' }
DxJugador >> nombre: unTexto [
	nombre := unTexto.
]

{ #category : 'acceso' }
DxJugador >> puntuacion [
	^ puntuacion
]

{ #category : 'acciones' }
DxJugador >> reiniciar [
	puntuacion := 0.
]

{ #category : 'acciones' }
DxJugador >> sumarPuntos: cantidad [
	puntuacion := puntuacion + cantidad.
]
