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
    [ (e-bool b) (v-bool b) ]
    [ (e-op op l r)
      (type-case Operator op
        [ (op-plus) (add (interp l) (interp r)) ]
        [ (op-append) (append (interp l) (interp r)) ]
        [ (op-str-eq) (str-eq (interp l) (interp r)) ]
        [ (op-num-eq) (num-eq (interp l) (interp r)) ]) ]
    [ (e-if cond cons alt) (if (truthy? (interp cond))
                               (interp cons)
                               (interp alt))
      ]
    ;[ else (error '+ "expression not interpretable")]
    ))

;; Add helper for arithmetic
(define (add [left : Value] [right : Value]) : Value
  (type-case Value left
    [ (v-num n1)
      (type-case Value right
        [ (v-num n2) (v-num (+ n1 n2)) ]
        [ else (error '+ "right must be number") ]) ]
    [ else (error '+ "left must be number") ]))

;; Num equality helper
(define (num-eq [left : Value] [right : Value]) : Value
  (type-case Value left
    [ (v-num n1)
      (type-case Value right
        [ (v-num n2) (v-bool (= n1 n2)) ]
        [ else (error 'num= "right must be number") ]) ]
    [ else (error 'num= "left must be number") ]))

;; Append helper
(define (append [left : Value] [right : Value]) : Value
  (type-case Value left
    [ (v-str s1)
      (type-case Value right
        [ (v-str s2) (v-str (string-append s1 s2)) ]
        [ else (error '++ "right must be a string") ]) ]
    [ else (error '++ "left must be a string") ]))

;; String equality helper
(define (str-eq [left : Value] [right : Value]) : Value
  (type-case Value left
    [ (v-str s1)
      (type-case Value right
        [ (v-str s2) (v-bool (string=? s1 s2)) ]
        [ else (error 'str= "right must be a string") ]) ]
    [ else (error 'str= "left must be a string") ]))

;; Truthiness helper
(define (truthy? [t : Value]) : Boolean
  (type-case Value t
    [ (v-bool b) b ]
    [ else (error 'truthy? "if condition must be a boolean")]))
