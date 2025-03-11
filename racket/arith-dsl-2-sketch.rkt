#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax
(require rosette/lib/destruct)
(require rosette/lib/angelic)

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


; In order to do `sketching`, we need to define constraints on an
; unknown expression `??expr` that we want to synthesize
(define (??expr terminals)
  (define a (apply choose* terminals))  ; given a list of args, `choose*` returns a
  (define b (apply choose* terminals))  ; value that can evaluate to any of them
  (choose* (Add a b)
           (Mult a b)
           (Square a)
           a))

;  For instance, `??expr (list 2 x))` could return:
;  - (Add 2 x)
;  - (Mult 2 x)
;  - (Square 2) or (Square x)
;  - 2 or x


;; We'll use sketching to factor a quadratic equation.
;; I have an expression 
;;      f(x) = 5*x^2 + 18*x + 9
;; and I want to factor it into two expressions g(x) and h(x) such that
;;      f(x) = g(x) * h(x)

(define (f x)
  (Add (Add (Mult 5 (Square x)) (Mult 18 x)) 9))

(define-symbolic x a b c d integer?)

(define sketch 
  (Mult (??expr (list a b x)) (??expr (list c d x))))

(define M 
  (synthesize
   #:forall (list x)
   #:guarantee (assert (= (interpret (f x)) (interpret sketch)))))


(evaluate sketch M)
; (define M (extract-model result))


