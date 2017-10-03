; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Add to PM OD for checking - Part 2 - 4'
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table 19.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table 18.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table 17.MAT"
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table PM.MAT",
  MO=1-3,NAME=SOV,HOV,TRK

MW[1]= MI.1.1 + MI.2.1 + MI.3.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 ; TRK

ENDRUN
