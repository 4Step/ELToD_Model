; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

*Del "{SCENARIO_DIR}\Log_Trip_Table_Totals.csv"
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00HWY02B.S"
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY
FILEO MATO[1] = "{SCENARIO_DIR}\Dir2.MAT",
 MO=1-4
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
 
PARAMETERS MAXITERS=1 ZONES={Number of Zones}
PROCESS PHASE=LINKREAD
  T0=LI.DISTANCE/LI.SPEED*60
ENDPROCESS
PROCESS PHASE=ILOOP
  PATHLOAD PATH=TIME, MW[1]=PATHTRACE(LI.DIR1),NOACCESS=0,
    MW[2]=PATHTRACE(LI.DIR2),NOACCESS=0,
    MW[3]=PATHTRACE(LI.DIR3),NOACCESS=0,
    MW[4]=PATHTRACE(LI.DIR4),NOACCESS=0
ENDPROCESS
  
/*PARAMETERS MAXITERS=1 ZONES={Number of Zones}
PROCESS PHASE=LINKREAD
  T0=LI.DISTANCE/LI.SPEED*60
ENDPROCESS
PROCESS PHASE=ILOOP
  PATHLOAD PATH=TIME, MW[1]=PATHTRACE(LI.Dir1),NOACCESS=0,
    MW[2]=PATHTRACE(LI.Dir2),NOACCESS=0,
    MW[3]=PATHTRACE(LI.Dir3),NOACCESS=0,
    MW[4]=PATHTRACE(LI.Dir4),NOACCESS=0
ENDPROCESS*/

ENDRUN


LOOP HR = 1, 24, 1

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

IF (HR=8-10)
  TP = 'AM'
ELSEIF (HR=17-19)
  TP = 'PM'
ELSE
  TP = 'OP'
ENDIF
;*COPY "{Trip Table}Trip Table *.MAT" "{SCENARIO_DIR}"
; End of PILOT Script

; Script for program MATRIX in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00MAT02C.S"
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEO PRINTO[1] = "{SCENARIO_DIR}\Log_Trip_Table_Totals.csv",
   APPEND=T
FILEI MATI[2] = "{SCENARIO_DIR}\Dir2.MAT"
  ;PRNFILE="M:\PROJECTS\D4_6-SOUTHERNCOINBUILD-OUTFORECAST2016\SW10TH ELTODV22_2016-0926\APP\00MAT02A.PRN"
FILEI LOOKUPI[1] = "{Hourly Distribution File}"
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT",
  MO=4-6,NAME=SOV,HOV,TRK
FILEI MATI[1] = "{Trip Table} @TP@.MAT"
LOOKUP LOOKUPI=1, NAME=GETHRFACTOR, LOOKUP[1]=1, RESULT=2, 
                                    LOOKUP[2]=1, RESULT=3,
                                    LOOKUP[3]=1, RESULT=4,
                                    LOOKUP[4]=1, RESULT=5,INTERPOLATE=F
                                                               
MW[1] = MI.1.1 * {Trip Table Factor}  ;SOV
MW[2] = MI.1.2 * {Trip Table Factor}  ;HOV
MW[3] = MI.1.3 * {Trip Table Factor}  ;TRK
MW[11] = MI.2.1 ;North SB Dir_1
MW[12] = MI.2.2 ;North NB Dir_2
MW[13] = MI.2.3 ;South SB Dir_3
MW[14] = MI.2.4 ;South NB Dir_4

JLOOP

IF (MW[11]>0)                               
  MW[4] = MW[1]*GETHRFACTOR(1,@HR@)
  MW[5] = MW[2]*GETHRFACTOR(1,@HR@)
  MW[6] = MW[3]*GETHRFACTOR(1,@HR@)
ELSEIF (MW[12]>0)  
  MW[4] = MW[1]*GETHRFACTOR(2,@HR@)
  MW[5] = MW[2]*GETHRFACTOR(2,@HR@)
  MW[6] = MW[3]*GETHRFACTOR(2,@HR@)
ELSEIF (MW[13]>0)  
  MW[4] = MW[1]*GETHRFACTOR(3,@HR@)
  MW[5] = MW[2]*GETHRFACTOR(3,@HR@)
  MW[6] = MW[3]*GETHRFACTOR(3,@HR@)
ELSE
  MW[4] = MW[1]*GETHRFACTOR(4,@HR@)
  MW[5] = MW[2]*GETHRFACTOR(4,@HR@)
  MW[6] = MW[3]*GETHRFACTOR(4,@HR@)

ENDIF

ENDJLOOP

; Row Total
_SUM = _SUM + ROWSUM(4) + ROWSUM(5) + ROWSUM (6)
IF (I={Number of Zones})
  PRINT CSV=T, LIST=@HR@, _SUM, PRINTO=1
ENDIF

ENDRUN


ENDLOOP

; Script for program MATRIX in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00MAT02D.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Add to AM OD for checking - Part 1 - 4'
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table 9.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table 8.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table 7.MAT"
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table AM.MAT",
  MO=1-3,NAME=SOV,HOV,TRK

MW[1]= MI.1.1 + MI.2.1 + MI.3.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 ; TRK


ENDRUN


; Script for program MATRIX in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00MAT02E.S"
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


; Script for program MATRIX in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00MAT02F.S"
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


; Script for program MATRIX in file "M:\Projects\HEFT ELToDv2.2 2017\APP\00MAT02G.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX PRNFILE="M:\PROJECTS\HEFT ELTODV2.2 2017\APP\00MAT02A.PRN" MSG='Add to Daily OD for checking - Part 4 - 4'
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table Daily.MAT",
    MO=1-3,NAME=SOV,HOV,TRK
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table OP.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table PM.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table AM.MAT"

MW[1]= MI.1.1 + MI.2.1 + MI.3.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 ; TRK

ENDRUN


