#lang racket
(define-syntax for
  (syntax-rules (to do)
    [(for lo to hi do body)
     (let ([l lo]
           [h hi])
       (letrec ([loop
                 (lambda (it)
                        (if (> it h)
                            #t
                            (begin body
                                   (loop (+ it 1)))))])
         (loop l)))]))
       