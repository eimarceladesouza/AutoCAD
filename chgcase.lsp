;CHGCASE - Altera letras de textos de maiúsculas para minúsculas e vice-versa.
(defun C:CHGCASE (/ TYP ENT ENTG TXT)
  (initget 6 "Upper Lower")
  (setq TYP (getkword "\n \nChange to Upper or Lower case <U>: "))
  (if (= TYP "Upper") (setq TYP nil))
  (while (setq ENT (car (entsel "\nSelect line of text to be changed: ")))
    (setq ENTG (entget ENT))
    (setq TXT (strcase (cdr (assoc 1 ENTG)) TYP))
    (if (= TYP "L") (setq TXT (strcat (strcase (substr TXT 1 1)) (substr TXT 2))))
    (setq ENTG (subst (cons 1 TXT) (assoc 1 ENTG) ENTG))
    (entmod ENTG)
  )
  (princ)
)
