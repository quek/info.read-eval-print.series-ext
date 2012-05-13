(cl:in-package :cl)

(macrolet ((m ()
             (let ((series-symbols (loop for symbol being the external-symbols in :series
                                         collect symbol)))
               `(defpackage :info.read-eval-print.series-ext
                  (:use :cl :series)
                  (:shadowing-import-from :series ,@series::/series-forms/)
                  (:import-from :series ,@series-symbols)
                  (:export ,@series-symbols
                           #:scan-directory
                           #:scan-split
                           #:progs
                           #:scan-char-range
                           #:scan-file*
                           #:sdefpackage
                           #:scan-fset
                           #:scan-map
                           #:collect-fset
                           #:collect-map
                           #:scan-file-change
                           #:scan-apply
                           #:scan-apply-while
                           #:scan-combination)))))
  (m))

(series::install :pkg :info.read-eval-print.series-ext :implicit-map t)
