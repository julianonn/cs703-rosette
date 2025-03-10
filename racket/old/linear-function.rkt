#lang rosette

(define-symbolic a b integer?)

; Basic linear function. But we don't know what a and b are yet.
(define (f x)
  (+ (* a x) b))

; Examples in dotted pair notation. "(1 . 5)" means that f(1)=5
; Yes, that ` character is necessary. That's not a typo.
(define examples
  `((1 . 5)  (2 . 7)  (3 . 9)  (4 . 11)))

; Constraint: f(x) must match expected output for all examples
(define constraints
  ; For every (x,y) example pair above
  (for/list ([pair examples])
    ; Make sure f(x)=y
    (assert (= (f (car pair)) (cdr pair)))))

; Solve for a and b.
(define sol (solve constraints))

; Extract values
(define synthesized-a (evaluate a sol))
(define synthesized-b (evaluate b sol))

(displayln (format "Found one! f(x) = ~a*x + ~a" synthesized-a synthesized-b))
