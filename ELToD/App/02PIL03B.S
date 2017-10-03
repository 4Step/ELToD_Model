; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.


DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=1
IF (LP=1)
  HR=1
ELSEIF (LP=2)
  HR=6
ELSE
  HR=10
ENDIF
