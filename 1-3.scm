;; 1.3 Formulating Abstractions with High-Order Procedures
;;     高階プロシージャによる抽象化
;; One of the things we should demand from a powerful programming language is 
;; the ability to build abstractions by assigning names to common patterns 
;; and then to work in terms of the abstractions directly. 
;; Procedures provide this ability. 
;; 
;; This is why all but most primitive programming language include
;; mechanism for defining procedures.

;; High-Order Procedures
;; Procedures that manipulate procedures called higher-order procedures.
;;

;; 1.3.1
(define (sum-integers a b)
  (if (> a b) 0
    (+ a (sum-integers (+ a 1) b))))
(sum-integers 1 3)

(define (cube a) (* a a a))
(define (sum-cubes a b)
  (if (> a b) 0
    (+ (cube a)
       (sum-cubes (+ 1 a) b))))
(sum-cubes 1 3)

;; pi-sum converges to pi/8 (very slowly)
(define (pi-sum a b)
  (if (> a b)
    0
    (+ (/ 1.0 (* a (+ a 2)))
       (pi-sum (+ a 4) b))))
(* (pi-sum 1 1000) 8)

;; Procedures as Arguments
(define (sum term a next b)
  (if (> a b)
    0
    (+ (term a)
       (sum term (next a) next b))))
(define (inc n) (+ n 1))
(define (cube a) (* a a a))
(define (sum-cubes a b)
  (sum cube a inc b))
(sum-cubes 1 10)
(define (identity x) x)
(define (sum-integers a b)
  (sum identity a inc b))
(sum-integers 1 10)
(define (pi-sum a b)
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))
(* 8 (pi-sum 1 1000))
(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

;; 定積分：∫ x^3dx = [1/4 * x^4](1,0) = (1/4*1^4) - (1/4*0^4) = 0.25
(integral cube 0 1 0.01)
(integral cube 0 1 0.001)

;; 3x^2
(define (cube2 a)
  (* 3 (* a a)))
(integral cube2 0 10 0.01)
(sum cube 0 add-dx 0.01)

;; Exercise 1.29
;; Simpson's Rule
;; which is a more accurate method of numerical integration.

(define (sum term a next b)
  (if (> a b)
    0
    (+ (term a)
       (sum term (next a) next b))))
(define (sr f a b n)
  (define (inc n) (+ n 1))
  (define h (/ (- b a) n))
  (define (y-val k)
    (f (+ a (* k h))))
  (define (term k)
    (* (y-val k) (if (even? k) 2 4)))
  (* h (/ (+ (sum term 1 inc (- n 1))
             (y-val 0) (y-val n))
          3)))

(sr cube 0 1 100)
; > (sr cube 0 1 100)
; 1/4

;; Exercise 1.30

;; Improved sum procedure to be a Iterative Process
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (+ result (term a)))))
  (iter a 0))
(define (sr f a b n)
  (define (inc n) (+ n 1))
  (define h (/ (- b a) n)) (define (y-val k)
    (f (+ a (* k h))))
  (define (term k)
    (* (y-val k) (if (even? k) 2 4)))
  (* h (/ (+ (sum term 1 inc (- n 1))
             (y-val 0) (y-val n))
          3)))
(sr cube 0 1 100)

;; Exercise 1.31

; a)
(define (product term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (* result (term a)))))
  (iter a 1))
(define (factorial x)
  (define (inc a) (+ a 1))
  (define (term a) a)
  (product term 2 inc x))
(factorial 5)

; Calc approximations to Pi
(define (product term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (* result (term a)))))
  (iter a 1))
(define (calc-pi x)
  (define (inc a) (+ a 1))
  (define (square a) (* a a))
  (define (term a)
    (let ((numer (* 2 a)))
      (/ (* numer (+ 2 numer))
         (square (+ numer 1)))))
  (* (product term 1 inc x) 4.0))
(calc-pi 1000)

; b)
(define (product term a next b)
  (if (> a b)
    1
    (* (term a) (product term (next a) next b))))
(define (calc-pi x)
  (define (inc a) (+ a 1))
  (define (square a) (* a a))
  (define (term a)
    (let ((numer (* 2 a)))
      (/ (* numer (+ 2 numer))
         (square (+ numer 1)))))
  (* (product term 1 inc x) 4.0))
(calc-pi 1000)

;; Exercise 1.32

; a)
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (combiner (term a) result))))
  (iter a null-value))
(define (sum term a next b)
  (accumulate + 0 term a next b))
(define (identity a) a)
(define (inc a) (+ 1 a))
(define (f b)
  (sum identity 0 inc b))
(f 10)

(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (combiner (term a) result))))
  (iter a null-value))
(define (product term a next b)
  (accumulate * 1 term a next b))
(define (calc-pi x)
  (define (inc a) (+ a 1))
  (define (square a) (* a a))
  (define (term a)
    (let ((numer (* 2 a)))
      (/ (* numer (+ 2 numer))
         (square (+ numer 1)))))
  (* (product term 1 inc x) 4.0))
