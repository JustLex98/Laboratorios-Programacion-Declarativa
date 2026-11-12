#lang racket

(define (calcular-interes deposito)
  (cond
    [(<= deposito 40000) (* deposito 0.035)]
    [(<= deposito 260000) (* deposito 0.04)]
    [else (* deposito 0.045)]))

(calcular-interes 30000)
; Resultado: 1050

(calcular-interes 100000)
; Resultado: 4000

(calcular-interes 300000)
; Resultado: 13500