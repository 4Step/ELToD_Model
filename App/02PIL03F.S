; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=3
IF (LP=1)
  HR = 3
ELSEIF (LP=2)
  HR = 8
ELSE
  HR = 12
ENDIF
