#lang racket
(require racket/gui/base
         sgl
         sgl/bitmap
         "game-ctx.rkt"
         "loading-game-ctx.rkt")

(define game-canvas%
  (class* canvas% ()
    (inherit swap-gl-buffers with-gl-context
             min-width min-height
             refresh)

    (init-field game-ctx)
    (define/public (get-game-ctx) game-ctx)

    (super-new [style '(gl)]
               [min-width window-width]
               [min-height window-height])

    (define/public (init-with-size w h)
      (with-gl-context
        (lambda ()
          (gl-enable 'blend)
          ;(gl-disable 'depth-test)
          (gl-blend-func 'src-alpha 'one-minus-src-alpha)
          (gl-viewport 0 0 w h)
          (gl-matrix-mode 'projection)
          (gl-load-identity)
          (gl-ortho 0 w h 0 -1 +1))))

    (init-with-size (min-width)
                    (min-height))

    (define/override (on-paint)
      (with-gl-context
        (lambda ()
          (send game-ctx draw)
          (swap-gl-buffers)
          (gl-flush))))

    (define/public (tick)
      (set! game-ctx
            (send game-ctx tick))
      (refresh))
    
    ))


(provide main)
(define (main)
  (let* ([frame (new frame%
                     [label window-title]
                     [style '(no-resize-border)])]
         [canv (new game-canvas%
                    [game-ctx (new loading-game-ctx%)]
                    [parent frame])]
         [icon (make-object bitmap%
                            "img/icon.png"
                            'unknown/alpha)])
    (send frame set-icon icon)
    (send frame show #t)
    (send canv refresh)
    (thread
     (lambda ()
       (let loop ()
         (when (send frame is-shown?)
           (send canv tick)
           (sleep (/ 1 fps))
           (loop)))))
    (void)))


