#lang racket

(define (partitions cards subtotal)
  (define m 0)
  (for ([i (in-range 0 10)])
    (when (> (vector-ref cards i) 0)
      (cond
        [(< (add1 (+ subtotal i)) 21)
         (set! m (add1 m))
         (vector-set! cards i (sub1 (vector-ref cards i)))
         (set! m (+ m (partitions cards (add1 (+ subtotal i)))))
         (vector-set! cards i (add1 (vector-ref cards i)))]
        [(= (add1 (+ subtotal i)) 21)
         (set! m (add1 m))])))
  m)

(define deck (vector 4 4 4 4 4 4 4 4 4 16))

(define d 0)

(for ([i (in-range 0 10)])
  ; (writeln i)
  ; (writeln deck)
  (vector-set! deck i (sub1 (vector-ref deck i)))
  (define p 0)
  (for ([j (in-range 0 10)])
    (vector-set! deck j (sub1 (vector-ref deck j)))
    (define n (partitions deck (add1 j)))
    (vector-set! deck j (add1 (vector-ref deck j)))
    (set! p (+ p n)))
  (display "Dealer showing")
  (display i)
  (display " partitions = ")
  (displayln p)
  (set! d (+ d p))
  (vector-set! deck i (add1 (vector-ref deck i)))
  ; (writeln deck)
  )
(display "Total partitions = ")
(displayln d)

