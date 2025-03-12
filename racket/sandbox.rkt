#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax
(require rosette/lib/destruct)
(require rosette/lib/angelic)

; Let's define a simple grammar for arithmetic expressions over integers
; with addition,  multiplication, and squaring
(struct Add  (l r) #:transparent)
(struct Mult (l r) #:transparent)
(struct Square (l) #:transparent)

; (define (interpret program)
;   (destruct program
;     [(Add a b)    (+ (interpret a) (interpret b))]
;     [(Mult a b)   (* (interpret a) (interpret b))]
;     [(Square a)   (expt (interpret a) 2)]
;     [_ program]))

(define (interpret program)
  (destruct program
    [(Add . args)  (apply + (map interpret args))]
    [(Mult . args) (apply * (map interpret args))]
    [(Square a) (expt (interpret a) 2)]
    [num num]))


; (define-symbolic z integer?)
; (define-symbolic b boolean?)
; (define sketch (if b (Add z z) (Mult z z)))

; (synthesize
;   #:forall (list z)
;   #:guarantee (assert (= (interpret sketch)
;                          (interpret (Square z)))))

(define (??expr op a b)
  (define l (choose* op a b))
  (define r (choose* op a b))
  (choose* (Add l r) (Mult l r) l))

(define-symbolic z integer?)
(define-symbolic p q integer?) ; new constants
(define sketch (Add (??expr z p q) (??expr z p q)))

(define M
  (synthesize
    #:forall (list z)
    #:guarantee (assert (= (interpret sketch)
                           (interpret (Mult 10 z))))))
(evaluate sketch M)


; ; #lang rosette

; ; (require rosette/lib/synthax) ; the package containing `synthesis` syntax


; ; (define-grammar arith
; ;   [expr (term)
; ;         (Add expr expr)
; ;         (Mult expr expr)
; ;         (Square expr)]
; ;   [term (integer)])
      

; ; (define (interpret formula)
; ;   (match formula
; ;     [(Add a b)  (+ (interpret a) (interpret b))]
; ;     [(Mult a b) (* (interpret a) (interpret b))]
; ;     [(Square a) (expt (interpret a) 2)]
; ;     [num num]))




; ; ; (define-grammar arith
; ; ;   [expr (term)
; ; ;         (Add expr ...)
; ; ;         (Mult expr ...)
; ; ;         (Square expr)]
; ; ;   [term (integer)])
      

; ; ; (define (interpret formula)
; ; ;   (match formula
; ; ;     [(Add . args)  (apply + (map interpret args))]
; ; ;     [(Mult . args) (apply * (map interpret args))]
; ; ;     [(Square a) (expt (interpret a) 2)]
; ; ;     [num num]))



; ; (define (f x)
; ;   (Add (Add (Mult 5 (Square x)) (Mult 18 x)) 9))

; ; ; interpret


; #lang rosette

; (require rosette/lib/synthax) ; the package containing `synthesis` syntax

; ;; Define a simple arithmetic grammar with addition, multiplication, and square
; (define-grammar arith
;   [expr (term)
;         (Add expr ...)
;         (Mult expr ...)
;         (Square expr)]
;   [term (integer)])

; ;; Define the interpretation function
; (define (interpret formula)
;   (match formula
;     [(Add . args)  (apply + (map interpret args))]
;     [(Mult . args) (apply * (map interpret args))]
;     [(Square a) (expt (interpret a) 2)]
;     [num num]))

; ;; Example usage
; (define example (Add (Mult (integer 3) (integer 2)) (Square (integer 4))))
; (printf "Example: ~a\n" example)
; (printf "Interpreted: ~a\n" (interpret example))

; ;; Define a function using the grammar
; (define (f x)
;   (Add (Add (Mult (integer 5) (Square x)) (Mult (integer 18) x)) (integer 9)))

; ;; Interpret the function
; (printf "Interpreted f: ~a\n" (interpret (f (integer 2))))