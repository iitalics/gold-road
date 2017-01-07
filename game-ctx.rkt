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
