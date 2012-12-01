(in-package :info.read-eval-print.series-ext)

(defgeneric scan% (thing &key &allow-other-keys))

(series::defS scan* (thing &rest args)
  "generic scan."
  (cl:let ((scan% `(scan% ,thing ,@args)))
    (series::fragl
     ;; args
     ((thing t)
      (scan% function))
     ;; rets
     ((value t))
     ;; aux
     ((value t)
      (f function))
     ;; alt
     ()
     ;; prolog
     ((setq f scan%))
     ;; body
     ((multiple-value-bind (v p) (funcall f)
        (declare (ignorable v))
        (unless p
          (go series::end))
        (setq value v)))
     ;; epilog
     ()
     ;; wraprs
     ()
     ;; impure
     nil)))

(defmethod scan% ((ting list) &key)
  (let ((x ting))
    (lambda ()
      (if x
          (let ((car (car x)))
            (setf x (cdr x))
            (values car t))
          (values nil nil)))))

(defmethod scan% ((thing array) &key (start 0) end)
  (let ((i start)
        (end (or end (length thing))))
    (lambda ()
      (if (= i end)
          (values nil nil)
          (let ((v (aref thing i)))
            (incf i)
            (values v t))))))

(defmethod scan% ((thing symbol) &rest args &key)
  (apply #'scan% (find-class thing) args))

#|
(collect (scan* #(1 2 3)))
;⇒ (1 2 3)

(collect (scan* #(1 2 3) :start 1 :end 2))
;⇒ (2)

(defstruct st
  (value 'a)
  (next nil))

(defmethod scan% ((st st) &key)
  (lambda ()
    (if st
        (let ((x st))
          (setf st (st-next st))
          (values x t))
        (values nil nil))))

(let ((st (make-st :value 1 :next (make-st :value 2 :next (make-st :value 3)))))
  (collect (st-value (scan* st))))
;⇒ (1 2 3)
|#
