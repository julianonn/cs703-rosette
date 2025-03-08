;; Demo from https://jamesbornholt.com/blog/building-synthesizer/

#lang rosette
(require rosette/lib/destruct)

(struct plus (left right) #:transparent)
(struct mul (left right) #:transparent)
(struct square (arg) #:transparent)

(define prog (plus (square 7) 3))


(define (interpret p)
  (destruct p
    [(plus a b)  (+ (interpret a) (interpret b))]
    [(mul a b)   (* (interpret a) (interpret b))]
    [(square a)  (expt (interpret a) 2)]
    [_ p]))

;  (interpret prog)

(define-symbolic y integer?)

; (interpret (square (plus y 2)))
(solve 
  (assert 
    (= (interpret (square (plus y 2))) 25)))