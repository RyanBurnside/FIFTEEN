(DEFINE-FILE-INFO PACKAGE "INTERLISP" READTABLE "INTERLISP" BASE 10)

(FILECREATED "28-Sep-2025 22:24:54" {DSK}<home>ryan>il>FIFTEEN.LISP;10 13601  

      :CHANGES-TO (FNS FIFTEEN-CLICK-EVENT)

      :PREVIOUS-DATE "28-Sep-2025 22:18:01" {DSK}<home>ryan>il>FIFTEEN.LISP;9)


(PRETTYCOMPRINT FIFTEENCOMS)

(RPAQQ FIFTEENCOMS ((RECORDS FIFTEEN-GAME)
                    (FNS CLAMP CLICK-PIECE DRAW-BUTTON DRAW-GAMEBOARD FIFTEEN-CLICK-EVENT GAMEBOARD 
                         GAMEBOARD-OPEN GAMEBOARD-SIZE GAMEBOARD-SOLVED-P GET-GAMEBOARD 
                         INDEX->POSITION MAKE-FIFTEEN-BOARD MAKE-PT POSITION+ POSITION- 
                         POSITION->INDEX PT-X PT-Y SET-GAMEBOARD SHUFFLE-BOARD START-FIFTEEN 
                         SWAP-TILES TILE-MOVABLE-P WINDOW-MOUSE-POS)))
