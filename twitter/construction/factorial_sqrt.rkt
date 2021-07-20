#lang racket

(require data/queue)
(require racket/set)
(require gmp)

(define (gmp_fact n)
  (define n! (mpz))
  (mpz_fac_ui n! n)
  n!)

(define bound 20000)

(define queue (make-queue))
(enqueue! queue 3)

(define found (mutable-set 3))

(define paths (make-hash))
(dict-set! paths 3 3)

(define sqrts (make-hash))
(dict-set! sqrts 3 0)

(define n 0)
(for ([m (in-queue queue)])
  (set! n (gmp_fact m))
  
  (define i* (box 0))
  
  (define (shrink j i*)
    (when (> (mpz_cmp_ui n bound) 0)
      (mpz_sqrt j j)
      (set-box! i* (add1 (unbox i*)))
      (shrink j i*)
      )
    )
  (shrink n i*)

  (define nn* (box (mpz_get_ui n)))

  (define (process k* i*)
    (when (> (unbox k*) 3)
      (when (not (set-member? found (unbox k*)))
            (set-add! found (unbox k*))
            (enqueue! queue (unbox k*))
            (dict-set! paths (unbox k*) m)
            (dict-set! sqrts (unbox k*) (unbox i*))
            )
      (set-box! k* (integer-sqrt (unbox k*)))
      (set-box! i* (add1 (unbox i*)))
      (process k* i*)
      )
    )
  (process nn* i*)
  )

(printf "~n")

(for ([i (in-range 3 1000)])
  (when (not (set-member? found i))
    (printf "~a " (number->string i))
    )
  )

(printf "~n~n")
        
(define (traverse v)
  (when (> v 3)
    (printf "~a -> ~a! + ~a sqrt ~n" v (dict-ref paths v) (dict-ref sqrts v))
    (traverse (dict-ref paths v))
    )
  )
(traverse 9)
(printf "~n")
(traverse 552)
