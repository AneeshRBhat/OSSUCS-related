;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))
(define TANK-WIDTH/2 (/ (image-width TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))
(define INVADER-WIDTH (image-width INVADER))
(define INVADER-HEIGHT (image-height INVADER))
(define HSPACE (rectangle 30 20 "solid" "white"))
(define VSPACE (square 40 "solid" "white"))
  
  
(define END-SCENE (overlay (above (beside TANK HSPACE INVADER HSPACE TANK HSPACE INVADER HSPACE TANK)
                                  VSPACE
                                  (text "GAME OVER!" 40 "red")
                                  VSPACE
                                  (beside INVADER HSPACE TANK HSPACE INVADER HSPACE TANK HSPACE INVADER))
                           BACKGROUND))

;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dir))
;; Invader is (make-invader Number Number Number[-1,1])
;; interp. the invader is at (x, y) in screen coordinates
;;         dir is the direction of the invader along x axis

(define I1 (make-invader 150 100 1))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -1))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 1)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dir invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; Functions
;; ================

;; Game -> Game
;; start the world with ...
;;
(define (main g)
  (big-bang g ; Game
    (on-tick next-game) ; Game -> Game
    (to-draw render) ; Game -> Image
    (stop-when game-end? produce-end-scene) ; Game -> Boolean
    (on-key handle-key))) ; Game KeyEvent -> Game


;; Game -> Game
;; Check the current game state and produce the next one
;; !!!

(define (next-game g)
  (check-game (advance-game  g)))


;; Game -> Game
;; produce the next Game State with each tick
 
(check-expect (advance-game G0)                                               ; Tank Mechanics related
              (make-game empty empty (make-tank (+ (/ WIDTH 2) (* 1 TANK-SPEED)) 1)))
(check-expect (advance-game G1)
              (make-game empty empty (make-tank (+ 50 (* 1 TANK-SPEED)) 1)))
(check-expect (advance-game (make-game empty empty T2))
              (make-game empty empty (make-tank (+ 50 (* -1 TANK-SPEED)) -1)))
(check-expect (advance-game (make-game empty empty (make-tank (- WIDTH TANK-WIDTH/2) 1)))
              (make-game empty empty (make-tank (+ (- WIDTH TANK-WIDTH/2) TANK-SPEED) 1)))
(check-expect (advance-game (make-game empty empty (make-tank TANK-WIDTH/2 -1)))
              (make-game empty empty (make-tank (- TANK-WIDTH/2 TANK-SPEED) -1)))

(check-expect (advance-game (make-game empty                                  ; Missile Mechanics related
                                       (list M1)
                                       T0))
              (make-game empty
                         (list (make-missile 150 (- 300 MISSILE-SPEED)))
                         (move-tank T0)))
(check-expect (advance-game (make-game empty
                                       (list (make-missile 150 300) (make-missile 200 0))
                                       T1))
              (make-game empty
                         (list (make-missile 150 (- 300 MISSILE-SPEED)))
                         (move-tank T1)))
(check-expect (advance-game (make-game empty
                                       (list (make-missile 150 300) (make-missile 200 -10))
                                       T2))
              (make-game empty
                         (list (make-missile 150 (- 300 MISSILE-SPEED)))
                         (move-tank T2)))

(check-expect (advance-game (make-game (list (make-invader 50 300 1))      ;Invader Mechanics related
                                       empty
                                       T0))
              (make-game (list (make-invader (+ 50 INVADER-X-SPEED)
                                             (+ 300 INVADER-Y-SPEED)
                                             1))
                         empty
                         (move-tank T0)))

(check-expect (advance-game (make-game (list (make-invader TANK-WIDTH/2 450 -1) (make-invader 60 450 1))
                                       (list (make-missile 250 75))
                                       T1))
              (make-game (list (make-invader (- TANK-WIDTH/2 INVADER-X-SPEED)
                                             (+ 450 INVADER-Y-SPEED)
                                             -1)
                               (make-invader (+ 60 INVADER-X-SPEED)
                                             (+ 450 INVADER-Y-SPEED)
                                             1))
                         (handle-missiles (list (make-missile 250 75)))
                         (move-tank T1)))

