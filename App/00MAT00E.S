;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Convert Trip Table from csv'
FILEI MATI[1] = "M:\KN815LW\I95_XLTOD\CUBE\INPUT\HEFT\TRIP TABLE.CSV",
 FIELDS=#1,2,0,3-5,PATTERN=IJM:V
FILEO MATO[1] = "M:\KN815LW\I95_XLTOD\CUBE\INPUT\HEFT\TRIP TABLE.MAT",
 MO=1-3, NAME=AM,OP,PM
ZONES=19
MW[1] = MI.1.1
MW[2] = MI.1.2
MW[3] = MI.1.3
ENDRUN
