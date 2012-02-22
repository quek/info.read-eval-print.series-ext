;;;; -*- Mode: LISP; -*-
(asdf:defsystem :info.read-eval-print.series-ext
  :version "0.0.0"
  :serial t
  :components ((:file "package")
               (:file "series-ext")
               (:file "fset"))
  :depends-on (series
               cl-ppcre
               fset))
