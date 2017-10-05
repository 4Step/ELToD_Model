; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=8
IF (LP=1)
  HR = 24
ELSEIF (LP=2)
  HR = 19
ELSE
  HR = 21
ENDIF
