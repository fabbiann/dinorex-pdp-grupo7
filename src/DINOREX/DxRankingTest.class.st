Class {
	#name : 'DxRankingTest',
	#superclass : 'TestCase',
	#instVars : [
		'registros'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'tests' }
DxRankingTest >> testGuardarYCargarDesdeArchivo [
	| ranking1 ranking2 |
	ranking1 := DxRanking new.
	ranking1 limpiar.
	ranking1 agregarNombre: 'Carla' puntaje: 420.
	ranking1 agregarNombre: 'Mateo' puntaje: 180.

	ranking2 := DxRanking new.
	ranking2 cargarDesdeArchivo.
	self assert: ranking2 registros size equals: 2.
	self assert: (ranking2 registros first at: #nombre) equals: 'Carla'.
	self assert: (ranking2 registros first at: #puntaje) equals: 420.
	self assert: (ranking2 registros second at: #nombre) equals: 'Mateo'.
	ranking1 limpiar.
]

{ #category : 'pruebas' }
DxRankingTest >> testSuperarElTercerPuestoReemplazaAlUltimo [
	| ranking |
	ranking := DxRanking new.
	ranking agregarNombre: 'Ana' puntaje: 100.
	ranking agregarNombre: 'Luis' puntaje: 300.
	ranking agregarNombre: 'Sol' puntaje: 200.
	self assert: (ranking esRecord: 150).
	ranking agregarNombre: 'Max' puntaje: 150.
	self assert: ranking registros size equals: 3.
	self assert: (ranking registros third at: #nombre) equals: 'Max'.
	self assert: (ranking registros third at: #puntaje) equals: 150.
]

{ #category : 'pruebas' }
DxRankingTest >> testTop3OrdenadoYDescartaElCuarto [
	| ranking |
	ranking := DxRanking new.
	ranking agregarNombre: 'Ana' puntaje: 100.
	ranking agregarNombre: 'Luis' puntaje: 300.
	ranking agregarNombre: 'Sol' puntaje: 200.
	ranking agregarNombre: 'Pepe' puntaje: 50.
	self assert: ranking registros size equals: 3.
	self assert: (ranking registros first at: #nombre) equals: 'Luis'.
	self assert: (ranking registros second at: #nombre) equals: 'Sol'.
	self assert: (ranking registros third at: #nombre) equals: 'Ana'.
]
