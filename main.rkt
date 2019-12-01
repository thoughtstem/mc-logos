#lang at-exp racket

(require website/bootstrap)

;SVG lib

(define/provide-attr r:)
(define/provide-attr cx:)
(define/provide-attr cy:)
(define/provide-attr x:)
(define/provide-attr y:)
(define/provide-attr d:)
(define/provide-attr stroke:)
(define/provide-attr fill:)
(define/provide-attr orient:)
(define/provide-attr markerWidth:)
(define marker-width: markerWidth:)
(define/provide-attr markerHeight:)
(define marker-height: markerHeight:)
(define/provide-attr refX:)
(define ref-x: refX:)
(define/provide-attr refY:)
(define ref-y: refY:)
(define/provide-attr marker-end:)

(define/provide-attr transform:)

(define (g . content)
  (apply element (flatten (list 'g content))))

(define (text . content)
  (apply element (flatten (list 'text content))))

(define (path . content)
  (apply element (flatten (list 'path content))))

(define (defs . content)
  (apply element (flatten (list 'defs content))))

(define (marker . content)
  (apply element (flatten (list 'marker content))))

(define (circle . content)
  (apply element (flatten (list 'circle content))))

(define (rect . content)
  (apply element (flatten (list 'rect content))))

(define/provide-extensible-element
  questrial
  text
  (style: (properties font-family: "'Questrial', sans-serif"
                      'letter-spacing: 4)
          properties-join))

(define (arrow-head #:id id
                    #:color (color "black"))
  (marker id: id 
          orient: "auto" marker-width: "2" marker-height: "4"
          ref-x: "0.1" ref-y: "2"
          (path d: "M0,0 V4 L2,2 Z" fill: color)))

(define (logo #:arrow-color (arrow-color "red"))
  (define arrow-id (~a "head" (random 0 1000)))
  (svg 'viewBox: "0 0 200 50" 'xmlns: "http://www.w3.org/2000/svg"
    (defs
      (arrow-head #:id arrow-id
                  #:color arrow-color))
    (questrial 
      x: "37" y: "25"
      "ETA") 
    (questrial 
      x: "45" y: "40"
      "ODERS")
    (g transform: "translate(22 15)"
       (m-with-shape 10 #:with-letter? #t))
    (g transform: "translate(36 35)"
       (c-with-shape 5 #:with-letter? #t))
    (path
      d: "M 20 20 c -10 0, -10 16, 0 15 l 7 0"
      stroke: arrow-color
      marker-end: (~a "url(#" arrow-id ")")
      fill: "transparent")
    (path
      d: "M 115 35 c 10 0, 10 -15, 0 -15 l -39 0"
      stroke: arrow-color
      marker-end: (~a "url(#" arrow-id ")")
      fill: "transparent")))

(define (half x)       (exact->inexact (/ x 2)))
(define (1-quarter x)  (exact->inexact (/ x 4)))
(define (3-quarters x) (exact->inexact (* 3 (1-quarter x))))

(define (m-with-shape W #:with-letter? (with-letter? #t))
  (list
    (rect x: 0 y: 0
          width: W
          height: W
          fill: "red")
    (when with-letter?
      (g transform: "scale(1 0.95)"
         (questrial x: -1.6 y: (+  W 0.65) "M")))))

(define (c-with-shape W #:with-letter? (with-letter? #t))
  (list
    (circle cx: 0 cy: 0 r:  W fill: "blue")
    (when with-letter?
      (g transform: (~a "scale(1 0.9) translate(" (- (- W) 0.7) " " (+ W 0.25) ")")
         (questrial x: 0 y: 0 "C")))))


(define (logo-shapes #:arrow-color (arrow-color "black")
                     #:with-letters? (with-letters? #t))
  (define arrow-id (~a "head" (random 0 1000)))
  (define W 20)

  (svg 'viewBox: "0 0 200 50" 'xmlns: "http://www.w3.org/2000/svg"
    (defs
      (arrow-head #:id arrow-id
                  #:color arrow-color))
    (g transform: "translate(10 10)"
       (g transform: (~a "translate(" 0 " " 0 ")")
          (m-with-shape (half W) #:with-letter? with-letters?))

       (g transform: (~a "translate(" (3-quarters W) " " (3-quarters W) ")")
         (c-with-shape (1-quarter W) #:with-letter? with-letters?))

       (path d: (~a "M " (1-quarter W) " " (half W) " l 0 " (1-quarter W) " l " (- (1-quarter W) 2) " 0")
             stroke: arrow-color
             marker-end: (~a "url(#" arrow-id ")")
             fill: "transparent")
       (path d: (~a "M " (3-quarters W) " " (half W) " l 0 " (- (1-quarter W)) " l " (- (- (1-quarter W) 2)) " 0")
             stroke: arrow-color
             marker-end: (~a "url(#" arrow-id ")")
             fill: "transparent")
       )))

(define (test-page)
  (page index.html
        (content
          #:head (include-css "https://fonts.googleapis.com/css?family=Questrial&display=swap")
          
          (logo-shapes #:with-letters? #f)
          (logo-shapes #:with-letters? #t)
          (logo)
          (logo #:arrow-color "blue")
          )))

(render (list (bootstrap-files)
              (test-page))
        #:to "out")
