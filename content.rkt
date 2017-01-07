#lang racket/base
(require racket/gui/base
         sgl/bitmap)

(provide (all-defined-out))

(define tex-ball (make-parameter #f))
(define tex-ball-shadow (make-parameter #f))
(define tex-platform (make-parameter #f))

(define textures
  `(("img/ball.png" . ,tex-ball)
    ("img/shadow.png" . ,tex-ball-shadow)
    ("img/platform.png" . ,tex-platform)))

