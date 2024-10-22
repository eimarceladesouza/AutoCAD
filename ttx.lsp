(defun c:ttx ( / xlCells xlSheet xlSheets xlBook xlBooks xlApp column row drac ss ent expo x)

(vl-load-com)

(setq xlApp (vlax-get-or-create-object "Excel.Application")
xlBooks (vlax-get-property xlApp "Workbooks")
xlBook (vlax-invoke-method xlBooks "Add")
xlSheets (vlax-get-property xlBook "Sheets")
xlSheet (vlax-get-property xlSheets "Item" 1)
xlCells (vlax-get-property xlSheet "Cells"))

(vla-put-visible xlApp :vlax-true)

(setq column 1
row 1
drac -1
ss (ssget "_X" (list (cons 0 "*TEXT"))))

(repeat (sslength ss)
(setq ent (ssname ss (setq drac (1+ drac)))
expo (vla-get-textstring (vlax-ename->vla-object ent)))
(if (<= row 65536)
(vlax-put-property xlCells "Item" row column expo)
(progn
(setq row 1
column (1+ column))
(vlax-put-property xlCells "Item" row column expo)
); /else progn
); /if
(setq row (1+ row))
); /repeat

(mapcar (function (lambda(x)
(vl-catch-all-apply
(function (lambda()
(progn
(vlax-release-object x)
(setq x nil)))))))
(list xlCells xlSheet xlSheets xlBook xlBooks xlApp))

(alert "Close Excel file manually")

(gc)(gc)

(princ)

)magic 