(check-expect (advance-game (make-game (list (make-invader (- WIDTH TANK-WIDTH/2) 450 1) (make-invader 60 450 1))
                                       (list (make-missile 250 75))
                                       T1))
              (make-game (list (make-invader (+ (- WIDTH TANK-WIDTH/2) INVADER-X-SPEED)
                                             (+ 450 INVADER-Y-SPEED)
                                             1)
                               (make-invader (+ 60 INVADER-X-SPEED)
                                             (+ 450 INVADER-Y-SPEED)
                                             1))
                         (handle-missiles (list (make-missile 250 75)))
                         (move-tank T1)))


;; (define (advance-game g) (make-game empty empty T0)) ;Stub
;; <template from Game>
(define (advance-game s)
  (make-game (handle-invaders (game-invaders s))
             (handle-missiles (game-missiles s))
             (move-tank       (game-tank s))))


;; Game -> Game
;; Checks the next game state for collisions

(check-expect (check-game (make-game (list (make-invader 200 60 1))
                                     (list (make-missile 200 60))
                                     T0))
              (make-game empty
                         empty
                         T0))
(check-expect (check-game (make-game (list (make-invader 145 300 -1))
                                     (list (make-missile 145 450))
                                     T1))
              (make-game (list (make-invader 145 300 -1))
                         (list (make-missile 145 450))
                         T1))
(check-expect (check-game (make-game (list (make-invader 145 300 -1) (make-invader 150 250 1))
                                     (list (make-missile 150 250) (make-missile 40 260))
                                     T2))
              (make-game (list (make-invader 145 300 -1))
                         (list (make-missile 40 260))
                         T2))


;; (define (check-game g) g) ;Stub
(define (check-game s)
  (make-game (eliminate-invader (game-invaders s) (game-missiles s))
             (eliminate-missile (game-missiles s) (game-invaders s))
             (game-tank s)))

;; ListOfInvader ListOfMissile -> ListOfInvader
;; Check if Invader and Missile have the same coordinates and eliminate that invader 

(check-expect (eliminate-invader (list (make-invader 215 160 -1) (make-invader 135 450 1))
                                 empty)
              (list (make-invader 215 160 -1) (make-invader 135 450 1)))

(check-expect (eliminate-invader empty
                                 (list (make-missile 215 160) (make-missile 45 60)))
              empty)
                                 
(check-expect (eliminate-invader (list (make-invader 215 160 -1) (make-invader 135 450 1))
                                 (list (make-missile 215 160) (make-missile 45 60)))
              (list (make-invader 135 450 1)))

(check-expect (eliminate-invader (list (make-invader 215 160 -1) (make-invader 135 400 1))
                                 (list (make-missile 230 50)))
              (list (make-invader 215 160 -1) (make-invader 135 400 1)))

;; (define (eliminate-invader loi lom) loi) ;Stub
(define (eliminate-invader loi lom)
  (cond [(empty? loi) empty]
        [else (if (invader-collided? (first loi) lom)
                  (eliminate-invader (rest loi) lom)
                  (cons (first loi)
                        (eliminate-invader (rest loi) lom)))]))

;; Invader ListOfMissile -> Boolean
;; Produce true if Invader has collided with any missile in the list

(check-expect (invader-collided? (make-invader 215 160 -1)
                                 empty)
              false)
(check-expect (invader-collided? (make-invader 215 160 -1)
                                 (list (make-missile 215 160) (make-missile 150 200)))
              true)
(check-expect (invader-collided? (make-invader 160 315 1)
                                 (list (make-missile 215 160)))
              false)

;; (define (invader-collided? invader lom) false) ;Stub
(define (invader-collided? invader lom)
  (cond [(empty? lom) false]
        [else (if (collided? invader (first lom))
                  true
                  (invader-collided? invader (rest lom)))]))


;; ListOfMissile ListOfInvader -> ListOfMissile
;; Check if Missile and Invader have the same coordinates and eliminate that missile

(check-expect (eliminate-missile empty
                                 (list (make-invader 215 160 -1) (make-invader 135 450 1)))
              empty)

