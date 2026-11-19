"
Clase del proyecto Dinorex
"
Class {
	#name : 'DxGenerador',
	#superclass : 'Object',
	#instVars : [
		'contador',
		'proximoEn',
		'contadorBono',
		'proximoBonoEn'
	],
	#category : 'DINOREX',
	#package : 'DINOREX'
}

{ #category : 'acciones' }
DxGenerador >> actualizarBonosEn: listaBonos [
	contadorBono := contadorBono + 1.
	contadorBono >= proximoBonoEn ifTrue: [
		listaBonos add: self nuevoBono.
		contadorBono := 0.
		proximoBonoEn := self calcularProximoIntervaloBono ].
]

{ #category : 'acciones' }
DxGenerador >> actualizarEn: listaObstaculos [
	"Suma 1 tick; cuando llega al límite crea un cactus nuevo y reinicia el contador"
	contador := contador + 1.
	contador >= proximoEn ifTrue: [
		listaObstaculos add: self nuevoObstaculo.
		contador := 0.
		proximoEn := self calcularProximoIntervalo ].
]

{ #category : 'consultas' }
DxGenerador >> calcularProximoIntervalo [
	"Devuelve una cantidad aleatoria de ticks entre 45 y 95 (asegura distancia mínima entre cactus)"
	^ 45 + (50 atRandom)
]

{ #category : 'consultas' }
DxGenerador >> calcularProximoIntervaloBono [
	"Entre 250 y 450 ticks (~8 a 15 segundos), para que el corazón sea poco frecuente"
	^ 250 + (200 atRandom)
]

{ #category : 'initialize' }
DxGenerador >> initialize [
	super initialize.
	contador := 0.
	proximoEn := 10.
	contadorBono := 0.
	proximoBonoEn := self calcularProximoIntervaloBono.
]

{ #category : 'acciones' }
DxGenerador >> nuevoBono [
	^ DxCorazon new
]

{ #category : 'acciones' }
DxGenerador >> nuevoObstaculo [
	^ DxCactus new
]
