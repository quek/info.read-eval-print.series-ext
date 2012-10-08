;;;; -*- Mode: LISP; -*-
(asdf:defsystem :info.read-eval-print.series-ext
  :version "0.0.0"
  :serial t
  :components ((:file "package")
               (:file "generic")
               (:file "fset")
               (:file "series-ext"))
  :depends-on (series
               cl-ppcre
               fset))
