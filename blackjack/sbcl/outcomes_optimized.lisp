#!/usr/bin/sbcl --script

(proclaim '(optimize (speed 3) (safety 0)))

(defun partitions (cards subtotal &aux (m 0))
  (declare (type (simple-array fixnum (*)) cards)
           (type fixnum subtotal m))
  (dotimes (i 10 m)
    (when (plusp (elt cards i))
      (let ((total (+ subtotal i 1)))
        (cond ((< total 21)
               (progn (incf m)
                      (decf (elt cards i))
                      (incf m (partitions cards total))
                      (incf (elt cards i))))
              ((eql total 21) (incf m)))))))

(defun main ()
  (let ((deck (make-array 10 :element-type 'fixnum
                             :initial-contents '(4 4 4 4 4 4 4 4 4 10)))
        (d 0))
    (dotimes (i 10)
      (decf (elt deck i))
      (let ((p 0))
        (dotimes (j 10)
          (decf (elt deck j))
          (incf p (partitions deck (1+ j)))
          (incf (elt deck j)))
        (format t "Dealer showing ~A partitions = ~A~%" i p)
        (incf d p)
        (incf (elt deck i))))
    (format t "Total partitions = ~A~%" d)))

(main)