(calc-pi 1000)

;; Exercise 1.33
; I don't do this for saving time.

;; 1.3.2 Using Lambda

(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (combiner (term a) result))))
  (iter a null-value))
(define (sum term a next b)
  (accumulate + 0 term a next b))
(define (pi-sum a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2))))
       a
       (lambda (x) (+ x 4))
       b))
(* (pi-sum 1 1000) 8)
(define (integral f a b dx)
  (* (sum f
          (+ a (/ dx 2.0))
          (lambda (x) (+ x dx))
          b)
     dx))

; 定積分 ∫ 3*x^2 = [1/3*3*x^3]3,1 = 3^3 - 1^3 = 27 - 1 = 26
; 定積分 ∫ 3*x^2 = [1/3*3*x^3]5,4 = 5^3 - 4^3 = 125 - 64 = 61
(define (cube2 a)
  (* 3 (* a a)))
(integral cube2 4 5 0.001)

; 無名手続きの呼び出し
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y)) ; a
   (- 1 y)))     ; b
(f 3 2)

;; Exercise 1.34
(define (f g) (g 2))
(define (square a) (* a a))
(f square)
(f (lambda (z) (* z (+ z 1))))
(f f)
; application: not a procedure;
;  expected a procedure that can be applied to arguments
;   given: 2
; [,bt for context]

;; 1.3.3
;; half-interval method

(define (average a b) (/ (+ a b) 2))
(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
      midpoint
      (let ((test-value (f midpoint)))
        (cond ((positive? test-value)
               (search f neg-point midpoint))
              ((negative? test-value)
               (search f midpoint pos-point))
              (else midpoint))))))
(define (close-enough? x y) (< (abs (- x y)) 0.001))
(define (half-interval-method f a b)
  (let ((a-value (f a))
        (b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
           (search f a b))
          ((and (negative? b-value) (positive? a-value))
           (search f b a))
          (else (error "Values are not of opposite sign" a b)))))
(half-interval-method sin 2.0 4.0)

;; Searching for the root of the equation
;; x^3 - 2*x - 3 = 0
;; between 1 and 2
(half-interval-method (lambda (x) (- (* x x x) (* 2 x) 3))
                      1.0
                      2.0)

;; Finding fixed points(不動点) of functions
;; f(x) = xを満たすx

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))

; We can use this method to approximate fixed point of the cosine function
(let ((result (fixed-point cos 1.0)))
  (display (format "result = ~a\n" result))
  (display (format "cos(result) = ~a\n" (cos result))))
; result = 0.7390822985224023
; cos(result) = 0.7390870426953322

;; y = sin y + cos y:
;; finding y
(fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0)

;; searching square root
;; y^2 = x
;; y = x/y
;; Unfortunately, this search does not converge.
(define (sqrt x)
  (fixed-point (lambda (y) (/ x y)) 1.0))
(sqrt 9)

;; fixed version(Average Dumping)
;; y = 1/2(y + x/y)
;; This technique is called "average damping"(平均減衰)
(define (sqrt x)
  (define (average x y) (/ (+ x y) 2))
  (fixed-point (lambda (y) (average y (/ x y))) 1.0))
(sqrt 9)
; > (sqrt 9)
; 3.0
; > (sqrt 35)
; 5.916079783099616

;; Exercise 1.35
;; 1 + 1/x
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))
;; Approximating the golden ratio(1 : 1.618)
;; x^2 = x + 1
;; x = 1 + 1/x
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)

;; Exercise 1.36
;; Average Damping
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess step)
    (let ((next (f guess)))
      (display (format "step(~a): ~a\n" step next))
      (if (close-enough? guess next)
        next
        (try next (+ 1 step)))))
  (try first-guess 1))
; x^x = 1000
; x = log(1000)/log(x)
(fixed-point (lambda (x) 
               (/ (log 1000.0) (log x))) 2)
; ...
; step(30): 4.555517548417651
; step(31): 4.555547679306398
; step(32): 4.555527808516254
; step(33): 4.555540912917957
; step(34): 4.555532270803653
; 4.555532270803653

;; Not Average Damping
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess step)
    (let ((next (f guess)))
      (display (format "step(~a): ~a\n" step next))
      (if (close-enough? guess next)
        next
        (try next (+ 1 step)))))
  (try first-guess 1))
; x^x = 1000
; x = log(1000)/log(x)
(define (f)
  (define (average x y) (/ (+ x y) 2))
  (fixed-point (lambda (x)
                 (average (/ (log 1000.0) (log x)) x)) 2))
(f)
; step(1): 5.9828921423310435
; step(2): 4.922168721308343
; step(3): 4.628224318195455
; step(4): 4.568346513136242
; step(5): 4.5577305909237005
; step(6): 4.555909809045131
; step(7): 4.555599411610624
; step(8): 4.5555465521473675
; step(9): 4.555537551999825
; 4.555537551999825

;; Exercise 1.37






