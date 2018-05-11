(ns outcomes
  (:gen-class))

; (use 'clojure.pprint)

(defn partitions [cards subtotal]
  ; (pprint cards)
  ; (println subtotal)
  (def m 0)
   (dotimes [i 10]
     (when (> (aget cards i) 0)
       (def total (+ subtotal (+ i 1)))
       (cond
         (< total 21)
           (do 
             (def m (+ m 1))
             (aset cards i (- (aget cards i) 1))
             (def m (+ m (partitions cards total)))
             (aset cards i (+ (aget cards i) 1))
           )
         (= total 21)
           (def m (+ m 1))
       )
     )
   )
 m)

(def deck (into-array Integer/TYPE [4 4 4 4 4 4 4 4 4 16]))

(def d 0)

(dotimes [i 10]
  ; (pprint deck)
  (aset deck i (- (aget deck i) 1))
  (def p 0)
  (dotimes [j 10]
    (aset deck j (- (aget deck j) 1))
    (def p (+ p (partitions deck (+ j 1))))
    (aset deck j (+ (aget deck j) 1))
  )
  (println (list i p))
  (def d (+ d p))
  (aset deck i (+ (aget deck i) 1))
)

(println d)
