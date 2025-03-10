#lang rosette

(require rosette/lib/destruct)
(require rosette/lib/synthax)


(struct plus (left right) #:transparent)
(struct mul (left right) #:transparent)
(struct square (arg) #:transparent)

;; define a simple DSL for multiplication, addition, and squaring
(define (interpret p)
  (destruct p
    [(plus a b)  (+ (interpret a) (interpret b))]
    [(mul a b)   (* (interpret a) (interpret b))]
    [(square a)  (expt (interpret a) 2)]
    [_ p]))


(define-symbolic x c integer?)

;; goal =  find some value of `c` such that c*x = x+x
(synthesize
  #:forall (list x)
  #:guarantee (assert (= (interpret (mul c x)) (+ x x))))



;; abstract this such that expr can be plus, mul, square, or a terminal A
; (define (??expr terminals)
;     (define a (apply choose* terminals))
;     (define b (apply choose* terminals))
;     (choose* (plus a b)
;              (mul a b)
;              (square a)
;              a))

(define-simple-grammar  ()
  (expr
   (plus expr expr)
   (mul expr expr)
   (square expr)
   (terminal)))


(define-symbolic p q integer?)
(define sketch
  (plus (??expr (list x p q)) (??expr (list x p q))))

  f(x, p, q) + g(x, p, q) 
  f =..?????? g = ?????

(synthesize 
    #:forall (list x)
    #:guarantee (assert (= (interpret sketch) (+ x x))))s