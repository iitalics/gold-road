#lang racket
(require "geom.rkt")
(provide
 gravity gravity/iso
 (struct-out entity)
 make-entity
 move-entity!
 move-entity-by!
 tick-entity!
 draw-entity
 remove-entity?
 entity<?
 entity<=?)

(define gravity 1000)
(define gravity/iso (/ (- gravity) (v2-y iso-zvec)))

#| ---------- entities ------------- |#

(struct entity ([pos #:mutable]
                [state #:mutable]))

;; (make-entity [pos : v3]
;;              [state : any/c]
;;              [on-tick : (-> entity? any/c any/c)
;;              [on-draw : (-> entity? any/c void?)])
(define (make-entity pos state)
  (entity pos state))

;; (move-entity! [e : entity?] [new-pos : v3]) -> void?
(define (move-entity! e new-pos)
  (set-entity-pos! e new-pos))

;; (move-entity-by! [e : entity?] [dv : v3]) -> void?
;; (move-entity-by! [e : entity?] [dx dy dz : real]) -> void?
(define move-entity-by!
  (case-lambda
    [(e dv)
     (set-entity-pos! e
                      (v3 (+ (v3-x (entity-pos e) (v3-x dv)))
                          (+ (v3-y (entity-pos e) (v3-y dv)))
                          (+ (v3-z (entity-pos e) (v3-z dv)))))]
    [(e dx dy dz)
     (set-entity-pos! e
                      (v3 (+ (v3-x (entity-pos e) dx)))
                      (v3 (+ (v3-y (entity-pos e) dy)))
                      (v3 (+ (v3-z (entity-pos e) dz))))]))

;; (tick-entity! [e : entity?]) -> void?
(define (tick-entity! e)
  (let ([s (entity-state e)])
    (when s
      (set-entity-state! e (send s on-tick e)))))

;; (draw-entity [e : entity?]) -> void?
(define (draw-entity e)
  (let ([s (entity-state e)])
    (when s
      (send s on-draw e))))

;; (remove-entity? [e : entity?]) -> boolean?
(define (remove-entity? e)
  (false? (entity-state e)))


(define (entity<=? e1 e2)
  (or (and (equal? (entity-pos e1)
                   (entity-pos e2)))
      (> (v3-y (entity-pos e1))
         (v3-y (entity-pos e2)))
      (> (v3-x (entity-pos e1))
         (v3-x (entity-pos e2)))))

(define (entity<? e1 e2)
  (or (> (v3-y (entity-pos e1))
         (v3-y (entity-pos e2)))
      (> (v3-x (entity-pos e1))
         (v3-x (entity-pos e2)))))
