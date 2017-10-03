; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=2
IF (LP=1)
  HR = 2
ELSEIF (LP=2)
  HR = 7
ELSE
  HR = 11
ENDIF
