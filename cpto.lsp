(defun C:CPTO (/ loop perim_total sel qtde ent perim)
(setvar "cmdecho" 0)
;(princ "\n Soma cpto. de qq entidade que tenha perímetro...")
(princ "\n Selecione a(s) linha(s) e/ou (lw)polyline(s): ")
(setq loop 0 perim_total 0)
(setq sel (ssget (list (cons 0 "*LINE") )))
(if sel
(progn
(setq qtde (sslength sel))
(command "undo" "group")
(while (> qtde 0)(setq qtde (1- qtde))
(setq ent (ssname sel loop))
(setq tipo (cdr (assoc 0 (entget ent))))
(command "lengthen" ent "")
(princ (strcat " - " tipo))
(setq perim (getvar "perimeter"))
(setq perim_total (+ perim_total perim))
(setq loop (+ loop 1)
)
)
(if sel
(prompt
(strcat
"\n Perímetro Total de " (itoa (sslength sel))
" entidade(s) - " (rtos perim_total 2 3)
))))
)
(princ))
