#lang racket
(define ones (lambda () (cons 1 ones)))

(define (f x) (cons x (lambda () (f (+ x 1)))))
(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda (f 1))))