(check-expect (eliminate-missile (list (make-missile 215 160) (make-missile 45 60))
                                 empty)
              (list (make-missile 215 160) (make-missile 45 60)))
                                 
(check-expect (eliminate-missile (list (make-missile 215 160) (make-missile 45 60))
                                 (list (make-invader 215 160 -1) (make-invader 135 450 1)))
              (list (make-missile 45 60)))

(check-expect (eliminate-missile (list (make-missile 230 50))
                                 (list (make-invader 215 160 -1) (make-invader 135 400 1)))
              (list (make-missile 230 50)))

;; (define (eliminate-missile lom loi) lom) ;Stub
(define (eliminate-missile lom loi)
  (cond [(empty? lom) empty]
        [else (if (missile-collided? (first lom) loi)
                  (eliminate-missile (rest lom) loi)
                  (cons (first lom)
                        (eliminate-missile (rest lom) loi)))]))
 
;; Missile ListOfInvader -> Boolean
;; Produce true if Missile and Invader in the list have the same coordinates

(check-expect (missile-collided? (make-missile 150 250)
                                 (list (make-invader 150 250 -1)))
              true)
(check-expect (missile-collided? (make-missile 215 469)
                                 (list (make-invader 150 255 1)))
              false)

;; (define (missile-collided? missile loi) false) ;Stub
(define (missile-collided? missile loi)
  (cond [(empty? loi) false]
        [else (if (collided? (first loi) missile)
                  true
                  (missile-collided? missile (rest loi)))]))


;; Invader Missile -> Boolean
;; Produce true if Invader and Missile have the same coordinates

(check-expect (collided? (make-invader 215 175 1)
                         (make-missile 215 175))
              true)
(check-expect (collided? (make-invader 146 450 -1)
                         (make-missile 215 175))
              false)

;; (define (collided? invader missile) false) ;Stub
(define (collided? invader missile)
  (and (<= (- (invader-x invader) INVADER-WIDTH) (missile-x missile) (+ (invader-x invader) INVADER-WIDTH))
       (<= (- (invader-y invader) INVADER-HEIGHT) (missile-y missile) (+ (invader-y invader) INVADER-HEIGHT))))

 

;; Tank Mechanics
;; ===========================================================================================
;; Tank -> Tank
;; Produce the next tank state

(check-expect (move-tank T0) (make-tank (+ (/ WIDTH 2) TANK-SPEED) 1))
(check-expect (move-tank T1) (make-tank (+ 50 TANK-SPEED) 1))
(check-expect (move-tank T2) (make-tank (- 50 TANK-SPEED) -1))
(check-expect (move-tank (make-tank (- WIDTH TANK-WIDTH/2) 1)) (make-tank (+ (- WIDTH TANK-WIDTH/2) TANK-SPEED) 1))
(check-expect (move-tank (make-tank TANK-WIDTH/2 -1)) (make-tank (- TANK-WIDTH/2 TANK-SPEED) -1))

;; (define (move-tank t) t) ;Stub
(define (move-tank t)
  (cond [(> (tank-x t) (- WIDTH TANK-WIDTH/2))
         (make-tank (- WIDTH TANK-WIDTH/2) -1)]
        [(< (tank-x t) TANK-WIDTH/2) 
         (make-tank TANK-WIDTH/2 1)]
        [else (make-tank
               (+ (tank-x t) (* (tank-dir t) TANK-SPEED))
               (tank-dir t))]))




;; Missile Mechanics
;; =========================================================================================


;; ListOfMissiles -> ListOfMissiles
;; Advance and delete missiles whenever required

(check-expect (handle-missiles (list M1))
              (list (make-missile 150 (- 300 MISSILE-SPEED))))
(check-expect (handle-missiles (list M1 (make-missile 40 0)))
              (list (make-missile 150 (- 300 MISSILE-SPEED))))
(check-expect (handle-missiles (list M1 (make-missile 40 450) (make-missile 380 -10)))
              (list (make-missile 150 (- 300 MISSILE-SPEED))
                    (make-missile 40 (- 450 MISSILE-SPEED))))

