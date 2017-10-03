;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Add to OP OD for checking - Part 3 - 4'
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table OP.MAT",
    MO=1-3,NAME=SOV,HOV,TRK
FILEI MATI[18] = "{SCENARIO_DIR}\Trip Table 24.MAT"
FILEI MATI[17] = "{SCENARIO_DIR}\Trip Table 23.MAT"
FILEI MATI[16] = "{SCENARIO_DIR}\Trip Table 22.MAT"
FILEI MATI[15] = "{SCENARIO_DIR}\Trip Table 21.MAT"
FILEI MATI[14] = "{SCENARIO_DIR}\Trip Table 20.MAT"
FILEI MATI[13] = "{SCENARIO_DIR}\Trip Table 16.MAT"
FILEI MATI[12] = "{SCENARIO_DIR}\Trip Table 15.MAT"
FILEI MATI[11] = "{SCENARIO_DIR}\Trip Table 14.MAT"
FILEI MATI[10] = "{SCENARIO_DIR}\Trip Table 13.MAT"
FILEI MATI[9] = "{SCENARIO_DIR}\Trip Table 12.MAT"
FILEI MATI[8] = "{SCENARIO_DIR}\Trip Table 11.MAT"
FILEI MATI[7] = "{SCENARIO_DIR}\Trip Table 10.MAT"
FILEI MATI[6] = "{SCENARIO_DIR}\Trip Table 6.MAT"
FILEI MATI[5] = "{SCENARIO_DIR}\Trip Table 5.MAT"
FILEI MATI[4] = "{SCENARIO_DIR}\Trip Table 4.MAT"
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table 3.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table 2.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table 1.MAT"


MW[1]= MI.1.1 + MI.2.1 + MI.3.1 + MI.4.1 + MI.5.1 + MI.6.1 + MI.7.1 + MI.8.1 + MI.9.1 + MI.10.1 + MI.11.1 + MI.12.1 + MI.13.1 + MI.14.1 + MI.15.1 + MI.16.1 + MI.17.1 + MI.18.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 + MI.4.2 + MI.5.2 + MI.6.2 + MI.7.2 + MI.8.2 + MI.9.2 + MI.10.2 + MI.11.2 + MI.12.2 + MI.13.2 + MI.14.2 + MI.15.2 + MI.16.2 + MI.17.2 + MI.18.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 + MI.4.3 + MI.5.3 + MI.6.3 + MI.7.3 + MI.8.3 + MI.9.3 + MI.10.3 + MI.11.3 + MI.12.3 + MI.13.3 + MI.14.3 + MI.15.3 + MI.16.3 + MI.17.3 + MI.18.3 ; TRK


ENDRUN
