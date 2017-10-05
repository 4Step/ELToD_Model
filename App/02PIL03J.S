; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=5
IF (LP=1)
  HR = 5
ELSEIF (LP=2)
  HR = 16
ELSE
  HR = 14
ENDIF
