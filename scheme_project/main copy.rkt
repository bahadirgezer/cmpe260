#lang racket

(provide (all-defined-out))

; 1: 10 points
(define := (lambda (var value) (cons var (cons value '()))))

; 2: 10 points
(define -- (lambda args (:= 'let args)))

; 3: 10 points
(define @ (lambda (bindings expr) (append bindings expr)))

; 4: 20 points
(define split_at_delim (lambda (delim args)
                         (sasad delim args '() '())))

; sasad means split_and_spit_at_delim
(define sasad (lambda (delim to_split group spitted) (cond
                                                       [(empty? to_split) (append spitted (cons group '()))]
                                                       [(eq? (first to_split) delim) (sasad delim (rest to_split) '() (append spitted (cons group '())))]
                                                       [else (sasad delim (rest to_split) (append group (list(first to_split))) spitted)]
                                                       )))




;(define convert_infix (lambda (line delim) (append (cons delim '()) (foldr append '() (split_at_delim delim line)))
(define convert_infix (lambda (line delim) (append (cons delim '()) (split_at_delim delim line))))

(define assignment (lambda (assign_list) (let ([assign_var (first assign_list)] [value_var (third assign_list)])
                                               (cond 
                                               [(number? value_var) (:= (append (cons assign_var '()) (cons value_var '())))]
                                               [else (:= (append (cons assign_var '()) value_var))]
                                               ))))

(define binding (lambda binding_list (cond
                                       ;[(and (list? (first binding_list)) (= 1 (length binding_list))) (binding (first binding_list))]
                                       [(and (= 4 (length (first binding_list))) (eqv? '-- (fourth (first binding_list))) (eqv? ':= (second (first binding_list)))) (-- (:= (first (first binding_list)) (third (first binding_list))))]
                                       ;[(< 4 (length binding_list)) (cons (binding (take binding_list 4)) (binding (drop binding_list 4))) ];cons?
                                       
                                       [else (display "binding error")]
                                       )))

(define parse_expr (lambda (expr) 
	))


(define parse_expr (lambda (expr)
                                         (cond
                                           [(empty? expr) expr]
                                           [(not (list? expr)) expr]
                                           
                                           [(ormap (lambda (token) (eq? token '+)) expr) (let ([splitted (split_at_delim '+ expr)]) (cons '+ (let ([expr_head (parse_expr(first splitted))] [expr_tail (parse_expr (rest splitted))])
                                                                                                                                               (cond
                                                                                                                                                 [(and (list? expr_head) (list? expr_tail) (= 1 (length expr_head))) (append expr_head expr_tail)]
                                                                                                                                                 [(and (list? expr_head) (= 1 (length expr_head))) (append expr_head (cons expr_tail '()))]
                                                                                                                                                 [else (cons expr_head expr_tail)]))))]
                                           
                                                                  
                                           [(ormap (lambda (token) (eq? token '*)) expr) (let ([splitted (split_at_delim '* expr)]) (cons '* (let ([expr_head (parse_expr(first splitted))] [expr_tail (parse_expr (rest splitted))])
                                                                                                                                               (cond
                                                                                                                                                 [(and (list? expr_head) (list? expr_tail) (= 1 (length expr_head))) (append expr_head expr_tail)]
                                                                                                                                                 [(and (list? expr_head) (= 1 (length expr_head))) (append expr_head (cons expr_tail '()))]
                                                                                                                                                 [else (cons expr_head expr_tail)]))))]
                    
                                           
                                           [(ormap list? expr) (let ([parsed_head (parse_expr (first expr))]) (cond
                                                                                                                                                       [(and (< 2 (length expr)) (eqv? '@ (second expr))) (append (@ (binding (first expr)) (parse_expr (third expr))) (parse_expr (drop expr 4)))]
                                                                                                                                                       [(and (= 1 (length (first expr))) (list? parsed_head) (list? (parse_expr (rest expr)))) (append parsed_head (parse_expr (rest expr)))]
                                                                                                                                                       [(and (= 1 (length (first expr))) (list? parsed_head) (append parsed_head (cons (parse_expr (rest expr)) '())))]
                                                                                                                                                       [else (cons parsed_head (parse_expr (rest expr)))]
                                                                                                                                                       
                                                                                                                                                       ;[(and (not (list? parsed_head)) (not (list? parsed_tail))) (list parsed_head parsed_tail)]
                                                                                                                                                       
                                                                                                                                                       ;[(and (not (list? parsed_head)) (list? parsed_tail)) (cons parsed_head parsed_tail)]; ? list
                                                                                                                                                       
                                                                                                                                                       ;[(and (= 1 (length (first expr))) (list? parsed_head) (list? parsed_tail)) (append parsed_head parsed_tail)]
                                                                                                                                                       ;[(and (= 1 (length (first expr))) (list? parsed_head) (list? parsed_tail)) (append parsed_head parsed_tail)]
                                                                                                                                                       ;[(and (list? parsed_head) (list? parsed_tail)) (append parsed_head parsed_tail)]
                    
                                                                                                                                                       ))]
                                                                                                                                                       
                                                                 ;[(and (= 1 (length (first expr))) (list? parsed_head) (list? parsed_tail)) (append parsed_head parsed_tail)]
                                                                 ;[(and (= 1 (length (first expr))) (list? parsed_head) (append parsed_head (cons parsed_tail '())))]
                                                                 ;[else (cons parsed_head parsed_tail)]))
                                                               ;]
                                           
                                           [(and (ormap (lambda (token) (eq? token '@)) expr) (< 2 (length expr))) (@ (first expr) (parse_expr (third expr)))]
                                           
                    
                                           [(ormap list? expr) (cond
                                                                 [(and (= 1 (length (first expr))) (not(list? (first expr)))) (empty? (rest expr)) (first expr)]
                                                                 [(and (= 1 (length (first expr))) (list? (first expr)) (list? (rest expr))) (append (parse_expr (first expr)) (parse_expr (rest expr)))]
                                                                 [(and (= 1 (length (first expr))) (list? (first expr))) (append (parse_expr (first expr)) (cons (parse_expr (rest expr)) '()))]
                                                                 [(and (< 1 (length (first expr))) (list? (first expr))) (append (parse_expr (first expr)) (cons (parse_expr (rest expr)) '()))]
                                                                 [else (cons (parse_expr (first expr)) (parse_expr (rest expr)))])]
                    
                                           
                    
                                          
                                           [(number? (first expr)) (if (empty? (rest expr))
                                                                       (first expr)
                                                                       (cons (first expr) (parse_expr (rest expr))))]
                    
                                           [else (display "31")]
                                           )))
                                   



;(append (take '(5 * (1 + 2) * 6) 2) (foldr cons (rest (drop '(5 * (1 + 2) * 6) 2)) (car (drop '(5 * (1 + 2) * 6) 2))))
; 6: 20 points
(define eval_expr (lambda (expr) 0))
