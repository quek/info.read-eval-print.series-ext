(in-package :info.read-eval-print.series-ext)

(defgeneric scan% (thing))

(defun scan* (thing)
  (declare (optimizable-series-function))
  (producing (z) ((f (scan% thing)) x)
    (loop
      (tagbody
         (setq x x)
         (multiple-value-bind (v p) (funcall f)
           (unless p
             (terminate-producing))
           (setq x v))
         (next-out z x)))))

(defmethod scan% ((ting list))
  (let ((x ting))
    (lambda ()
      (if x
          (let ((car (car x)))
            (setf x (cdr x))
            (values car t))
          (values nil nil)))))

(defmethod scan% ((thing array))
  (let ((i 0)
        (len (length thing)))
    (lambda ()
      (if (= i len)
          (values nil nil)
          (let ((v (aref thing i)))
            (incf i)
            (values v t))))))
