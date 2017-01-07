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
        (load-texture (dequeue! loading-queue))))

    (define/override (tick)
      (if (queue-empty? loading-queue)
          (new playing-ctx%)
          this))
          
    ))

(define (load-texture pair)
  (match pair
    [(cons texture-path param)
     (let ([bitmap (make-object bitmap%
                                texture-path
                                'png/alpha
                                #f)])
       (param (bitmap->gl-list bitmap))
       (printf ".. loaded: ~v\n" texture-path)
       (flush-output))]))
