;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX PRNFILE="M:\Projects\Veterans ELToDv2.2 2017\APP\00MAT02A.PRN" MSG='Add to Daily OD for checking - Part 4 - 4'
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table Daily.MAT",
    MO=1-3,NAME=SOV,HOV,TRK
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table OP.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table PM.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table AM.MAT"

MW[1]= MI.1.1 + MI.2.1 + MI.3.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 ; TRK

ENDRUN
