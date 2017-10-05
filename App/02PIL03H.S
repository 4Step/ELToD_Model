; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=4
IF (LP=1)
  HR = 4
ELSEIF (LP=2)
  HR = 9
ELSE
  HR = 13
ENDIF
