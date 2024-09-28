#lang racket

;; =============================================================================
;; Interpreter: interpreter-tests.rkt
;; =============================================================================

(require (only-in "interpreter.rkt" eval)
         "support.rkt"
         "test-support.rkt")

; Here, we provide some examples of how to use the testing forms provided in
; "test-support.rkt". You should not use any external testing library other
; than those specifically provided; otherwise, we will not be able to grade
; your code.
(define/provide-test-suite sample-tests
  ;; DO NOT ADD TESTS HERE
  (test-equal? "Works with Num primitive"
               (eval `2) (v-num 2))
  (test-raises-error? "Passing Str to + results in error"
               (eval `{+ "bad" 1}))
  (test-pred "Equivalent to the test case above, but with test-pred"
             v-fun? (eval `{lam x 5})))

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define/provide-test-suite student-tests ;; DO NOT EDIT THIS LINE ==========
  ; TODO: Add your own tests below!
  (test-equal? "Works with String primitive"
               (eval `"Hello world!") (v-str "Hello world!"))
  (test-equal? "Works with boolean primitive"
               (eval `true) (v-bool true))
  (test-equal? "Add works with numbers"
               (eval `(+ 2 3)) (v-num 5))
  (test-raises-error? "Add fails with non-numbers"
               (eval `(+ true 3)))
  (test-equal? "Append works with strings"
               (eval `(++ "Hello " "world!")) (v-str "Hello world!"))
  (test-raises-error? "Append fails with non-strings"
                      (eval `(++ true 4)))
  (test-equal? "Num= works with numbers"
               (eval `(num= 1 1)) (v-bool true))
  (test-raises-error? "Num-eq fails with non-numbers"
               (eval `(num= 2 "two")))
  (test-equal? "Str= works with strings"
               (eval `(str= "left" "right")) (v-bool false))
  (test-raises-error? "Str= fails with non-strings"
               (eval `(str= "2" 4)))
  (test-equal? "If works with false"
              (eval `(if false "true" "false")) (v-str "false"))
  (test-equal? "If works with true"
               (eval `(if true (+ 1 2) (++ "false " ":("))) (v-num 3))
  (test-raises-error? "If fails with non-bool condition"
               (eval `(if "true" (true) (false))))
  )
  

;; DO NOT EDIT BELOW THIS LINE =================================================

(module+ main
  (run-tests sample-tests)
  (run-tests student-tests))