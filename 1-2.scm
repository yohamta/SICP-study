#lang racket

;; 1.2
;; The ability to visualize the consequences of the actions under consideration
;; is crucial to becoming an expert programmer.
;; To become experts, we must learn to visualize the processes generated by
;; various type of procedures.
;; Only after we have developed such a skill can we learn to reliably
;; construct programs that exhibit the desired behaviour.

;; 1.2.1
;; - recursive process(再帰プロセス)
;; - iterative process(反復プロセス)
;; 再帰と反復の違い
;; 反復プロセスが再帰手続きにより記述されていても定量的な記憶域にて実行される.
;; この実装はtail-recursive(末尾再帰)と呼ばれる.
;; 
;; [末尾再帰(wiki)]
;; 自身の再帰呼び出しが、その計算における最後のステップになっているような
;; 再帰のパターンのことである.
;; 呼び出しではなく、戻り先を保存しないジャンプに最適化できるという特徴がある(末尾呼出最適化)

(require racket/trace)
(define (factorial n)
  (if (= n 1)
    1
    (* n (factorial (- n 1)))))
(trace factorial)
(factorial 5)

;; Result
;; >(factorial 5)
;; > (factorial 4)
;; > >(factorial 3)
;; > > (factorial 2)
;; > > >(factorial 1)
;; < < <1
;; < < 2
;; < <6
;; < 24
;; <120
;; 120


(require racket/trace)
(define (factorial n)
  (fact-iter 1 1 n))
(define (fact-iter product counter max-count)
  (if (> counter max-count)
    product
    (fact-iter (* counter product)
               (+ counter 1)
               max-count)))
(trace factorial)
(factorial 5)

;; Result
;; >(factorial 5)
;; <120
;; 120

;; Excercise 1.9

(require racket/trace)
(define (+ a b)
  (if (= a 0) b (inc (+ (dec a) b))))
(trace +)
(+ 3 3)
;; -> recursive process

(require racket/trace)
(define (+ a b)
  (if (= a 0) b (+ (dec a) (inc b))))
(trace +)
(+ 3 3)
;; -> iterative process

;; 1.2.2 tree recursion

;; Tree recursion Example
;; But it does so much redundunt computation
;; The process uses a number of steps that grows exponentially with the input.
(require racket/trace)
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))
(trace fib)
(fib 5)

;; Iterative Example
(require racket/trace)
(define (fib n)
  (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0)
    b
    (fib-iter (+ a b) a (- count 1))))
(trace fib)
(fib 5)

;; 両替パターンを数えるアルゴリズム
(define (count-change amount) (cc amount 6))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 50)
        ((= kinds-of-coins 5) 100)
        ((= kinds-of-coins 6) 500)))
(count-change 200)

;; Excercise 1.11

;; recursive process
(define (f n)
  (if (< n 3)
    n
    (+ (f (- n 1))
       (* 2 (f (- n 2)))
       (* 3 (f (- n 3))))))
(f 20)

(require racket/trace)
(define (f n)
  (if (< n 3) n (f-iter 2 1 0 n)))
(define (f-iter a b c count)
  (if (< count 3)
    a
    (f-iter (+ a (* 2 b) (* 3 c))
            a
            b
            (- count 1))))
(trace f)
(f 20)

;; Excercise 1.12

;; version 1
(require racket/trace)
(define (triangle-vals vals idx)
  (cond ((= idx 0)
         (append (list (car vals)) (triangle-vals vals (+ idx 1))))
        ((= (length vals) 1)
         (list (car vals)))
        (else
          (append 
            (list (+ (car vals) (car (cdr vals))))
            (triangle-vals (cdr vals) (+ idx 1))))))
(define (triangle-vals-iter vals n k)
  (if (= k n)
    vals
    (triangle-vals-iter (triangle-vals vals 0) n (+ k 1))))
(define (print-triangle-iter n k)
  (display (format "~a~n" (triangle-vals-iter '(1) k 0)))
  (if (= k n)
    (display "")
    (print-triangle-iter n (+ k 1))))
(define (pascal-triangle n)
  (print-triangle-iter n 0))
(pascal-triangle 3)

;; version 2
(define (pt column row)
  (cond ((= column 0) 1)
        ((= row column) 1)
        (else 
          (+ (pt (- column 1) (- row 1)) (pt column (- row 1))))))
(display (format "~a" (pt 0 0)))
(display (format "~a ~a" (pt 0 1) (pt 1 1)))
(display (format "~a ~a ~a" (pt 0 2) (pt 1 2) (pt 2 2)))

