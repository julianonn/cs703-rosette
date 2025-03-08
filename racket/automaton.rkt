#lang rosette

(struct automaton (start-state transitions)
  #:transparent
  #:property prop:procedure
  (lambda (self word)
    (let loop ([state (automaton-start-state self)]
               [input word])
      (cond
        [(null? input) (eq? state 'end)]
        [else
         (let* ([sym (car input)]
                [trans (hash-ref (hash-ref (automaton-transitions self) state '()) sym #f)])
           (and trans (loop trans (cdr input))))]))))

(define (choose-state states)
  (define-symbolic* choice integer?)
  (assert (and (>= choice 0) (< choice (length states))))
  (list-ref states choice))

(define (make-automaton start transitions)
  (automaton start (make-immutable-hash transitions)))

(define (word k alphabet) ; Draws a word of length k
  (for/list ([i (in-range k)]) 
    (define-symbolic* idx integer?)
    (assert (and (>= idx 0) (< idx (length alphabet))))
    (list-ref alphabet idx)))

(define (word* k alphabet) ; Draws a word of length
  (define-symbolic* n integer?) ; 0 <= n <= k from the
  (assert (and (>= n 0) (<= n k)))
  (take (word k alphabet) n)) ; given alphabet.

; Returns a string encoding of the given list of symbols.
(define (word->string w)
  (apply string-append (map symbol->string w)))

; Returns true iff the regex matches the word.
(define (spec regex w)
  (regexp-match? regex (word->string w)))

(define (generate-forms model)
  (define solution (solve (assert #t)))
  (if (sat? solution)
      (begin
        (displayln "Synthesized automaton:")
        (displayln (evaluate M solution))
        (displayln "Example word:")
        (displayln (evaluate w solution)))
      (displayln "No solution found")))

(define M
  (make-automaton
   'init
   (list
    (cons 'init (make-immutable-hash
                 (list (cons 'c (choose-state '(s1 s2))))))
    (cons 's1 (make-immutable-hash
               (list (cons 'a (choose-state '(s1 s2 end reject)))
                     (cons 'd (choose-state '(s1 s2 end reject)))
                     (cons 'r (choose-state '(s1 s2 end reject))))))
    (cons 's2 (make-immutable-hash
               (list (cons 'a (choose-state '(s1 s2 end reject)))
                     (cons 'd (choose-state '(s1 s2 end reject)))
                     (cons 'r (choose-state '(s1 s2 end reject))))))
    (cons 'end (make-immutable-hash '())))))

(define w (word* 4 '(c a d r)))
(define model (synthesize [w] (assert (eq? (spec #px"^c[ad]+r$" w) (M w)))))
(generate-forms model)
