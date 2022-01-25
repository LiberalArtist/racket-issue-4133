#lang info
(define collection "pkg-b")
(define deps '("base" "pkg-a"))
(define pkg-desc "Package for Layer B")
(define version "0.0")
(define pkg-authors '(philip))
(define license '(Apache-2.0 OR MIT))

(define racket-launcher-names
  '("launcher-b"))
(define racket-launcher-libraries
  '("launcher-b.rkt"))
