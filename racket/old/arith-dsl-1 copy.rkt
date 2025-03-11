#lang rosette

(require rosette/lib/synthax) ; the package containing `synthesis` syntax


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

;  Define a sketch similarly to example 1 in the previous snippet,
; a function of the form f(x) = Ax + B

(define-symbolic x c integer?)
(define sketch
  (Add (??expr (list x c)) (??expr (list x c))))








; Let's define a simple grammar for arithmetic expressions over integers
; with addition,  multiplication, and squaring
; (define-grammar arith
;     [expr (Add expr expr)]
;     [expr (Mul expr expr)]
;     [expr (Square expr)]
;     [expr (integer)])  ; this is just an integer literal


; ; 
; (define (evaluate expr)
;     (match expr
;         [(Add a b)  (+ (evaluate a) (evaluate b))]
;         [(Mul a b)  (* (evaluate a) (evaluate b))]
;         [(Square a) (* (evaluate a) (evaluate a))]
;         [(integer n) n])) ; if it's an integer, just return it

; ; Examples (x . y), meaning f(x) = y
; (define examples
;     `((1 . 5)  (2 . 7)  (3 . 9)  (4 . 11)))


; ; ; Synthesize an expression containing at least two expressions
; ; (define (synthesize examples)
; ;     (for/list ([example examples])
; ;         (define x (car example))
; ;         (define y (cdr example))
; ;         (list 'Add (list 'Mul x x) (list 'Square x))))

; ; (synthesize examples)

; ;; Define a simple synthesis function (example, but may need refinement)
; (define (synthesize examples)
;   (for/list ([example examples])
;     (define x (car example))
;     (define y (cdr example))
;     ;; Example synthesis: Try constructing expressions that match
;     ;; This is just a demonstration. You would likely want to use synthesis techniques to optimize this.
;     (list 'Add (list 'Mul x x) (list 'Square x))))

; ;; Synthesize expressions (outputs a list of expressions)
; (synthesize examples)