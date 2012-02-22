(in-package :info.read-eval-print.series-ext)

(series::defS scan-fset (fset)
  "(scan fset)

SCAN returns a series containing the elements of fset."
  (series::fragl ((fset))               ; args
                 ((items t))            ; rets
                 ((items t)             ; aux
                  (fsetptr t fset)
                  (seqp boolean))
                 ()                                           ; alt
                 ((setq seqp (fset:seq? fset)))               ; prolog
                 ((if (fset:empty? fsetptr) (go series::end)) ; body
                  (if seqp
                      (progn
                        (setq items (fset:first fsetptr))
                        (setq fsetptr (fset:less-first fsetptr)))
                      (progn
                        (setq items (fset:arb fsetptr))
                        (setq fsetptr (fset:less fsetptr items)))))
                 ()                     ; epilog
                 ()                     ; wraprs
                 nil))                  ; impure

(series::defS scan-map (map)
  "(scan map)

Scans the entries of the fset:map and returns two series containing
the keys and their associated values.  The first element of key series
is the key of the first entry in the fset:map, and the first element
of the values series is the value of the first entry, and so on.  The
order of scanning the fset:map is not specified."
  (series::fragl ((map))               ; args
                 ((keys t) (values t)) ; rets
                 ((keys t) (values t)  ; aux
                  (mapptr t map))
                 ()                                          ; alt
                 ()                                          ; prolog
                 ((if (fset:empty? mapptr) (go series::end)) ; body
                  (multiple-value-bind (key val) (fset:arb mapptr)
                    (setq keys key)
                    (setq values val))
                  (setq mapptr (fset:less mapptr keys)))
                 ()                     ; epilog
                 ()                     ; wraprs
                 nil))

(series::defS collect-fset (seq-type &optional (items nil items-p))
  "(collect-fset [type] series)

Creates a fset containing the elements of SERIES.  The TYPE
argument specifies the type of fset to be created.  This type must
be fset:bag or fset:seq or fset:set.  If omitted, TYPE defaults to fset:bag. "
  (let ()
    (unless items-p
      (setq items seq-type)
      (setq seq-type 'fset:bag))
    (cond ((eq seq-type 'fset:bag)
           (series::fragl ((items t)) ((bag))
                          ((bag 'fset:bag (fset:bag)))
                          ()
                          ()
                          ((setq bag (fset:with bag items)))
                          ()
                          ()
                          nil))
          ((eq seq-type 'fset:seq)
           (series::fragl ((items t)) ((seq))
                          ((seq 'fset:seq (fset:seq)))
                          ()
                          ()
                          ((setq seq (fset:with seq (fset:size seq) items)))
                          ()
                          ()
                          nil))
          ((eq seq-type 'fset:set)
           (series::fragl ((items t)) ((set))
                          ((set 'fset:set (fset:set)))
                          ()
                          ()
                          ((setq set (fset:with set items)))
                          ()
                          ()
                          nil))))
  :trigger t)

(series::defS collect-map (keys values &optional default-value)
  "(collect-map keys values)

Combines a series of keys and a series of values together into a map of fset.
default-value is defalt of fset:empty-map."
  (series::fragl ((keys t) (values t) (default-value t))
                 ((map))
                 ((map 'fset:map (fset:empty-map default-value)))
                 ()
                 ()
                 ((setq map (fset:with map keys values)))
                 ()
                 ()
                 nil)
  :trigger t)


#|
(collect-fset (* (scan-fset (fset:set 1 2 3))
                 (scan-fset (fset:seq 1 2 3))
                 (scan-fset (fset:bag 1 2 3))
                 (scan-fset (fset:map (1 'a) (2 'b) (3 'c)))))
;;=> #{% 1 16 81 %}

(collect-fset (scan-fset (fset:seq 1 2 2 3)))
;;=> #{% 1 (2 2) 3 %}
(collect-fset 'fset:bag (scan-fset (fset:seq 1 2 2 3)))
;;=> #{% 1 (2 2) 3 %}
(collect-fset 'fset:seq (scan-fset (fset:seq 1 2 2 3)))
;;=> #[ 1 2 2 3 ]
(collect-fset 'fset:set (scan-fset (fset:seq 1 2 2 3)))
;;=> #{ 1 2 3 }

(multiple-value-bind (k v)
    (scan-map (fset:map ('a 1) ('b 2) ('c 3)))
  (collect-map v k 'not-found))
;;=> #{| (1 A) (2 B) (3 C) |}/NOT-FOUND
|#
