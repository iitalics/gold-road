#lang racket/base
(require racket/gui/base
         sgl/bitmap)

(provide (all-defined-out))

(define tex-ball #f)
(define tex-ball-shadow #f)
(define tex-platform #f)

(define textures
  `(("img/ball.png" . ,(lambda (x) (set! tex-ball x)))
    ("img/shadow.png" . ,(lambda (x) (set! tex-ball-shadow x)))
    ("img/platform.png" . ,(lambda (x) (set! tex-platform x)))))
