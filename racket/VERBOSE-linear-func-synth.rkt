#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax

; This enables the solver to output the constraints in SMT form
(output-smt (current-output-port))

; Define a function `f` with unknown coefficients `a` and `b`
(define (f x)
  (+ (* (?? integer?) x) (?? integer?)))  ; `??` means a hole in the program

; Examples (x . y), meaning f(x) = y
(define examples
  `((1 . 5)  (2 . 7)  (3 . 9)  (4 . 11)))

; Synthesis constraint: f(x) must match expected output
(define sol
  (synthesize
   #:forall (list)
   #:guarantee
   (begin
     (for/list ([pair examples])
       (assert (= (f (car pair)) (cdr pair)))))))
; \exists f .\forall (i,o). f(i)=o

(print-forms sol)
