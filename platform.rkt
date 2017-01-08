#lang racket
(require sgl
         "content.rkt"
         "entity.rkt"
         "geom.rkt")
(provide
 make-platform-entity
 draw-platform)

#|  platform entity  |#

(define (make-platform-entity x y)
  (make-entity (v3 x y 0)
               (new-platform-state)))

;; (draw-platform [pos : v3]) -> void?
(define (draw-platform pos
                       #:pre-draw [pre-draw void]
                       #:post-draw [post-draw void]
                       #:alpha [a 1.0])
  (gl-push-matrix)
  (let ([v (v3->v2/iso pos)])
    (gl-translate (v2-x v)
                  (v2-y v)
                  0)
    (pre-draw)
    (gl-push-matrix)
    (gl-color 1 1 1 a)
    (gl-scale tex-size tex-size 1)
    (gl-translate -0.5 -0.5 0)
    (gl-call-list tex-platform)
    (gl-pop-matrix)
    (post-draw))
  (gl-pop-matrix))

;; (new-platform-state) -> platform-state?
(define (new-platform-state)
  (new new-platform-state%))

(define platform-state%
  (class* object% ()
    (init-field [init-time (current-milliseconds)])
    (super-new)
    (define/public (delta-time)
      (- (current-milliseconds) init-time))
    (define/public (on-tick e)
      this)
    (define/public (on-draw e)
      (draw-platform (entity-pos e)))))

(define new-platform-state%
  (class* platform-state% ()
    (inherit delta-time)
    (super-new)
    (define/override (on-draw e)
      (draw-platform (entity-pos e)
                     #:pre-draw (lambda ()
                                  (gl-translate 0
                                                (falling-offset)
                                                0))))
    (define (falling-offset)
      (* -400
         (exp (* (delta-time) -0.01))))

    (define/override (on-tick e)
      (cond
        [(> (delta-time) 600)
         (new still-platform-state%)]
        [else this]))
    ))

(define still-platform-state%
  (class* platform-state% ()
    (inherit delta-time)
    (super-new)
    (define/override (on-tick e)
      (cond
        [(> (delta-time) 1000)
         (new falling-platform-state%)]
        [else this]))
    ))

(define falling-platform-state%
  (class* platform-state% ()
    (inherit delta-time)
    (super-new)
    (define/override (on-draw e)
      (draw-platform (entity-pos e)
                     #:pre-draw (lambda ()
                                  (gl-translate 0
                                                (falling-offset)
                                                0))
                     #:alpha (alpha)))
    (define (falling-offset)
      (let ([dts (/ (delta-time) 1000)])
        (* gravity 0.5 dts dts)))
    (define (alpha)
      (cond
        [(> (delta-time) 200)
         (- 1 (/ (- (delta-time) 200.0) 600.0))]
        [else 1]))
    (define/override (on-tick e)
      (and (< (delta-time) 1000)
           this))
    ))