;; (define (handle-missiles lom) lom) ;Stub
(define (handle-missiles lom)
  (missiles-in-bounds (advance-missiles lom)))

;; ListOfMissiles -> ListOfMissiles
;; Returns the missiles that are inside the frame

(check-expect (missiles-in-bounds (list M1 (make-missile 40 0)))
              (list (make-missile 150 300)))
(check-expect (missiles-in-bounds (list M1 (make-missile 40 450) (make-missile 380 -10)))
              (list (make-missile 150 300)
                    (make-missile 40 450)))

;;(define (missiles-in-bounds lom) lom) ;Stub
(define (missiles-in-bounds lom)
  (cond [(empty? lom) empty]
        [else (if (missile-in? (first lom))
                  (cons (first lom) (missiles-in-bounds (rest lom)))
                  (missiles-in-bounds (rest lom)))]))

;; Missile -> Boolean
;; Produce true if missile is in bounds

(check-expect (missile-in? (make-missile 400 0)) false)
(check-expect (missile-in? (make-missile 350 -10)) false)
(check-expect (missile-in? (make-missile 360 400)) true)
              
;; (define (missile-in? m) false) ;Stub
(define (missile-in? m)
  (> (missile-y m) 0))
  
;; ListOfMissiles -> ListOfMissiles
;; Advance missiles in the upward direction

(check-expect (advance-missiles (list M1))
              (list (make-missile 150 (- 300 MISSILE-SPEED))))


;; (define (advance-missiles lom) lom) ;Stub
(define (advance-missiles lom)
  (cond [(empty? lom) empty]
        [else (cons (advance-missile (first lom))
                    (advance-missiles (rest lom)))]))

;; Missile -> Missile
;; Advance a single missile 

(check-expect (advance-missile (make-missile 50 400))
              (make-missile 50 (- 400 MISSILE-SPEED)))

;; (define (advance-missile m) m)
(define (advance-missile m)
  (make-missile (missile-x m)
                (- (missile-y m) MISSILE-SPEED)))

;; Invader Mechanics
;; ====================================================================================

;; ListOfInvader -> ListOfInvader
;; Spawn, Move and Kill Invaders at appropriate scenarios

(check-expect (handle-invaders (list (make-invader 50 300 1)))
              (list (make-invader (+ 50 INVADER-X-SPEED)
                                  (+ 300 INVADER-Y-SPEED)
                                  1)))
(check-expect (handle-invaders (list (make-invader 250 50 -1)))
              (list (make-invader (+ 250 (* -1 INVADER-X-SPEED))
                                  (+ 50 INVADER-Y-SPEED)
                                  -1)))

(check-expect (handle-invaders (list (make-invader TANK-WIDTH/2 234 -1) (make-invader 250 50 1)))
              (list (make-invader (- TANK-WIDTH/2 INVADER-X-SPEED)
                                  (+ 234 INVADER-X-SPEED)
                                  -1)
                    (make-invader (+ 250 INVADER-X-SPEED)
                                  (+ 50 INVADER-Y-SPEED)
                                  1)))
(check-expect (handle-invaders (list (make-invader (- WIDTH TANK-WIDTH/2) 234 1) (make-invader 250 50 1)))
              (list (make-invader (+ (- WIDTH TANK-WIDTH/2) INVADER-X-SPEED)
                                  (+ 234 INVADER-X-SPEED)
                                  1)
                    (make-invader (+ 250 INVADER-X-SPEED)
                                  (+ 50 INVADER-Y-SPEED)
                                  1)))

;; (define (handle-invaders loi) loi) ;Stub
(define (handle-invaders loi)
  (move-invaders (spawn-invaders loi)))

;; ListOfInvader -> ListOfInvader
;; Spawn an invader at the top of the screen at a random x coordinate [0, WIDTH]


;; (define (spawn-invaders loi) loi) ;Stub

(define (spawn-invaders loi)
  (cond [(< (random INVADE-RATE) 2)
         (cons (make-invader (random (- WIDTH TANK-WIDTH/2)) 0 1) loi)]
        [else loi]))


