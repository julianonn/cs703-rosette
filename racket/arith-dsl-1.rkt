#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax
(require rosette/lib/destruct)

; Let's define a simple grammar for arithmetic expressions over integers
; with addition,  multiplication, and squaring
(struct Add  (left right) #:transparent)
(struct Mult (left right) #:transparent)
(struct Square (arg) #:transparent)

(define (interpret expr)
  (destruct expr
    [(Add a b)    (+ (interpret a) (interpret b))]
    [(Mult a b)   (* (interpret a) (interpret b))]
    [(Square a)   (expt (interpret a) 2)]
    [_ expr]))


; Define a function `f` with unknown coefficients `a` and `b`
(define (f x)
  (Add (Mult (?? integer?) x) (?? integer?)))  ; `??` means a hole in the program


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
       (assert (= (interpret (f (car pair))) (cdr pair)))))))

(print-forms sol)