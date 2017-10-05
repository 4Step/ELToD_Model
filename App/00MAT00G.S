;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Convert to dbf file'
FILEO MATO[1] = "{SCENARIO_DIR}\OD_Estimated.DBF",
 MO=1-3, NAME=I,J,MODE,VALUE, FORMAT=DBF, PATTERN=IJM:V
FILEI MATI[1] = "{SCENARIO_DIR}\OD_Estimated.MAT"

MW[1]=MI.1.1

ENDRUN
