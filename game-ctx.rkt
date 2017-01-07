#lang racket/base
(require racket/class
         sgl
         "content.rkt")

(provide
 (all-defined-out))

(define window-title "~ Gold ~")
(define window-width 800)
(define window-height 600)

(define fps 40)


(define game-ctx%
  (class* object% ()
    (super-new)

    (define/public (tick)
      this)

    (define/public (draw)
      (gl-clear-color 0 0 0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit))

    (define/public (handle-key-ev ke)
      this)))


(define playing-ctx%
  (class* game-ctx% ()
    (super-new)

    (define/override (draw)
      (gl-clear-color 1 0 0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit)

      (gl-enable 'blend)
      (gl-blend-func 'src-alpha 'one-minus-src-alpha)
      (gl-push-matrix)
      (gl-translate 50 50 0)
      (gl-scale 96 96 1)
      (gl-color 1 1 1 1)
      (gl-call-list (tex-platform))
      (gl-pop-matrix)
      (gl-disable 'blend))

    ))
