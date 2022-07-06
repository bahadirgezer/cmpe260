#lang racket

(provide (all-defined-out))

(define grade (lambda (labs midterms final attendance) 
        (apply +
                (apply + (map (lambda (elem) (/ elem 6)) labs))
                (apply + (map (lambda (elem) (/ elem 4)) midterms))
                (* final 0.15)
                (list attendance)
        )))

;(grade '(30 28.5 30 27.5 28.4 24.9) '(76 97.5) 91 5)

; (integral  3 'x 4)
; (integral 'x 7)
; c: constant term, x: variable, p: power term
(define integral (lambda args
                (if 
                        (= 3 (length args)) 
                        (integrate (first args) (second args) (third args)) 
                        (integrate 1 (first args) (second args))
                )
        )
)

(define none? 
        (lambda (pred args)
                (cond
                        [(empty? args) #t]
                        [((eval pred) (first args)) #f]
                        [else (none? pred (rest args))]

                )

        )

)

(define myandmap (lambda (procedure args)
                (if 
                        (empty? args)
                        #t
                        (if 
                                ((eval procedure) (first args))
                                (myandmap procedure (rest args))
                                #f
                        )
                )
        )
)

(define ormapeven (lambda (args) 
                (if 
                        (empty? args)
                        #f
                        (if 
                                (even? (first args)) 
                                #t 
                                (ormapeven (rest args))
                        )
                )
        )
)

(define andmapeven (lambda (args) 
                (if 
                        (empty? args)
                        #t
                        (if 
                                (even? (first args)) 
                                (andmapeven (rest args)) 
                                #f
                        )
                )
        )
)

(define integrate (lambda (c x p)
                (let* ([p (+ p 1)] [c (/ c p)])
                (list c x p))
        )
)