;; ListOfInvader -> ListOfInvader
;; Produce a list of the next Invader state

;; (define (move-invaders loi) loi) ;Stub

(define (move-invaders loi)
  (cond [(empty? loi) empty]
        [else (cons (move-invader (first loi))
                    (move-invaders (rest loi)))]))

;; Invader -> Invader
;; Change the invader's x and y coordinates and if need be dir

;; (define (move-invader invader) invader) ;Stub
(define (move-invader invader)
  (cond [(> (invader-x invader) (- WIDTH TANK-WIDTH/2))
         (make-invader (- WIDTH TANK-WIDTH/2)
                       (invader-y invader)
                       (*(invader-dir invader) -1))]
        [(< (invader-x invader) TANK-WIDTH/2)
         (make-invader TANK-WIDTH/2
                       (invader-y invader)
                       (* (invader-dir invader) -1))]
        [else (make-invader
               (+ (invader-x invader) (* INVADER-X-SPEED (invader-dir invader)))
               (+ (invader-y invader) INVADER-Y-SPEED)
               (invader-dir invader))]))
  

;; Gameplay and visuals
;; ======================================================================================

;; Game KeyEvent -> Game
;; Move the tank when left or right key is pressed and shoot when space is pressed

(check-expect (handle-key G1 "left")
              (make-game empty empty (make-tank 50 -1)))            ;Changing Direction
(check-expect (handle-key (make-game empty empty T2) "right")
              (make-game empty empty (make-tank 50 1)))

(check-expect (handle-key G1 "right") G1)                           ;Going in the same direction
(check-expect (handle-key (make-game empty empty T2) "left")
              (make-game empty empty T2))

(check-expect (handle-key G1 "a") G1)                               ;Pressing wrong keys         
(check-expect (handle-key (make-game empty empty T2) "b")
              (make-game empty empty T2))

(check-expect (handle-key G0 " ")                                   ;Pressing Space
              (make-game empty
                         (list (make-missile (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2)))
                         (make-tank (/ WIDTH 2) 1)))


;; (define (handle-key g ke) (make-game empty empty T0)) ; Stub
(define (handle-key g ke)
  (cond [(key=? ke "left") (make-game (game-invaders g)
                                      (game-missiles g)
                                      (go-left (game-tank g)))]
        [(key=? ke "right") (make-game (game-invaders g)
                                       (game-missiles g)
                                       (go-right (game-tank g)))]
        [(key=? ke " ") (make-game (game-invaders g)
                                   (launch-missile (game-missiles g) (game-tank g))
                                   (game-tank g))]
        [else g]))

;; ListOfMissile Tank -> ListOfMissile
;; Launch missile from the tank's current x position

(check-expect (launch-missile empty T0) (list (make-missile (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2))))
(check-expect (launch-missile (list (make-missile 150 300)) T1)
              (list (make-missile 50  (- HEIGHT TANK-HEIGHT/2)) (make-missile 150 300)))

;; (define (launch-missile lom t) empty) ;Stub

(define (launch-missile lom t)
  (cons (make-missile (tank-x t) (- HEIGHT TANK-HEIGHT/2)) lom))

;; Tank -> Tank
;; Make the tank go left
(check-expect (go-left T0)
              (make-tank (/ WIDTH 2) -1))
(check-expect (go-left T1)
              (make-tank 50 -1))
(check-expect (go-left T2) T2)

;; (define (go-left t) t) ;Stub
(define (go-left t)
  (make-tank (tank-x t) -1))

;; Tank -> Tank
;; Make the tank go left
(check-expect (go-right T0)
              (make-tank (/ WIDTH 2) 1))
(check-expect (go-right T1)
              (make-tank 50 1))
(check-expect (go-right T2)
              (make-tank 50 1))

;; (define (go-right t) t) ;Stub
(define (go-right t)
  (make-tank (tank-x t) 1))

;; Game -> Boolean
;; Stop the game when an invader hits the bottom of the screen

(check-expect (game-end? (make-game empty
                                    empty
                                    T0))
              false)
