(cl:in-package :cl)

(macrolet ((m ()
             (let ((series-symbols (loop for symbol being the external-symbols in :series
                                         collect symbol))
                   (export-symbols '(#:scan-directory
                                     #:scan-split
                                     #:progs
                                     #:scan-char-range
                                     #:scan-file*
                                     #:sdefpackage)))
               `(defpackage :info.read-eval-print.series-ext
                  (:use :cl :series)
                  (:shadowing-import-from :series ,@series::/series-forms/)
                  (:import-from :series ,@series-symbols)
                  (:export ,@series-symbols
                           ,@export-symbols
                           #:scan-fset
                           #:scan-map
                           #:collect-fset
                           #:collect-map
                           #:scan-file-change)))))
  (m))

(series::install :pkg :info.read-eval-print.series-ext :implicit-map t :macro nil)
