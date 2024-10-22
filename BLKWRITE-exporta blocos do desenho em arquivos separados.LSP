;This is the revised version of BLKWRITE that appears in the AutoCAD
;Database Book.  THIS VERSION WILL ONLY WORK WITH AUTOCAD VERSION 2.6 OR
;LATER.  This version will look at ALL of the blocks in a drawing by looking
;at the BLOCK table and then writing all of the blocks out to a disk file
;if they don't already exist.  Otherwise, this version has all of the same
;features that are in the original.
;
;
;
(defun C:blkwrite ( / e blocklist blkcnt a ynlst ylst l excptlist blk)
        (setq cmdmode (getvar "cmdecho")) (setvar "cmdecho" 0)
        (setq blk (tblnext "BLOCK" T))
        (setq blocklist () excptlist () blkcnt 0)
        (while blk
            (setq blkname (cdr (assoc 2 blk)))
            (cond
                (
                 (and (equal (cdr (assoc 0 blk)) "BLOCK")
                    (equal (member blkname blocklist) nil)
                    (equal (member blkname excptlist) nil)
                    (not (equal (substr blkname 1 1) "*")))
                     (if (equal (setq l (open (strcat blkname ".dwg") "r")) nil)
                         (progn
                            (command "wblock" blkname blkname)
                            (setq blocklist (cons blkname blocklist))
                            (terpri) 
                            (setq blkcnt (1+ blkcnt))
                            (princ "Block ") (princ blkname)
                            (princ " written to disk")
                         )
                         (progn
                            (princ "\nDrawing file ") (princ blkname)
                            (princ " already exists...")
                            (close l)
                            (setq excptlist (cons blkname excptlist))
                        )
                    )
                )
            )
            (setq blk (tblnext "BLOCK"))
        )
    (setq a nil)
    (setq ynlst '(0 13 32 78 89 110 121))
    (setq ylst '(0 13 32 89 121))
    (terpri)
    (princ "A total of " ) (princ blkcnt) 
    (princ " blocks were written to disk from this drawing file.")
    (prompt "\nDo you wish to write the block list out to a file?<Y> ")
    (while (equal (member a ynlst) nil)
        (setq a (last (grread)))
    )
    (if (not (equal (member a ylst) nil))
        (wrtlist blocklist excptlist)
    )
    (terpri)
    (gc)
    (setvar "CMDECHO" cmdmode)
    nil
)
(defun wrtlist (blocklist excptlist / blkfilename f g h excptfilename)
    (setq blocklist (reverse blocklist) excptlist (reverse excptlist))
    (setq fname (getvar "dwgname"))
    (princ "\nEnter file name <")
    (princ fname) (setq fname (getstring ">: "))
    (cond ((equal fname "") (setq fname (getvar "dwgname"))))
    (setq blkfilename (strcat fname ".blk"))
    (if (equal (setq g (open blkfilename "r")) nil)
        (progn
            (setq f (open blkfilename "w"))
            (write-line "Blocks written to disk from drawing file " f)
            (princ (getvar "dwgname") f)
            (write-line "" f)
            (while blocklist
                (write-line (car blocklist) f)
                (setq blocklist (cdr blocklist))
            )
            (close f)
            (cond ((not (equal excptlist nil))
                (setq excptfilename (strcat fname ".bex"))
                (setq h (open excptfilename "w"))
            (write-line "Duplicate file name on disk for these blocks from "  h)
                (princ (getvar "dwgname") h)
                (write-line "" f)
                (while excptlist
                    (write-line (car excptlist) h)
                    (setq excptlist (cdr excptlist))
                )
                (close h))
            )
        )
        (progn
            (close g)
            (princ "\nThis file name already exists, please redo")
            (terpri)
            (wrtlist blocklist excptlist)
        )
    )
)








