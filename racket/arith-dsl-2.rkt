#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax
(require rosette/lib/destruct)

; Let's define a simple grammar for arithmetic expressions over integers
; with addition,  multiplication, and squaring
(struct Add  (l r) #:transparent)
(struct Mult (l r) #:transparent)
(struct Square (l) #:transparent)

(define (interpret expr)
  (destruct expr
    [(Add a b)    (+ (interpret a) (interpret b))]
    [(Mult a b)   (* (interpret a) (interpret b))]
    [(Square a)   (expt (interpret a) 2)]
    [_ expr]))


; Define a function f(x) = A * x^2 + B
(define (f x) (Add (Mult (?? integer?) (Square x)) (?? integer?))) 

; Examples (x . y), meaning f(x) = y
(define examples
  `((2 . 9)  (3 . 19)))

; Synthesis constraint: f(x) must match expected output
(define sol
  (synthesize
   #:forall (list)
   #:guarantee
   (begin
     (for/list ([pair examples])
       (assert (= (interpret (f (car pair))) (cdr pair)))))))

(print-forms sol)
