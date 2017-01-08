#lang racket
(require racket/gui/base
         sgl
         "content.rkt"
         "game-ctx.rkt"

         "geom.rkt"
         "entity.rkt"
         "platform.rkt")

(provide playing-ctx%)






(define playing-ctx%
  (class* game-ctx% ()
    (super-new)

    (define entities null)
    (define timers null)
    
    (define/public (add-entity e)
      (set! entities
            (sort (cons e entities)
                  entity<?)))

    (define/public (add-timeout ms fn)
      (set! timers
            (cons (cons (+ ms (current-milliseconds))
                        fn)
                  timers)))
    
    (define (camera)
      v3-zero)


    ;; -- init --
    (for ([i (in-range 10)])
      (add-timeout (* i 200)
                   (lambda ()
                     (add-entity
                      (make-platform-entity 0
                                            (- i 4))))))
    
    ;; -- tick --
    (define/override (tick)
      (let ([num-remove
             (for/sum ([e (in-list entities)])
               (cond
                 [(remove-entity? e) 1]
                 [else
                  (tick-entity! e)
                  0]))])
        (when (> num-remove 2)
          (set! entities
                (filter (negate remove-entity?)
                        entities))))
      (set! timers
            (filter (lambda (tm)
                      (cond
                        [(>= (current-milliseconds)
                             (car tm))
                         ((cdr tm))
                         #f]
                        [else #t]))
                    timers))
      this)

    ;; -- draw --
    (define/override (draw)
      (gl-clear-color 0.6 0.8 1.0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit)

      (gl-push-matrix)
      (let ([cam-2d (v3->v2/iso (camera))])
        (gl-translate (- (* window-width 0.5)  (v2-x cam-2d))
                      (- (* window-height 0.5) (v2-y cam-2d))
                      0.0)
        (for ([e (in-list entities)])
          (draw-entity e)))
      (gl-pop-matrix))

    ))
