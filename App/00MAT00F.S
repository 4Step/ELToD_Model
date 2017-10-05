;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table_Daily.MAT",
 MO=1, NAME=DAILY
FILEI MATI[1] = "{Trip Table}"

MW[1] = MI.1.1+MI.1.2+MI.1.3
ENDRUN