(DECLARE%: EVAL@COMPILE

(RECORD FIFTEEN-GAME (BOARD FONT WINDOW SELF))
)
(DEFINEQ

(CLAMP
  [LAMBDA (VAL LOWER UPPER)                                 (* ; "Edited  4-Jun-2023 15:11 by ryan")
    (COND
       ((< VAL LOWER)
        LOWER)
       ((> VAL UPPER)
        UPPER)
       (T VAL])

(CLICK-PIECE
  [LAMBDA (BOARD X Y)                                       (* ; "Edited  4-Jun-2023 19:58 by ryan")
    [COND
       ((TILE-MOVABLE-P BOARD X Y)
        (LET* ((POSITION (MAKE-PT X Y))
               (OPEN-POS (GAMEBOARD-OPEN BOARD X Y))
               (X-DIST (fetch XCOORD (POSITION- POSITION OPEN-POS)))
               (Y-DIST (fetch YCOORD (POSITION- POSITION OPEN-POS)))
               [POS-ADDITIVE (MAKE-PT (/ X-DIST (ABS X-DIST))
                                    (/ Y-DIST (ABS Y-DIST]
               (NUM-STEPS (MAX (ABS X-DIST)
                               (ABS Y-DIST)))
               (NEXT-POS (POSITION+ OPEN-POS POS-ADDITIVE)))
              (for I to NUM-STEPS do (SWAP-TILES BOARD OPEN-POS NEXT-POS)
                                     (SETQ OPEN-POS NEXT-POS)
                                     (SETQ NEXT-POS (POSITION+ NEXT-POS POS-ADDITIVE]
    BOARD])

(DRAW-BUTTON
  [LAMBDA (X Y W H TEXT STREAM)                             (* ; "Edited  4-Jun-2023 16:27 by ryan")
                                                            (* ; "Edited 30-May-2023 15:05 by ryan")
                                                            (* ; "Edited 29-May-2023 00:25 by ryan")
                                                            (* ; "Edited 27-May-2023 19:56 by ryan")
    (LET* [(NW (SUB1 W))
           (NH (SUB1 H))
           (P1 (CONS X Y))
           (MID-X (PLUS X (TIMES NW 0.5)))
           (MID-Y (PLUS Y (TIMES NH 0.5)))
           (DSPX (DSPXPOSITION NIL)
                 STREAM)
           (DSPY (DSPYPOSITION NIL)
                 STREAM)
           (S-REGION (STRINGREGION TEXT))
           (TXT-X (DIFFERENCE MID-X (TIMES (fetch WIDTH S-REGION)
                                           0.5)))
           (TXT-Y (DIFFERENCE MID-Y (TIMES (fetch HEIGHT S-REGION)
                                           0.5]
          (DSPXPOSITION TXT-X STREAM)
          (DSPYPOSITION TXT-Y STREAM)
          (PRINT TEXT STREAM)
          (DSPXPOSITION DSPX STREAM)
          (DSPYPOSITION DSPY STREAM)
          (DRAWAREABOX (CAR P1)
                 (CDR P1)
                 NW NH 1 NIL STREAM BLACKSHADE])

(DRAW-GAMEBOARD
  [LAMBDA (B X Y WIDTH HEIGHT STREAM)                       (* ; "Edited  4-Jun-2023 16:38 by ryan")
                                                            (* ; "Edited 31-May-2023 23:35 by ryan")
    (LET* ((D (GAMEBOARD-SIZE B))
           (COLUMNS (CAR D))
           (ROWS (CDR D))
           (BTN-W (/ WIDTH COLUMNS))
           (BTN-H (/ HEIGHT ROWS))
           (TOP-Y (- (+ Y HEIGHT)
                     BTN-H))
           (CUR-INDEX 0))
          (for YY from 0 to (SUB1 ROWS)
             do (for XX from 0 to (SUB1 COLUMNS)
                   do (SETQ CUR-INDEX (GET-GAMEBOARD B XX YY))
                      (if (> CUR-INDEX 0)
                          then (DRAW-BUTTON (+ X (TIMES BTN-W XX))
                                      (- TOP-Y (TIMES BTN-H YY))
                                      BTN-W BTN-H CUR-INDEX STREAM])

(FIFTEEN-CLICK-EVENT
  [LAMBDA (W)                                               (* ; "Edited  4-Jun-2023 20:15 by ryan")
    (LET* ((WREG (WINDOWPROP W 'REGION))
           (BRDR (WINDOWPROP W 'BORDER))
           (NEW-X (+ (fetch LEFT WREG)
                     (/ BRDR 2)))
           (NEW-Y (+ (fetch BOTTOM WREG)
                     (/ BRDR 2)))
           (NEW-WIDTH (WINDOWPROP W 'WIDTH))
           (NEW-HEIGHT (WINDOWPROP W 'HEIGHT))
           [BOARD (CAR (WINDOWPROP W 'BOARD]
           (BOARD-SIZE (GAMEBOARD-SIZE BOARD))
           (BOARD-ROWS (CDR BOARD-SIZE))
           (BOARD-COLUMNS (CAR BOARD-SIZE)))
          (GETMOUSESTATE)
          (LET* [(M-REL-X (- LASTMOUSEX NEW-X))
                 (M-REL-Y (- LASTMOUSEY NEW-Y))
                 (CUR-X (CL:FLOOR (TIMES (/ M-REL-X NEW-WIDTH)
                                         BOARD-COLUMNS)))
                 (CUR-Y (CL:FLOOR (- BOARD-ROWS (TIMES (/ M-REL-Y NEW-HEIGHT)
                                                       BOARD-ROWS]
                (if (AND (GEQ CUR-X 0)
                         (GEQ CUR-Y 0)
                         (< CUR-X BOARD-COLUMNS)
                         (< CUR-Y BOARD-ROWS))
                    then (CLICK-PIECE BOARD CUR-X CUR-Y)
                         (CLEARW W)
                         (DRAW-GAMEBOARD (CAR (WINDOWPROP W 'BOARD))
                                0 0 NEW-WIDTH NEW-HEIGHT W)
                         (if (GAMEBOARD-SOLVED-P BOARD)
                             then (for I from 1 to 3 do (RINGBELLS])

(GAMEBOARD
  [LAMBDA (W H)                                             (* ; "Edited  2-Jun-2023 20:23 by ryan")
                                                            (* ; "Edited 31-May-2023 20:57 by ryan")

         (* WE ADD 1 TO THE INDEX TO PULL EVERYTHING FORWARD SUCH THAT 0 IS AT THE END)

    (LET* ((A (ARRAY W NIL 0 0)))
          (for X from 0 to (- W 1) do (SETA A X (ARRAY H NIL 0 0)))
          [for X from 0 to (SUB1 W) do (for Y from 0 to (SUB1 H)
                                          do (SET-GAMEBOARD A X Y (ADD1 (POSITION->INDEX X Y W]
          (SET-GAMEBOARD A (SUB1 W)
                 (SUB1 H)
                 0)
          A])

(GAMEBOARD-OPEN
  [LAMBDA (BOARD)                                           (* ; "Edited  3-Jun-2023 18:35 by ryan")
                                                            (* ; "Edited  1-Jun-2023 00:28 by ryan")
    (LET* ((D (GAMEBOARD-SIZE BOARD))
           (MAX-X (SUB1 (CAR D)))
           (MAX-Y (SUB1 (CDR D)))
           (CUR-X NIL)
           (CUR-Y NIL))
          [for X from 0 to MAX-X do (for Y from 0 to MAX-Y
                                       do (if (ZEROP (GET-GAMEBOARD BOARD X Y))
                                              then (SETQ CUR-X X)
                                                   (SETQ CUR-Y Y]
          (MAKE-PT CUR-X CUR-Y])

(GAMEBOARD-SIZE
  [LAMBDA (BOARD)                                           (* ; "Edited 31-May-2023 20:31 by ryan")
    (CONS (ARRAYSIZE BOARD)
          (LET ((FIRST (ELT BOARD 0)))
               (if (ARRAYP FIRST)
                   then (ARRAYSIZE FIRST)
                 else 0])

(GAMEBOARD-SOLVED-P
  [LAMBDA (BOARD)                                           (* ; "Edited  4-Jun-2023 10:28 by ryan")
    (LET* ((SIZE (GAMEBOARD-SIZE BOARD))
           (W (SUB1 (CAR SIZE)))
           (H (SUB1 (CDR SIZE)))
           (PREV 0)
           (SOLVED T))
          [for Y from 0 to H
             do (for X from 0 to W
                   do (if (OR (< X W)
                              (< Y W))
                          then (if (< (GET-GAMEBOARD BOARD X Y)
                                      PREV)
                                   then (SETQ SOLVED NIL)
                                 else (SETQ PREV (GET-GAMEBOARD BOARD X Y]
          SOLVED])

(GET-GAMEBOARD
  [LAMBDA (BOARD X Y)                                       (* ; "Edited 31-May-2023 22:22 by ryan")
    (ELT (ELT BOARD X)
         Y])

(INDEX->POSITION
  [LAMBDA (I WIDTH)                                         (* ; "Edited 26-May-2023 00:05 by ryan")
    (CONS (CL:MOD I WIDTH)
          (CL:FLOOR (/ I WIDTH])

(MAKE-FIFTEEN-BOARD
  [LAMBDA (WIDTH HEIGHT)                                     (* ; "")
    (LET* ((SIZE (TIMES WIDTH HEIGHT))
           (TEMP (ARRAY SIZE 0 0 0)))
          (for I from 0 to (1- SIZE) do (SETA TEMP I (1+ I)))
          (SETA TEMP (1- SIZE)
                NIL)
          TEMP])

(MAKE-PT
  [LAMBDA (X Y)                                             (* ; "Edited  3-Jun-2023 16:19 by ryan")
    (create POSITION
           XCOORD _ X
           YCOORD _ Y])

(POSITION+
  [LAMBDA (P1 P2)                                           (* ; "Edited 28-May-2023 23:35 by ryan")
    (create POSITION
           XCOORD _ (+ (fetch XCOORD P1)
                       (fetch XCOORD P2))
           YCOORD _ (+ (fetch YCOORD P1)
                       (fetch YCOORD P2])

(POSITION-
  [LAMBDA (P1 P2)                                           (* ; "Edited 28-May-2023 23:58 by ryan")
    (create POSITION
           XCOORD _ (- (fetch XCOORD P1)
                       (fetch XCOORD P2))
           YCOORD _ (- (fetch YCOORD P1)
                       (fetch YCOORD P2])

(POSITION->INDEX
  [LAMBDA (X Y WIDTH)                                       (* ; "Edited 25-May-2023 23:51 by ryan")
    (+ (TIMES Y WIDTH)
       X])

(PT-X
  [LAMBDA (POSITION)                                        (* ; "Edited  3-Jun-2023 16:20 by ryan")
    (fetch XCOORD POSITION])

(PT-Y
  [LAMBDA (POSITION)                                        (* ; "Edited  3-Jun-2023 16:21 by ryan")
    (fetch YCOORD POSITION])

(SET-GAMEBOARD
  [LAMBDA (BOARD X Y VALUE)                                 (* ; "Edited 31-May-2023 20:22 by ryan")
    (SETA (ELT BOARD X)
          Y VALUE])

(SHUFFLE-BOARD
  [LAMBDA (BOARD)                                           (* ; "Edited  4-Jun-2023 13:19 by ryan")
    (LET* ((SIZE (GAMEBOARD-SIZE BOARD))
           (TRIES (EXPT (TIMES (PT-X SIZE)
                               (PT-Y SIZE))
                        2)))
          (PRINT (CONCAT "PLEASE WAIT ... " "SHUFFLING " TRIES " MOVES!"))
          (for I to TRIES do (LET ((OPEN (GAMEBOARD-OPEN BOARD)))
                                  (if (EVENP I)
                                      then (CLICK-PIECE BOARD (PT-X OPEN)
                                                  (RAND (PT-Y SIZE)))
                                    else (CLICK-PIECE BOARD (RAND (PT-X SIZE))
                                                (PT-Y OPEN])

(START-FIFTEEN
  [LAMBDA (COLUMNS ROWS)                                    (* ; "Edited  4-Jun-2023 19:35 by ryan")
    (LET* ((C (OR COLUMNS 4))
           (R (OR ROWS 4))
           (B (GAMEBOARD C R))
           (W 256)
           (H 256)
           (TITLE-HEIGHT (FONTPROP WindowTitleDisplayStream 'HEIGHT))
           (WIN (CREATEW (CREATEREGION 200 200 W H)
                       "FIFTEEN")))
          (SHUFFLE-BOARD B)
          (WINDOWPROP WIN 'BORDER)
          (WINDOWADDPROP WIN 'BOARD B)
          (WINDOWPROP WIN 'BUTTONEVENTFN (FUNCTION FIFTEEN-CLICK-EVENT))
          (DRAW-GAMEBOARD B 0 0 (- W 8)
                 (- H TITLE-HEIGHT 8)
                 WIN])

(SWAP-TILES
  [LAMBDA (BOARD P1 P2)                                     (* ; "Edited  3-Jun-2023 20:10 by ryan")
    (LET* ((X (fetch XCOORD P1))
           (Y (fetch YCOORD P1))
           (X2 (fetch XCOORD P2))
           (Y2 (fetch YCOORD P2))
           (TEMP (GET-GAMEBOARD BOARD X Y))
           (VAL2 (GET-GAMEBOARD BOARD X2 Y2)))
          (SET-GAMEBOARD BOARD X Y VAL2)
          (SET-GAMEBOARD BOARD X2 Y2 TEMP])

(TILE-MOVABLE-P
  [LAMBDA (BOARD X Y)                                       (* ; "Edited  3-Jun-2023 19:42 by ryan")
                                                            (* ; "Edited  1-Jun-2023 23:29 by ryan")
    (LET* ((OPENING (GAMEBOARD-OPEN BOARD))
           (OPEN-X (CAR OPENING))
           (OPEN-Y (CDR OPENING)))
          (OR (= OPEN-X X)
              (= OPEN-Y Y])

(WINDOW-MOUSE-POS
  [LAMBDA (W)                                               (* ; "Edited  4-Jun-2023 15:37 by ryan")
    (LET* [(REG (WINDOWPROP W 'REGION))
           (W (fetch WIDTH REG))
           (H (fetch HEIGHT REG))
           (REL-X (- LASTMOUSEX (CAR REG)))
           (REL-Y (- LASTMOUSEY (CADR REG]
          (GETMOUSESTATE)
          (PRINT REL-X)
          (TERPRI)
          (PRINT REL-Y)
          (MAKE-PT (CLAMP REL-X 0 W)
                 (CLAMP REL-Y 0 H])
)
(DECLARE%: DONTCOPY
  (FILEMAP (NIL (884 13578 (CLAMP 894 . 1113) (CLICK-PIECE 1115 . 2078) (DRAW-BUTTON 2080 . 3385) (
DRAW-GAMEBOARD 3387 . 4321) (FIFTEEN-CLICK-EVENT 4323 . 5921) (GAMEBOARD 5923 . 6668) (GAMEBOARD-OPEN 
6670 . 7416) (GAMEBOARD-SIZE 7418 . 7731) (GAMEBOARD-SOLVED-P 7733 . 8480) (GET-GAMEBOARD 8482 . 8645)
 (INDEX->POSITION 8647 . 8836) (MAKE-FIFTEEN-BOARD 8838 . 9159) (MAKE-PT 9161 . 9353) (POSITION+ 9355
 . 9685) (POSITION- 9687 . 10017) (POSITION->INDEX 10019 . 10182) (PT-X 10184 . 10335) (PT-Y 10337 . 
10488) (SET-GAMEBOARD 10490 . 10661) (SHUFFLE-BOARD 10663 . 11484) (START-FIFTEEN 11486 . 12185) (
SWAP-TILES 12187 . 12653) (TILE-MOVABLE-P 12655 . 13064) (WINDOW-MOUSE-POS 13066 . 13576)))))
STOP
