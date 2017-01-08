#lang racket
(require racket/gui/base
         sgl
         sgl/bitmap
         data/queue
         "game-ctx.rkt"
         "playing-ctx.rkt"
         (prefix-in content: "content.rkt"))

(provide loading-game-ctx%)

(define loading-game-ctx%
  (class* game-ctx% ()
    (super-new)

    (define loading-queue (make-queue))
    (define remaining
      (for/sum ([x (in-list content:textures)])
        (enqueue! loading-queue x)
        1))
    
    (define/override (draw)
      (gl-clear-color 1.0 1.0 1.0 0)
      (gl-clear 'color-buffer-bit
                'depth-buffer-bit)
      (when (non-empty-queue? loading-queue)
        (load-texture (dequeue! loading-queue))
        (set! remaining
              (sub1 remaining))))

    (define/override (tick)
      (if (<= remaining 0)
          (new playing-ctx%)
          this))
          
    ))

(define (load-texture pair)
  (match pair
    [(cons texture-path setter!)
     (let ([bitmap (make-object bitmap%
                                texture-path
                                'png/alpha
                                #f)])
       (setter! (bitmap->gl-list bitmap))
       (printf ".. loaded: ~v\n" texture-path)
       (flush-output))]))
