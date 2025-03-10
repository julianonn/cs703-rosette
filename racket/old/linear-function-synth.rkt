#lang rosette

(define-symbolic a b integer?)

; Basic linear function. But we don't know what a and b are yet.
(define (f x)
  (+ (* a x) b))

; Examples in dotted pair notation. "(1 . 5)" means that f(1)=5
; Yes, that ` character is necessary. That's not a typo.
(define examples
  `((1 . 5)  (2 . 7)  (3 . 9)  (4 . 11)))

; ; Constraint: f(x) must match expected output for all examples
; (define constraints
;   ; For every (x,y) example pair above
;   (for/list ([pair examples])
;     ; Make sure f(x)=y
;     (assert (= (f (car pair)) (cdr pair)))))

; ; Solve for a and b.
; (define sol (solve constraints))

; ; Extract values
; (define synthesized-a (evaluate a sol))
; (define synthesized-b (evaluate b sol))

; (displayln (format "Found one! f(x) = ~a*x + ~a" synthesized-a synthesized-b))



; (synthesize
;   #:forall (list (pair 1 5) (pair 2 7) (pair 3 9) (pair 4 11))
;   #:guarantee (assert (= (f (car pair)) (cdr pair))))

; (define examples (list (pair 1 5) (pair 2 7) (pair 3 9) (pair 4 11)))


; looking for a function f(x) = a*x + b

(define-symbolic m n integer?)
(synthesize
  #:forall (list m n)
  #:guarantee (assert (forall ([pair examples])
                     (= (+ (* m (car pair)) n) (cdr pair)))))