(check-expect (game-end? (make-game (list (make-invader 240 (- HEIGHT (/ INVADER-HEIGHT 2)) 1))
                                    empty
                                    T1))
              true)
(check-expect (game-end? (make-game (list (make-invader 240 470 -1) (make-invader 122 39 1))
                                    empty
                                    T2))
              false)

;; (define (game-end? g) false) ;Stub
(define (game-end? s)
  (reached-bottom? (game-invaders s)))

;; ListOfInvader -> Boolean
;; Return true if any invader in the list has reached bottom of the screen

(check-expect (reached-bottom? empty) false)
(check-expect (reached-bottom? (list (make-invader 240 470 -1) (make-invader 122 39 1)))
              false)
(check-expect (reached-bottom? (list (make-invader 240 (- HEIGHT (/ INVADER-HEIGHT 2)) 1)))
              true)

;; (define (reached-bottom? loi) false) ;Stub
(define (reached-bottom? loi)
  (cond [(empty? loi) false]
        [else (if (reached? (first loi))
                  true
                  (reached-bottom? (rest loi)))]))

;; Invader -> Boolean
;; Return true if invader has reached the bottom of the screen

(check-expect (reached? (make-invader 240 (- HEIGHT (/ INVADER-HEIGHT 2)) 1)) true)
(check-expect (reached? (make-invader 240 470 -1)) false)

;; (define (reached? invader) false) ;Stub
(define (reached? invader)
  (>= (invader-y invader) (- HEIGHT (/ INVADER-HEIGHT 2))))


;; Game -> Image
;; render the tank, missiles and enemies at the appropriate position on the screen

(check-expect (render G0) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
(check-expect (render (make-game (list (make-invader 50 300 1) (make-invader 250 480 -1))
                                 (list (make-missile 60 250))
                                 T1))
              (place-image TANK 50 (- HEIGHT TANK-HEIGHT/2)
                           (place-image INVADER 50 300
                                        (place-image INVADER 250 480
                                                     (place-image MISSILE 60 250 BACKGROUND)))))
;; (define (render g) BACKGROUND) ;Stub

(define (render g)
  (render-missiles (game-missiles g)
                   (render-invaders (game-invaders g)
                                    (render-tank (game-tank g)))))

;; ListOfInvader Image -> Image
;; Render invaders on the img
(check-expect (render-invaders (list (make-invader 60 400 -1) (make-invader 250 140 1))
                               BACKGROUND)
              (place-image INVADER 60 400 (place-image
                                           INVADER 250 140 BACKGROUND)))

;; (define (render-invaders loi img) img) ;Stub
(define (render-invaders loi img)
  (cond [(empty? loi) img]
        [else (render-invader (first loi)
                              (render-invaders (rest loi) img))]))

;; Invader Image -> Image
;; Render an invader on an img

(check-expect (render-invader (make-invader 250 150 1) (render-tank T0))
              (place-image INVADER 250 150 (render-tank T0)))

;; (define (render-invader invader img) img) ;Stub
(define (render-invader invader img)
  (place-image INVADER
               (invader-x invader)
               (invader-y invader)
               img))


;; ListOfMissile Image -> Image
;; Render missiles on the img
(check-expect (render-missiles empty (render-tank T0)) (render-tank T0))
(check-expect (render-missiles (list (make-missile 60 200)
                                     (make-missile 250 400))
                               (render-tank T0))
              (place-image MISSILE 60 200
                           (place-image MISSILE 250 400
                                        (render-tank T0))))

;; (define (render-missiles lom img) img) ;Stub

(define (render-missiles lom img)
  (cond [(empty? lom) img]
        [else (render-missile (first lom)
                              (render-missiles (rest lom) img))]))

;; Missile Image -> Image
;; Render a Missile on top of an image

(define (render-missile m img)
  (place-image MISSILE (missile-x m) (missile-y m) img))

;; Tank -> Image
;; Render tank at the appropriate position on the background

(check-expect (render-tank T0) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;; (define (render-tank t) BACKGROUND) ;Stub
(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;; Game -> Image
;; Produce END-SCENE at the end of the game

(define (produce-end-scene g) END-SCENE)