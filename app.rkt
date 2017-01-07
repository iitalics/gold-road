#lang racket
(require racket/gui/base
         sgl
         sgl/bitmap)

(define window-title "~ Gold ~")
(define window-width 800)
(define window-height 600)

(define game%
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

(define loading-game%
  (class* game% ()
    (super-new)
    (define/override (draw)
      (gl-clear-color 0.6 0.8 1.0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit))
    ))

(define game-canvas%
  (class* canvas% ()
    (inherit swap-gl-buffers with-gl-context
             min-width min-height)

    (init-field game)

    (super-new [style '(gl)]
               [min-width window-width]
               [min-height window-height])
    
    (define/public (init-with-size w h)
      (gl-viewport 0 0 w h)
      (gl-matrix-mode 'viewport)
      (gl-load-identity)
      (gl-ortho 0 w h 0 -1 +1))

    (define/override (on-paint)
      (with-gl-context
        (lambda ()
          (send game draw)
          (swap-gl-buffers)
          (gl-flush))))
    
    ))


(provide main)
(define (main)
  (let* ([game (new loading-game%)]
         [frame (new frame%
                     [label window-title]
                     [style '(no-resize-border)])]
         [canv (new game-canvas%
                    [game game]
                    [parent frame])])
    (send frame show #t)
    (send canv refresh)
    (void)))


