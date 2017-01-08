#lang racket/base
(provide (all-defined-out))

;; vectors

(struct v2 (x y) #:transparent)
(struct v3 (x y z) #:transparent)

(define v2-zero (v2 0 0))
(define v3-zero (v3 0 0 0))

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


;; isometric

(define tex-size 96)
(define iso-xvec (v2 51.0  32.0))
(define iso-yvec (v2 45.0 -33.0))
(define iso-zvec (v2  0.0 -40.0))

(define (v3->v2/iso r)
  (v2 (+ (* (v3-x r) (v2-x iso-xvec))
         (* (v3-y r) (v2-x iso-yvec))
         (* (v3-z r) (v2-x iso-zvec)))
      (+ (* (v3-x r) (v2-y iso-xvec))
         (* (v3-y r) (v2-y iso-yvec))
         (* (v3-z r) (v2-y iso-zvec)))))
