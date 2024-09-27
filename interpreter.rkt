#lang plait

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (parse str)))

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define (interp [expr : Expr]): Value
  (type-case Expr expr
    [ (e-num n) (v-num n) ]
    [ (e-str s) (v-str s) ]
    [ (e-bool b) (v-bool b) ]))