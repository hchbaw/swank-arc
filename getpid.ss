#lang scheme/base

(require mzlib/foreign) (unsafe!)
(provide getpid)

(define getpid (get-ffi-obj 'getpid #f (_fun -> _int)))
