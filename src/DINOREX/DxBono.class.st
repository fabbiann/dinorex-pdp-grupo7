"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxBono',
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
DxBono >> actualizar [
	x := x - velocidad.
]

{ #category : 'acciones' }
DxBono >> aplicarA: unDinosaurio [
	self subclassResponsibility
]

{ #category : 'dibujo' }
DxBono >> dibujarEn: unCanvas origen: puntoOrigen [
	| rectangulo |
	rectangulo := (puntoOrigen + (x @ y)) extent: (ancho @ alto).
	unCanvas fillRectangle: rectangulo color: Color yellow.
]

{ #category : 'consultas' }
DxBono >> estaFuera [
	^ (x + ancho) < 0
]

{ #category : 'initialize' }
DxBono >> initialize [
	super initialize.
	ancho := 26.
	alto := 26.
	velocidad := 8.
	x := 880.
	y := 315.
]

{ #category : 'consultas' }
DxBono >> rectanguloDeChoque [
	^ (x @ y) extent: (ancho @ alto)
]

{ #category : 'acceso' }
DxBono >> velocidad: unNumero [
	velocidad := unNumero.
]
