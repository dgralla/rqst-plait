#lang plait

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (parse str)))

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define init-env (hash empty))

(define (interp [expr : Expr] ): Value
  (interp-with-env expr init-env)) ;; Call interp-with-env with empty environment

;; Interp in an environment (could also have changed interp itself, but would require
;; edits about DO NOT EDIT line
(define (interp-with-env [expr : Expr] [env : Env] ): Value
  (type-case Expr expr
    [ (e-num n) (v-num n) ]
    [ (e-str s) (v-str s) ]
    [ (e-bool b) (v-bool b) ]
    [ (e-op op l r)
      (type-case Operator op
        [ (op-plus) (add (interp-with-env l env) (interp-with-env r env)) ]
        [ (op-append) (append (interp-with-env l env) (interp-with-env r env)) ]
        [ (op-str-eq) (str-eq (interp-with-env l env) (interp-with-env r env)) ]
        [ (op-num-eq) (num-eq (interp-with-env l env) (interp-with-env r env)) ]) ]
    [ (e-if cond cons alt) (if (truthy? (interp-with-env cond env))
                               (interp-with-env cons env)
                               (interp-with-env alt env))
      ]
    [ (e-var name) (lookup name env) ]
    [ (e-lam name body) (v-fun name body env) ]
    [ (e-app fun args) (apply (interp-with-env fun env) (interp-with-env args env)) ]
    ))

;; Add helper for arithmetic
(define (add [left : Value] [right : Value]): Value
  (type-case Value left
    [ (v-num n1)
      (type-case Value right
        [ (v-num n2) (v-num (+ n1 n2)) ]
        [ else (error '+ "right must be number") ]) ]
    [ else (error '+ "left must be number") ]))

;; Num equality helper
(define (num-eq [left : Value] [right : Value]): Value
  (type-case Value left
    [ (v-num n1)
      (type-case Value right
        [ (v-num n2) (v-bool (= n1 n2)) ]
        [ else (error 'num= "right must be number") ]) ]
    [ else (error 'num= "left must be number") ]))

;; Append helper
(define (append [left : Value] [right : Value]): Value
  (type-case Value left
    [ (v-str s1)
      (type-case Value right
        [ (v-str s2) (v-str (string-append s1 s2)) ]
        [ else (error '++ "right must be a string") ]) ]
    [ else (error '++ "left must be a string") ]))

;; String equality helper
(define (str-eq [left : Value] [right : Value]): Value
  (type-case Value left
    [ (v-str s1)
      (type-case Value right
        [ (v-str s2) (v-bool (string=? s1 s2)) ]
        [ else (error 'str= "right must be a string") ]) ]
    [ else (error 'str= "left must be a string") ]))

;; Truthiness helper
(define (truthy? [t : Value]): Boolean
  (type-case Value t
    [ (v-bool b) b ]
    [ else (error 'truthy? "if condition must be a boolean")]))

;; Environment lookup helper
(define (lookup (s : Symbol) (env : Env)): Value
  (type-case (Optionof Value) (hash-ref env s)
    [ (none) (error s "symbol not bound") ]
    [ (some v) v ]))

;; Extend environment helper
(define (extend old-env name value): Env
     (hash-set old-env name value))

;; Function application helper
(define (apply [ fun : Value ] [arg : Value] )
  (type-case Value fun
    [ (v-fun name body env)
      (interp-with-env body (extend env name arg)) ]
    [ else (error 'app "Not a function")]))
