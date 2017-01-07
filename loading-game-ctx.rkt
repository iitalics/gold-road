#lang racket
(require racket/gui/base
         sgl
         sgl/bitmap
         data/queue
         "game-ctx.rkt"
         (prefix-in content: "content.rkt"))

(provide loading-game-ctx%)

(define loading-game-ctx%
  (class* game-ctx% ()
    (super-new)

    (define loading-queue (make-queue))
    (for ([x (in-list content:textures)])
      (enqueue! loading-queue x))
    
    (define/override (draw)
      (gl-clear-color 0.6 0.8 1.0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit)
      (when (non-empty-queue? loading-queue)
        (match (dequeue! loading-queue)
          [(cons path param)
           (let ([bitm (make-object bitmap%
                                    path
                                    'png)])
             (param (bitmap->gl-list bitm))
             (printf ".. loaded: ~v\n" path))])))

    (define/override (tick)
      this)
          
    ))
