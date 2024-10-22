;*Multiplo OFFSET*
(defun C:MOFFSET (/ ent spt dist)
	(setq dist (getdist "Distancia p/ Offset:")
		mdist dist ent (entsel "\nSelecione objeto:")
		spt (getpoint "\nEspecifique o lado:")
		dc  (getdist "\nDistancia a cobrir: ")
		mnum (fix (1+ (/ dc dist)))
	)
	(repeat mnum
		(command "Offset" mdist ent spt "")
		(setq mdist (+ dist mdist))
	)
)



