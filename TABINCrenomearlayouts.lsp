(defun c:TabIncPad-dbhunia (/ pad pre suf digits num)
 ;; Tab Increment, Padded
 ;; Rename layout tabs with number, based on location, padded with
 ;;   prefixed 0's so that all order components have same number of digits
 ;; Prefix and Suffix optional
 ;; Altered/expanded by Kent Cooper from code by Alan J. Thompson
  (defun pad (m / padded) ; fill out with preceding 0's as appropriate
    (setq padded (itoa m))
    (while (< (strlen padded) digits)
      (setq padded (strcat "0" padded))
    ); while
    padded ; return to main routine
  ); defun -- pad
  (setq
    pre (getstring T "\nSpecify prefix <None>: ")
    suf (getstring T "\nSpecify suffix <None>: ")
    digits (strlen (itoa (length (layoutlist))))
    ; how many digits in quantity of Paper-Space Layouts?
    num (1- (cond ((getint "\nSpecify starting number <1>: "))
                  (1)
             )
        )

  ); setq
  (vlax-for x
    (vla-get-layouts
      (cond
        (*AcadDoc*)
        ((setq *AcadDoc* (vla-get-activedocument (vlax-get-acad-object))))
      )
    )
    (vl-catch-all-apply
      (function vla-put-name)
      (list x (strcat pre (pad (+ num (vla-get-taborder x))) suf))
    )
  )
  (princ)
)