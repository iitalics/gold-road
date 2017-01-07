#lang racket/base
(provide (all-defined-out))

(struct v2 (x y) #:transparent)
(struct v3 (x y z) #:transparent)

(define (v* r a)
  (cond
    [(v2? r) (v2 (* (v2-x r) a)
                 (* (v2-y r) a))]
    [(v3? r) (v3 (* (v3-x r) a)
                 (* (v3-y r) a)
                 (* (v3-z r) a))]))

(define (v2->v3 r [z 0.0])
  (v3 (v2-x r)
      (v2-y r)
      z))
