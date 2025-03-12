#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax
(require rosette/lib/destruct)
(require rosette/lib/angelic)

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


; In order to do `sketching`, we need to define constraints on an
; unknown expression `??expr` that we want to synthesize
(define (??expr terminals)
  (define l (apply choose* terminals))       ; given a list of args, `choose*` returns a
  (define r (apply choose* terminals))       ; value that can evaluate to any of them
  (choose* (Add l r) (Mult l r) l))
;  For instance, `??expr (list 2 x))` could return (Add 2 x), (Mult 2 x),  2, or x


; Use sketching to synthesize an expression of the form `f(x) + g(x)` that add up to `10x`
(define-symbolic x c1 c2 integer?)  
(define sketch (Add (??expr (list x c1 c2)) (??expr (list x c1 c2))))

(define M      ; model
  (synthesize
    #:forall (list x)
    #:guarantee (assert (= (interpret sketch)
                           (interpret (Mult 10 x))))))
(evaluate sketch M)



