
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

;; Problem 1
;; Number Number Number -> (listof Number)
;; Produce a sequence of numbers from l upto
;; or including h, that are seperated by s

(define (sequence l h s)
  (cond [(> l h) null]
        [#t (cons l
                  (sequence (+ l s) h s))]))

;; Problem 2
;; (listof String) String -> (listof String)
;; map xs and append every string with suffix

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))

;; Problem 3
;; (list of X) Number -> X
;; Produce the (remainder n (length xs))th
;; element of xs

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (letrec ([i (remainder n (length xs))])
              (car (list-tail xs i)))]))

;; Problem 4
;; (X Stream) Number -> (listof X)
;; Produce a list containing the first n elements of the stream s

(define (stream-for-n-steps s0 n)
  (letrec ([f (lambda (s acc)
                (let ([str-pair (s)])
                  (if (>= acc n)
                      null
                      (cons (car str-pair) (f (cdr str-pair) (+ acc 1))))))])
    (f s0 0)))

;; Problem 5
;; A Stream of Natural Numbers with every multiple of 5 being a negative number

(define funny-number-stream
  (letrec ([f (lambda (x) (cons (if (= (remainder x 5) 0)
                                    (* -1 x)
                                    x)
                                (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))


;; Problem 6
;; A Stream of strings that alternates between "dan.jpg" and "dog.jpg"

(define dan-then-dog
  (lambda () (cons "dan.jpg"
                   (lambda () (cons "dog.jpg"
                                    (lambda () (dan-then-dog)))))))

;; Problem 7
;; Stream -> Stream
;; A Stream whose ith element is of the form '(0 . v)
;; where v is the ith element of the stream s

(define stream-add-zero
  (lambda (s) (letrec ([str-pair (s)])
                (lambda () (cons (cons 0 (car str-pair))
                                 (lambda () ((stream-add-zero (cdr str-pair)))))))))

;; Problem 8
;; (listof X) (listof Y) -> Stream
;; Produce a stream where the elements of xs are paired with the elements of ys
(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
                (cons (cons (list-nth-mod xs n)
                            (list-nth-mod ys n))
                      (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

;; Problem 9
;; X Vector -> Pair
;; Return the pair in vec whose first element is equal to v

(define (vector-assoc v vec)
  (letrec ([vec-len (vector-length vec)]
           [f (lambda (n)
                (cond [(>= n vec-len) #f]
                      [#t (letrec ([vec-n (vector-ref vec n)])
                            (if (pair? vec-n)
                                (if (equal? (car vec-n) v)
                                    vec-n
                                    (f (+ n 1)))
                                (f (+ n 1))))]))])
    (f 0)))

;; Problem 10
;; (listof X) Number -> (X -> Pair)
;; Produce a function that looks for the pair whose first element is equal to v
;; in cache of n elements or xs

(define (cached-assoc xs n)
  (letrec ([cache (make-vector n #f)]
           [current-slot 0])
    (lambda (v)
      (let ([cache-ans (vector-assoc v cache)])
        (if (not (false? cache-ans))
            cache-ans
            (let ([list-ans (assoc v xs)]
                  [next-slot (+ current-slot 1)])
              (begin (vector-set! cache current-slot list-ans)
                     (set! current-slot (if (>= next-slot n)
                                            0
                                            next-slot))
                     list-ans)))))))

;; Challenge Problem
;; Macro

(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (let ([c e1])
       (letrec ([f (lambda () (let ([p e2])
                                (if (<= p c)
                                    (f)
                                    #t)))])
         (f)))]))
                                





