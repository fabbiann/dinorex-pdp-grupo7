"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxObstaculo',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'ancho',
		'alto',
		'velocidad'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxObstaculo >> actualizar [
	x := x - velocidad.
]

{ #category : 'dibujo' }
DxObstaculo >> dibujarEn: unCanvas origen: puntoOrigen [
	| rectangulo |
	rectangulo := (puntoOrigen + (x @ y)) extent: (ancho @ alto).
	unCanvas fillRectangle: rectangulo color: Color red darker.
]

{ #category : 'acciones' }
DxObstaculo >> estaFuera [
	^ (x + ancho) < 0
]

{ #category : 'initialize' }
DxObstaculo >> initialize [
	super initialize.
	ancho := 30.
	alto := 45.
	velocidad := 8.
	x := 880.
	y := 400 - alto.
]

{ #category : 'consultas' }
DxObstaculo >> rectanguloDeChoque [
	^ (x @ y) extent: (ancho @ alto)
]

{ #category : 'acceso' }
DxObstaculo >> velocidad: unNumero [
	velocidad := unNumero.
]
