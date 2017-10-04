Trip_Table=-1
; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01NET00B.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Network for Assignment'
FILEO PRINTO[1] = "{SCENARIO_DIR}\Attributes.csv"
FILEI LINKI[5] = "{Directional Link File}",
VAR=A,B,DIR1,DIR2,DIR3,DIR4
FILEI LINKI[4] = "{Cap Spd Link File}",
VAR=A,B,HRCAP,FFSPD
FILEI LINKI[3] = "{Express Lane Link File}",
VAR=A,B,FTYPE
FILEI LINKI[2] = "{Toll Link File}",
VAR=A,B,TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net_1.NET",
INCLUDE = TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL,DISTANCE,SPEED,NUM_LANES,FTYPE,CAPACITY,DIR1,DIR2,DIR3,DIR4
FILEI LINKI[1] = "{Network}"
ZONES = {Number of Zones}
MERGE RECORD=FALSE

;Print Header
_Cnt=_Cnt+1

IF (_Cnt=1)
  PRINT CSV=T, LIST='A,B,DISTANCE,NUMBER OF LANES,FACILITY TYPE,FREE FLOW SPEED,CAPACITY PER LANE',PRINTO=1
  
ENDIF

;Toll segment number
IF(LI.2.TOLLSEGNUM>0)
  TOLLSEGNUM = LI.2.TOLLSEGNUM
ELSE
  TOLLSEGNUM = 0
ENDIF

;Toll segment length
IF(LI.2.TOLLSEGLEN>0)
  TOLLSEGLEN = LI.2.TOLLSEGLEN
ENDIF

;Minimum segment toll
IF(LI.2.MINSEGTOLL>0)
  MINSEGTOLL = LI.2.MINSEGTOLL
ENDIF

;Distance
IF({Distance}=0)
  DISTANCE=0.001
ELSE
  DISTANCE = {Distance};/100
ENDIF

;Number of Lanes
IF({Number of Lanes}=0)
  NUM_LANES = 0 ;1
ELSE
  NUM_LANES = {Number of Lanes}
ENDIF

IF({Number of Lanes}=0) ABORT MSG='***Number of Lanes = 0 - Review Network File***'

;Facility Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF({Facility Type}=0)
  FTYPE = 52
ELSEIF({Facility Type}=90)
  FTYPE = 10
ELSE
  FTYPE = {Facility Type}
ENDIF

;Free Flow Speed
IF({Free Flow Speed}>0)
  SPEED = {Free Flow Speed}
/*ELSEIF(LI.1.TIME2=0)
  SPEED = 999*/
ELSE
  SPEED = {Free Flow Speed} ;{Distance}/LI.1.TIME2*60
ENDIF

;Capacity per lane per hour
IF({Capacity per Lane}=0)
  CAPACITY = 9999
ELSEIF(LI.4.HRCAP>0)
  CAPACITY = LI.4.HRCAP
ELSE
  CAPACITY = {Capacity per Lane};/10/LI.1.NUM_LANES
ENDIF

;DIR
;IF(LI.5.DIR1=1)
  ;DIR1 = 1
IF (LI.5.A=LI.1.A && LI.5.B=LI.1.B)
  DIR1=LI.5.Dir1
  DIR2=LI.5.Dir2
  DIR3=LI.5.Dir3
  DIR4=LI.5.Dir4
ELSE
  DIR1=0
  DIR2=0
  DIR3=0
  DIR4=0  
ENDIF

;Print Attributes
PRINT CSV=T, LIST=A(10.0L),B(10.0L),{Distance}(10.4L),{Number of Lanes}(5.0L),{Facility Type}(5.0L),{Free Flow Speed}(5.3L),{Capacity per Lane}(5.0L),PRINTO=1
;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise 
ENDRUN


; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01HWY00E.S"
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY MSG='Directional Matrix'
FILEO MATO[1] = "{SCENARIO_DIR}\Dir.MAT",
MO=1-4
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net_1.NET"

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

ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01NET00D.S"
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Toll Link Distance'
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\Assign_Input_Net_1.NET"

IF (LI.1.FTYPE = {Toll Link FTYPE Number})
  TL_DIST = LI.1.DISTANCE
ELSE
  TL_DIST = 0
ENDIF

ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
IF ('{Trip Table Type}'='Daily')
  Trip_Table = 1
ELSEIF('{Trip Table Type}'='Hourly')
  Trip_Table = 2
ELSEIF('{Trip Table Type}'='PK_OP')
  Trip_Table = 3
ENDIF


; End of PILOT Script

If (Trip_Table=1)
  goto Trip_Table_1
Elseif (Trip_Table=2)
  goto Trip_Table_2
Elseif (Trip_Table=3)
  goto Trip_Table_3
Else
  PRINT LIST='Application Error: No Branch Selected from Branch Control "Trip Table"'
  ABORT
Endif

:Trip_Table_1
; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

*Del "{SCENARIO_DIR}\Log_Trip Table Totals.csv"

; End of PILOT Script

LOOP IterNum = 1, 24, 1

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

; End of PILOT Script

; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\App\00MAT00A.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEO PRINTO[1] = "{SCENARIO_DIR}\Log_Trip Table Totals.csv",
  APPEND=T
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEI MATI[1] = "{Trip Table}"
FILEI LOOKUPI[1] = "{Hourly Distribution File}"
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table @IterNum@.MAT",
 MO=4-6,NAME=SOV,HOV,TRK
LOOKUP LOOKUPI=1, NAME=GETHRFACTOR, LOOKUP[1]=1, RESULT=2, 
                                    LOOKUP[2]=1, RESULT=3,
                                    LOOKUP[3]=1, RESULT=4,
                                    LOOKUP[4]=1, RESULT=5,INTERPOLATE=F
                                                               
MW[1] = MI.1.1 * {Trip Table Factor}   ;SOV
MW[2] = MI.1.2 * {Trip Table Factor}   ;HOV
MW[3] = MI.1.3 * {Trip Table Factor}   ;TRK
MW[11] = MI.2.1 ;North SB Dir_1
MW[12] = MI.2.2 ;North NB Dir_2
MW[13] = MI.2.3 ;South SB Dir_3
MW[14] = MI.2.4 ;South NB Dir_4

JLOOP
  IF (MW[11]>0)  ;In DIR1                            
    MW[4] = MW[1]*GETHRFACTOR(1,@IterNum@)
    MW[5] = MW[2]*GETHRFACTOR(1,@IterNum@)
    MW[6] = MW[3]*GETHRFACTOR(1,@IterNum@)
  ELSEIF (MW[12]>0)  
    MW[4] = MW[1]*GETHRFACTOR(2,@IterNum@)
    MW[5] = MW[2]*GETHRFACTOR(2,@IterNum@)
    MW[6] = MW[3]*GETHRFACTOR(2,@IterNum@)
  ELSEIF (MW[13]>0)  
    MW[4] = MW[1]*GETHRFACTOR(3,@IterNum@)
    MW[5] = MW[2]*GETHRFACTOR(3,@IterNum@)
    MW[6] = MW[3]*GETHRFACTOR(3,@IterNum@)
  ELSE
    MW[4] = MW[1]*GETHRFACTOR(4,@IterNum@)
    MW[5] = MW[2]*GETHRFACTOR(4,@IterNum@)
    MW[6] = MW[3]*GETHRFACTOR(4,@IterNum@)
ENDIF

ENDJLOOP

; Row Total
_SUM = _SUM + ROWSUM(4) + ROWSUM(5) + ROWSUM (6)
IF (I={Number of Zones})
  PRINT CSV=T, LIST=@IterNum@, _SUM, PRINTO=1
ENDIF

/*

; Original Script 

LOOKUP LOOKUPI=1, NAME=GETHRFACTOR, LOOKUP[1]=1, RESULT=2, 
                                    LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
                                                               
MW[1] = MI.1.1 * {Trip Table Factor}
MW[2] = MI.1.2 * {Trip Table Factor}
MW[3] = MI.1.3 * {Trip Table Factor}

JLOOP
  IF (MI.2.1>0)  ;In DIR1                            
    MW[11] = MW[1]*GETHRFACTOR(1,@IterNum@)
    MW[12] = MW[2]*GETHRFACTOR(1,@IterNum@)
    MW[13] = MW[3]*GETHRFACTOR(1,@IterNum@)
  ELSE  
    MW[11] = MW[1]*GETHRFACTOR(2,@IterNum@)
    MW[12] = MW[2]*GETHRFACTOR(2,@IterNum@)
    MW[13] = MW[3]*GETHRFACTOR(2,@IterNum@)
  ENDIF
ENDJLOOP
*/

ENDRUN


ENDLOOP

goto Trip_Table_END

:Trip_Table_2
; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.


*COPY "{Trip Table}Trip Table *.MAT" "{SCENARIO_DIR}"
; End of PILOT Script

goto Trip_Table_END

:Trip_Table_3
; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

*Del "{SCENARIO_DIR}\Log_Trip_Table_Totals.csv"
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00HWY02B.S"
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
ELSEIF (HR=16-18)
  TP = 'PM'
ELSE
  TP = 'OP'
ENDIF
;*COPY "{Trip Table}Trip Table *.MAT" "{SCENARIO_DIR}"
; End of PILOT Script

; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02C.S"
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

; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02D.S"
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


; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02E.S"
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


; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02F.S"
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


; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02G.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX PRNFILE="M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00MAT02A.PRN" MSG='Add to Daily OD for checking - Part 4 - 4'
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table Daily.MAT",
    MO=1-3,NAME=SOV,HOV,TRK
FILEI MATI[3] = "{SCENARIO_DIR}\Trip Table OP.MAT"
FILEI MATI[2] = "{SCENARIO_DIR}\Trip Table PM.MAT"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table AM.MAT"

MW[1]= MI.1.1 + MI.2.1 + MI.3.1 ; SOV

MW[2]= MI.1.2 + MI.2.2 + MI.3.2 ; HOV

MW[3]= MI.1.3 + MI.2.3 + MI.3.3 ; TRK

ENDRUN


goto Trip_Table_END

:Trip_Table_END
; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
IF({Use Cube Cluster}=1)
  *Cluster ELTOD 1-8 Start Exit
ENDIF
; End of PILOT Script

LOOP LP = 1, 3, 1

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.


DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=1
IF (LP=1)
  HR=1
ELSEIF (LP=2)
  HR=6
ELSE
  HR=10
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03A.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN" MSG='Highway Assignment'
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]               ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L), 'NTL_CM_TIME'(10L), 'TL_CM_TIME'(10L), PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant, MW[17](10.4),MW[27](10.4), PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L), 'NTL_CM_TIME'(10L), 'TL_CM_TIME'(10L), PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant, MW[37](10.4),MW[87](10.4), PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=2
IF (LP=1)
  HR = 2
ELSEIF (LP=2)
  HR = 7
ELSE
  HR = 11
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03B.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=3
IF (LP=1)
  HR = 3
ELSEIF (LP=2)
  HR = 8
ELSE
  HR = 12
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03C.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=4
IF (LP=1)
  HR = 4
ELSEIF (LP=2)
  HR = 9
ELSE
  HR = 13
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03D.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=5
IF (LP=1)
  HR = 5
ELSEIF (LP=2)
  HR = 16
ELSE
  HR = 14
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03E.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=6
IF (LP=1)
  HR = 22
ELSEIF (LP=2)
  HR = 17
ELSE
  HR = 15
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03F.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=7
IF (LP=1)
  HR = 23
ELSEIF (LP=2)
  HR = 18
ELSE
  HR = 20
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03G.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
 
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L), 'NTL_CM_TIME'(10L), 'TL_CM_TIME'(10L), PRINTO=1 
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant, MW[17](10.4),MW[27](10.4), PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),'NTL_CM_TIME'(10L), 'TL_CM_TIME'(10L), PRINTO=3, PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant, MW[37](10.4),MW[87](10.4), PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),'DUMMY_TIME'(15L), PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),'MaxCorrection', PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0), LW.DUMMY_TIME(10.4), PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum   
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    

    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

DistributeMULTISTEP ProcessID='ELTOD', ProcessNum=8
IF (LP=1)
  HR = 24
ELSEIF (LP=2)
  HR = 19
ELSE
  HR = 21
ENDIF
; End of PILOT Script

; Script for program HIGHWAY in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\02HWY03H.S"
;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
      ;Min trip toll is applied to HOV unless it is free.
      IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
        MW[33] = {Min Trip Toll}
      ENDIF
      IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
        MW[43] = {Min Trip Toll}
      ENDIF
      IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
        MW[83] = {Min Trip Toll}
      ENDIF
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
    
    
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
          
    LW.TOLL = _TollRate_Current 
  
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
    
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN


; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

EndDistributeMULTISTEP
; End of PILOT Script

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

Wait4Files Files=ELTOD1.script.end, Files=ELTOD2.script.end, Files=ELTOD3.script.end, Files=ELTOD4.script.end,
Files=ELTOD5.script.end, Files=ELTOD6.script.end, Files=ELTOD7.script.end, Files=ELTOD8.script.end,
CheckReturnCode=T

; End of PILOT Script

ENDLOOP

; PILOT Script
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.


IF({Use Cube Cluster}=1)
  *Cluster ELTOD 1-8 Close Exit
ENDIF
; End of PILOT Script

; PILOT Script
FILEO PRINTO[1] = "{SCENARIO_DIR}\Parameters.PRN"

PRINT CSV=T, LIST= 'Input Files'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Network File'(50L), '{Network}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Link File'(50L), '{Toll Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Directional Link File'(50L), '{Directional Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Pull Link File'(50L), '{Pull Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Cap Speed File'(50L), '{Cap Spd Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Express Lane Link File'(50L), '{Express Lane Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Link FTYPE Number'(50L), '{Toll Link FTYPE Number}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  HOV Link FTYPE Number'(50L), '{HOV Link FTYPE Number}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table Type'(50L), '{Trip Table Type}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table Factor'(50L), '{Trip Table Factor}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table File'(50L), '{Trip Table}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Hourly Distribution File'(50L), '{Hourly Distribution File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Number of Zones'(50L), '{Number of Zones}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Link Attribute Name'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Distance'(50L), '{Distance}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Number of Lanes'(50L), '{Number of Lanes}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Facility Type'(50L), '{Facility Type}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Free Flow Speed'(50L), '{Free Flow Speed}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Capacity per Line'(50L), '{Capacity per Lane}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Assignment Parameters'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Assignment Method'(50L), '{Assignment Method}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Max Iteration'(50L), '{Max Iteration}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Relative Gap'(50L), '{Relative Gap}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Min Link Congested Speed'(50L), '{Min Link Congested Speed}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use Cube Cluster'(50L), '{Use Cube Cluster}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Pricing Policy'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Minimum Per Segment Toll'(50L), '{Min Per Segment Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Maximum Per Segment Toll'(50L), '{Max Per Segment Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use Minimum Per Segment Toll in Network'(50L), '{Override Minimum Per Segment Toll in Network}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Minimum Per Trip Toll'(50L), '{Min Trip Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  HOV Discount Rate'(50L), '{HOV Discount Rate}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Policy Curve Exponent Coefficient'(50L), '{Toll Exponent}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  VC Toll Offset'(50L), '{VC Toll Offset}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Volume Delay Function Parameters'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Volume Delay Function'(50L), '{Volume Delay Function}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik P'(50L), '{Akcelik P}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik T'(50L), '{Akcelik T}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik pb'(50L), '{Akcelik pb}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik Offset'(50L), '{Akcelik Offset}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  BPR Alpha'(50L), '{BPR Alpha}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  BPR Beta'(50L), '{BPR Beta}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use BPR Coefficients in Network'(50L), '{Override BPR Coefficients in Network}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Choice Model Coefficients'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Hourly Parameters'(50L), '{Hourly Parameters}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Coefficient (beta)'(50L), '{Toll Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Travel Time Coefficient (alpha)'(50L), '{Travel Time Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Coefficient'(50L), '{Reliability Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Time Coefficient Gamma'(50L), '{Reliability Time Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Distance Coefficient Eta'(50L), '{Reliability Distance Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Coefficient Steepness'(50L), '{Perceived Time Coefficient Alpha}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Mid Point VC Ratio'(50L), '{Perceived Time Min VC Ratio}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Max VC Ratio'(50L), '{Perceived Time Max VC Ratio}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty Y'(50L), '{Distance Penalty Y}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty X1'(50L), '{Distance Penalty X1}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty X2'(50L), '{Distance Penalty X2}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  One Express Lane Time Weight'(50L), '{One Express Lane Time Weight}'(90L),PRINTO=1

; End of PILOT Script

LOOP HR = 1, 24, 1

; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01NET00C.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK
FILEI LINKI[2] = "{Pull Link File}",
VAR=A,B,PULLLINK,SEG
FILEO PRINTO[1] = "{SCENARIO_DIR}\VOL@HR@.CSV"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET"

PHASE=INPUT
  _CNT = 0
PHASE=LINKMERGE
  _CNT = _CNT + 1
  IF (_CNT = 1)
    PRINT CSV=T, LIST='A'(5R),'B'(5R),'TOTAL_VOL'(10R),'SOV_GU_VOL'(10R),'SOV_MLF_VOL'(15R),'SOV_MLT_VOL'(15R),'HOV_GU_VOL'(10R),'HOV_MLF_VOL'(15R),'HOV_MLT_VOL'(15R),'TRK_GU_VOL'(10R),'TRK_ML_VOL'(10R),'CSPD'(10R),'VC_RATIO'(10R),'TOLL'(10R),'TIME'(10R),PRINTO=1
  ENDIF
  IF (LI.2.PULLLINK = 1)
    PRINT CSV=T, LIST=A(5.0),B(5.0),V_1(10.0), V1_1(10.0), V2_1(15.0), V3_1(15.0), V4_1(10.0), V5_1(10.0),V6_1(15.0),V7_1(15.0), V8_1(10.0),
        DISTANCE/LW_CGTIME_1*60(10.2), VC_1(10.2), LW_TOLL_REV_1(10.2), LW_CGTIME_1(15.6),PRINTO=1
  ENDIF
ENDPHASE

ENDRUN


; Script for program MATRIX in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01MAT00B.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEO PRINTO[1] = "{SCENARIO_DIR}\REV@HR@.CSV"
FILEI MATI[1] = "{SCENARIO_DIR}\REV@HR@.MAT"

MW[1] = MI.1.3
MW[2] = MI.1.6

_ROWSUM_SOV = _ROWSUM_SOV + ROWSUM(1)
_ROWSUM_HOV = _ROWSUM_HOV + ROWSUM(2)

IF(I=ZONES)
  PRINT CSV=T, LIST='TIMEPERIOD'(10R),'SOV'(10R),'HOV'(10R),PRINTO=1
  PRINT CSV=T, LIST=@HR@(10),_ROWSUM_SOV(10.2),_ROWSUM_HOV(10.2),PRINTO=1
ENDIF

ENDRUN


ENDLOOP

; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00K.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='AM'
FILEO NETO = "{SCENARIO_DIR}\LOADED_AM.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1,LW_TOLL_REV_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_HOUR10.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR9.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR8.NET"

MERGE RECORD=FALSE
V_HR8_SOV = LI.1.V1_1 + LI.1.V2_1 + LI.1.V3_1 
V_HR8_HOV = LI.1.V4_1 + LI.1.V5_1 + LI.1.V6_1
V_HR8_TRK = LI.1.V7_1 + LI.1.V8_1

V_HR9_SOV = LI.2.V1_1 + LI.2.V2_1 + LI.2.V3_1 
V_HR9_HOV = LI.2.V4_1 + LI.2.V5_1 + LI.2.V6_1
V_HR9_TRK = LI.2.V7_1 + LI.2.V8_1

V_HR10_SOV = LI.3.V1_1 + LI.3.V2_1 + LI.3.V3_1 
V_HR10_HOV = LI.3.V4_1 + LI.3.V5_1 + LI.3.V6_1
V_HR10_TRK = LI.3.V7_1 + LI.3.V8_1

V_HR8_TOT = V_HR8_SOV + V_HR8_HOV + V_HR8_TRK
V_HR9_TOT = V_HR9_SOV + V_HR9_HOV + V_HR9_TRK
V_HR10_TOT = V_HR10_SOV + V_HR10_HOV + V_HR10_TRK

AM_SOV = V_HR8_SOV + V_HR9_SOV + V_HR10_SOV
AM_HOV = V_HR8_HOV + V_HR9_HOV + V_HR10_HOV
AM_TRK = V_HR8_TRK + V_HR9_TRK + V_HR10_TRK

AM_TOT = AM_SOV + AM_HOV + AM_TRK

; VC Ratio
VC_RATIO_HR8 = LI.1.VC_1
VC_RATIO_HR9 = LI.2.VC_1
VC_RATIO_HR10 = LI.3.VC_1

; Toll
TOLL_HR8 = LI.1.LW_TOLL_REV_1
TOLL_HR9 = LI.2.LW_TOLL_REV_1
TOLL_HR10 = LI.3.LW_TOLL_REV_1

; Congested Speed (CSPD)
CSPD_HR8 = LI.1.DISTANCE/LI.1.LW_CGTIME_1*60
CSPD_HR9 = LI.2.DISTANCE/LI.2.LW_CGTIME_1*60
CSPD_HR10 = LI.3.DISTANCE/LI.3.LW_CGTIME_1*60

; MSA Time
TIME_HR8 = LI.1.LW_CGTIME_1
TIME_HR9 = LI.2.LW_CGTIME_1
TIME_HR10 = LI.3.LW_CGTIME_1

;V_HR8_SL = LI.1.V11_1+LI.1.V12_1+LI.1.V13_1+LI.1.V14_1+LI.1.V15_1+LI.1.V16_1+LI.1.V17_1+LI.1.V18_1
;V_HR9_SL = LI.2.V11_1+LI.2.V12_1+LI.2.V13_1+LI.2.V14_1+LI.2.V15_1+LI.2.V16_1+LI.2.V17_1+LI.2.V18_1
;V_HR10_SL = LI.3.V11_1+LI.3.V12_1+LI.3.V13_1+LI.3.V14_1+LI.3.V15_1+LI.3.V16_1+LI.3.V17_1+LI.3.V18_1
;AM_TOT_SL = V_HR8_SL+V_HR9_SL+V_HR10_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00L.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='PM'
FILEO NETO = "{SCENARIO_DIR}\LOADED_PM.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1,LW_TOLL_REV_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_HOUR19.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR18.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR17.NET"

MERGE RECORD=FALSE
V_HR17_SOV = LI.1.V1_1 + LI.1.V2_1 + LI.1.V3_1 
V_HR17_HOV = LI.1.V4_1 + LI.1.V5_1 + LI.1.V6_1
V_HR17_TRK = LI.1.V7_1 + LI.1.V8_1

V_HR18_SOV = LI.2.V1_1 + LI.2.V2_1 + LI.2.V3_1 
V_HR18_HOV = LI.2.V4_1 + LI.2.V5_1 + LI.2.V6_1
V_HR18_TRK = LI.2.V7_1 + LI.2.V8_1

V_HR19_SOV = LI.3.V1_1 + LI.3.V2_1 + LI.3.V3_1 
V_HR19_HOV = LI.3.V4_1 + LI.3.V5_1 + LI.3.V6_1
V_HR19_TRK = LI.3.V7_1 + LI.3.V8_1

V_HR17_TOT = V_HR17_SOV + V_HR17_HOV + V_HR17_TRK
V_HR18_TOT = V_HR18_SOV + V_HR18_HOV + V_HR18_TRK
V_HR19_TOT = V_HR19_SOV + V_HR19_HOV + V_HR19_TRK

PM_SOV = V_HR17_SOV + V_HR18_SOV + V_HR19_SOV
PM_HOV = V_HR17_HOV + V_HR18_HOV + V_HR19_HOV
PM_TRK = V_HR17_TRK + V_HR18_TRK + V_HR19_TRK

PM_TOT = PM_SOV + PM_HOV + PM_TRK

; VC Ratio
VC_RATIO_HR17 = LI.1.VC_1
VC_RATIO_HR18 = LI.2.VC_1
VC_RATIO_HR19 = LI.3.VC_1

; Toll
TOLL_HR17 = LI.1.LW_TOLL_REV_1
TOLL_HR18 = LI.2.LW_TOLL_REV_1
TOLL_HR19 = LI.3.LW_TOLL_REV_1

; Congested Speed (CSPD)
CSPD_HR17 = LI.1.DISTANCE/LI.1.LW_CGTIME_1*60
CSPD_HR18 = LI.2.DISTANCE/LI.2.LW_CGTIME_1*60
CSPD_HR19 = LI.3.DISTANCE/LI.3.LW_CGTIME_1*60

; MSA Time
TIME_HR17 = LI.1.LW_CGTIME_1
TIME_HR18 = LI.2.LW_CGTIME_1
TIME_HR19 = LI.3.LW_CGTIME_1

;V_HR17_SL = LI.1.V11_1+LI.1.V12_1+LI.1.V13_1+LI.1.V14_1+LI.1.V15_1+LI.1.V16_1+LI.1.V17_1+LI.1.V18_1
;V_HR18_SL = LI.2.V11_1+LI.2.V12_1+LI.2.V13_1+LI.2.V14_1+LI.2.V15_1+LI.2.V16_1+LI.2.V17_1+LI.2.V18_1
;V_HR19_SL = LI.3.V11_1+LI.3.V12_1+LI.3.V13_1+LI.3.V14_1+LI.3.V15_1+LI.3.V16_1+LI.3.V17_1+LI.3.V18_1
;PM_TOT_SL = V_HR17_SL+V_HR18_SL+V_HR19_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00M.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='MD'
FILEI LINKI[6] = "{SCENARIO_DIR}\LOADED_HOUR16.NET"
FILEI LINKI[5] = "{SCENARIO_DIR}\LOADED_HOUR15.NET"
FILEI LINKI[4] = "{SCENARIO_DIR}\LOADED_HOUR14.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_MD.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1,LW_TOLL_REV_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_HOUR13.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR12.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR11.NET"

MERGE RECORD=FALSE
V_HR11_SOV = LI.1.V1_1 + LI.1.V2_1 + LI.1.V3_1 
V_HR11_HOV = LI.1.V4_1 + LI.1.V5_1 + LI.1.V6_1
V_HR11_TRK = LI.1.V7_1 + LI.1.V8_1

V_HR12_SOV = LI.2.V1_1 + LI.2.V2_1 + LI.2.V3_1 
V_HR12_HOV = LI.2.V4_1 + LI.2.V5_1 + LI.2.V6_1
V_HR12_TRK = LI.2.V7_1 + LI.2.V8_1

V_HR13_SOV = LI.3.V1_1 + LI.3.V2_1 + LI.3.V3_1 
V_HR13_HOV = LI.3.V4_1 + LI.3.V5_1 + LI.3.V6_1
V_HR13_TRK = LI.3.V7_1 + LI.3.V8_1

V_HR14_SOV = LI.4.V1_1 + LI.4.V2_1 + LI.4.V3_1 
V_HR14_HOV = LI.4.V4_1 + LI.4.V5_1 + LI.4.V6_1
V_HR14_TRK = LI.4.V7_1 + LI.4.V8_1

V_HR15_SOV = LI.5.V1_1 + LI.5.V2_1 + LI.5.V3_1 
V_HR15_HOV = LI.5.V4_1 + LI.5.V5_1 + LI.5.V6_1
V_HR15_TRK = LI.5.V7_1 + LI.5.V8_1

V_HR16_SOV = LI.6.V1_1 + LI.6.V2_1 + LI.6.V3_1 
V_HR16_HOV = LI.6.V4_1 + LI.6.V5_1 + LI.6.V6_1
V_HR16_TRK = LI.6.V7_1 + LI.6.V8_1

V_HR11_TOT = V_HR11_SOV + V_HR11_HOV + V_HR11_TRK
V_HR12_TOT = V_HR12_SOV + V_HR12_HOV + V_HR12_TRK
V_HR13_TOT = V_HR13_SOV + V_HR13_HOV + V_HR13_TRK
V_HR14_TOT = V_HR14_SOV + V_HR14_HOV + V_HR14_TRK
V_HR15_TOT = V_HR15_SOV + V_HR15_HOV + V_HR15_TRK
V_HR16_TOT = V_HR16_SOV + V_HR16_HOV + V_HR16_TRK

MD_SOV = V_HR11_SOV + V_HR12_SOV + V_HR13_SOV + V_HR14_SOV + V_HR15_SOV + V_HR16_SOV
MD_HOV = V_HR11_HOV + V_HR12_HOV + V_HR13_HOV + V_HR14_HOV + V_HR15_HOV + V_HR16_HOV
MD_TRK = V_HR11_TRK + V_HR12_TRK + V_HR13_TRK + V_HR14_TRK + V_HR15_TRK + V_HR16_TRK

MD_TOT = MD_SOV + MD_HOV + MD_TRK

; VC Ratio
VC_RATIO_HR11 = LI.1.VC_1
VC_RATIO_HR12 = LI.2.VC_1
VC_RATIO_HR13 = LI.3.VC_1
VC_RATIO_HR14 = LI.4.VC_1
VC_RATIO_HR15 = LI.5.VC_1
VC_RATIO_HR16 = LI.6.VC_1

; Toll
TOLL_HR11 = LI.1.LW_TOLL_REV_1
TOLL_HR12 = LI.2.LW_TOLL_REV_1
TOLL_HR13 = LI.3.LW_TOLL_REV_1
TOLL_HR14 = LI.4.LW_TOLL_REV_1
TOLL_HR15 = LI.5.LW_TOLL_REV_1
TOLL_HR16 = LI.6.LW_TOLL_REV_1

; Congested Speed (CSPD)
CSPD_HR11 = LI.1.DISTANCE/LI.1.LW_CGTIME_1*60
CSPD_HR12 = LI.2.DISTANCE/LI.2.LW_CGTIME_1*60
CSPD_HR13 = LI.3.DISTANCE/LI.3.LW_CGTIME_1*60
CSPD_HR14 = LI.4.DISTANCE/LI.4.LW_CGTIME_1*60
CSPD_HR15 = LI.5.DISTANCE/LI.5.LW_CGTIME_1*60
CSPD_HR16 = LI.6.DISTANCE/LI.6.LW_CGTIME_1*60

; Time
TIME_HR11 = LI.1.LW_CGTIME_1
TIME_HR12 = LI.2.LW_CGTIME_1
TIME_HR13 = LI.3.LW_CGTIME_1
TIME_HR14 = LI.4.LW_CGTIME_1
TIME_HR15 = LI.5.LW_CGTIME_1
TIME_HR16 = LI.6.LW_CGTIME_1

;V_HR11_SL = LI.1.V11_1+LI.1.V12_1+LI.1.V13_1+LI.1.V14_1+LI.1.V15_1+LI.1.V16_1+LI.1.V17_1+LI.1.V18_1
;V_HR12_SL = LI.2.V11_1+LI.2.V12_1+LI.2.V13_1+LI.2.V14_1+LI.2.V15_1+LI.2.V16_1+LI.2.V17_1+LI.2.V18_1
;V_HR13_SL = LI.3.V11_1+LI.3.V12_1+LI.3.V13_1+LI.3.V14_1+LI.3.V15_1+LI.3.V16_1+LI.3.V17_1+LI.3.V18_1
;V_HR14_SL = LI.4.V11_1+LI.4.V12_1+LI.4.V13_1+LI.4.V14_1+LI.4.V15_1+LI.4.V16_1+LI.4.V17_1+LI.4.V18_1
;V_HR15_SL = LI.5.V11_1+LI.5.V12_1+LI.5.V13_1+LI.5.V14_1+LI.5.V15_1+LI.5.V16_1+LI.5.V17_1+LI.5.V18_1
;MD_TOT_SL = V_HR11_SL+V_HR12_SL+V_HR13_SL+V_HR14_SL+V_HR15_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00N.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='NT1'
FILEI LINKI[5] = "{SCENARIO_DIR}\LOADED_HOUR24.NET"
FILEI LINKI[4] = "{SCENARIO_DIR}\LOADED_HOUR23.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_NT1.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1,LW_TOLL_REV_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_HOUR22.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR21.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR20.NET"

MERGE RECORD=FALSE
V_HR20_SOV = LI.1.V1_1 + LI.1.V2_1 + LI.1.V3_1 
V_HR20_HOV = LI.1.V4_1 + LI.1.V5_1 + LI.1.V6_1
V_HR20_TRK = LI.1.V7_1 + LI.1.V8_1

V_HR21_SOV = LI.2.V1_1 + LI.2.V2_1 + LI.2.V3_1 
V_HR21_HOV = LI.2.V4_1 + LI.2.V5_1 + LI.2.V6_1
V_HR21_TRK = LI.2.V7_1 + LI.2.V8_1

V_HR22_SOV = LI.3.V1_1 + LI.3.V2_1 + LI.3.V3_1 
V_HR22_HOV = LI.3.V4_1 + LI.3.V5_1 + LI.3.V6_1
V_HR22_TRK = LI.3.V7_1 + LI.3.V8_1

V_HR23_SOV = LI.4.V1_1 + LI.4.V2_1 + LI.4.V3_1 
V_HR23_HOV = LI.4.V4_1 + LI.4.V5_1 + LI.4.V6_1
V_HR23_TRK = LI.4.V7_1 + LI.4.V8_1

V_HR24_SOV = LI.5.V1_1 + LI.5.V2_1 + LI.5.V3_1 
V_HR24_HOV = LI.5.V4_1 + LI.5.V5_1 + LI.5.V6_1
V_HR24_TRK = LI.5.V7_1 + LI.5.V8_1

V_HR20_TOT = V_HR20_SOV + V_HR20_HOV + V_HR20_TRK
V_HR21_TOT = V_HR21_SOV + V_HR21_HOV + V_HR21_TRK
V_HR22_TOT = V_HR22_SOV + V_HR22_HOV + V_HR22_TRK
V_HR23_TOT = V_HR23_SOV + V_HR23_HOV + V_HR23_TRK
V_HR24_TOT = V_HR24_SOV + V_HR24_HOV + V_HR24_TRK

NT1_SOV = V_HR20_SOV + V_HR21_SOV + V_HR22_SOV + V_HR23_SOV + V_HR24_SOV
NT1_HOV = V_HR20_HOV + V_HR21_HOV + V_HR22_HOV + V_HR23_HOV + V_HR24_HOV
NT1_TRK = V_HR20_TRK + V_HR21_TRK + V_HR22_TRK + V_HR23_TRK + V_HR24_TRK

NT1_TOT = NT1_SOV + NT1_HOV + NT1_TRK


; VC Ratio
VC_RATIO_HR20 = LI.1.VC_1
VC_RATIO_HR21 = LI.2.VC_1
VC_RATIO_HR22 = LI.3.VC_1
VC_RATIO_HR23 = LI.4.VC_1
VC_RATIO_HR24 = LI.5.VC_1

; Toll
TOLL_HR20 = LI.1.LW_TOLL_REV_1
TOLL_HR21 = LI.2.LW_TOLL_REV_1
TOLL_HR22 = LI.3.LW_TOLL_REV_1
TOLL_HR23 = LI.4.LW_TOLL_REV_1
TOLL_HR24 = LI.5.LW_TOLL_REV_1

; Congested Speed (CSPD)
CSPD_HR20 = LI.1.DISTANCE/LI.1.LW_CGTIME_1*60
CSPD_HR21 = LI.2.DISTANCE/LI.2.LW_CGTIME_1*60
CSPD_HR22 = LI.3.DISTANCE/LI.3.LW_CGTIME_1*60
CSPD_HR23 = LI.4.DISTANCE/LI.4.LW_CGTIME_1*60
CSPD_HR24 = LI.5.DISTANCE/LI.5.LW_CGTIME_1*60

; Time
TIME_HR20 = LI.1.LW_CGTIME_1
TIME_HR21 = LI.2.LW_CGTIME_1
TIME_HR22 = LI.3.LW_CGTIME_1
TIME_HR23 = LI.4.LW_CGTIME_1
TIME_HR24 = LI.5.LW_CGTIME_1

;V_HR20_SL = LI.1.V11_1+LI.1.V12_1+LI.1.V13_1+LI.1.V14_1+LI.1.V15_1+LI.1.V16_1+LI.1.V17_1+LI.1.V18_1
;V_HR21_SL = LI.2.V11_1+LI.2.V12_1+LI.2.V13_1+LI.2.V14_1+LI.2.V15_1+LI.2.V16_1+LI.2.V17_1+LI.2.V18_1
;V_HR22_SL = LI.3.V11_1+LI.3.V12_1+LI.3.V13_1+LI.3.V14_1+LI.3.V15_1+LI.3.V16_1+LI.3.V17_1+LI.3.V18_1
;V_HR23_SL = LI.4.V11_1+LI.4.V12_1+LI.4.V13_1+LI.4.V14_1+LI.4.V15_1+LI.4.V16_1+LI.4.V17_1+LI.4.V18_1
;V_HR24_SL = LI.5.V11_1+LI.5.V12_1+LI.5.V13_1+LI.5.V14_1+LI.5.V15_1+LI.5.V16_1+LI.5.V17_1+LI.5.V18_1
;V_HR24_SL = LI.6.V11_1+LI.6.V12_1+LI.6.V13_1+LI.6.V14_1+LI.6.V15_1+LI.6.V16_1+LI.6.V17_1+LI.6.V18_1
;NT1_TOT_SL = V_HR20_SL+V_HR21_SL+V_HR22_SL+V_HR23_SL+V_HR24_SL+V_HR24_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00O.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='NT2'
FILEI LINKI[7] = "{SCENARIO_DIR}\LOADED_HOUR7.NET"
FILEI LINKI[6] = "{SCENARIO_DIR}\LOADED_HOUR6.NET"
FILEI LINKI[5] = "{SCENARIO_DIR}\LOADED_HOUR5.NET"
FILEI LINKI[4] = "{SCENARIO_DIR}\LOADED_HOUR4.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_NT2.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1,LW_TOLL_REV_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_HOUR3.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR2.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR1.NET"

MERGE RECORD=FALSE
V_HR1_SOV = LI.1.V1_1 + LI.1.V2_1 + LI.1.V3_1 
V_HR1_HOV = LI.1.V4_1 + LI.1.V5_1 + LI.1.V6_1
V_HR1_TRK = LI.1.V7_1 + LI.1.V8_1

V_HR2_SOV = LI.2.V1_1 + LI.2.V2_1 + LI.2.V3_1 
V_HR2_HOV = LI.2.V4_1 + LI.2.V5_1 + LI.2.V6_1
V_HR2_TRK = LI.2.V7_1 + LI.2.V8_1

V_HR3_SOV = LI.3.V1_1 + LI.3.V2_1 + LI.3.V3_1 
V_HR3_HOV = LI.3.V4_1 + LI.3.V5_1 + LI.3.V6_1
V_HR3_TRK = LI.3.V7_1 + LI.3.V8_1

V_HR4_SOV = LI.4.V1_1 + LI.4.V2_1 + LI.4.V3_1 
V_HR4_HOV = LI.4.V4_1 + LI.4.V5_1 + LI.4.V6_1
V_HR4_TRK = LI.4.V7_1 + LI.4.V8_1

V_HR5_SOV = LI.5.V1_1 + LI.5.V2_1 + LI.5.V3_1 
V_HR5_HOV = LI.5.V4_1 + LI.5.V5_1 + LI.5.V6_1
V_HR5_TRK = LI.5.V7_1 + LI.5.V8_1

V_HR6_SOV = LI.6.V1_1 + LI.6.V2_1 + LI.6.V3_1 
V_HR6_HOV = LI.6.V4_1 + LI.6.V5_1 + LI.6.V6_1
V_HR6_TRK = LI.6.V7_1 + LI.6.V8_1

V_HR7_SOV = LI.7.V1_1 + LI.7.V2_1 + LI.7.V3_1 
V_HR7_HOV = LI.7.V4_1 + LI.7.V5_1 + LI.7.V6_1
V_HR7_TRK = LI.7.V7_1 + LI.7.V8_1

V_HR1_TOT = V_HR1_SOV + V_HR1_HOV + V_HR1_TRK
V_HR2_TOT = V_HR2_SOV + V_HR2_HOV + V_HR2_TRK
V_HR3_TOT = V_HR3_SOV + V_HR3_HOV + V_HR3_TRK
V_HR4_TOT = V_HR4_SOV + V_HR4_HOV + V_HR4_TRK
V_HR5_TOT = V_HR5_SOV + V_HR5_HOV + V_HR5_TRK
V_HR6_TOT = V_HR6_SOV + V_HR6_HOV + V_HR6_TRK
V_HR7_TOT = V_HR7_SOV + V_HR7_HOV + V_HR7_TRK

NT2_SOV = V_HR1_SOV + V_HR2_SOV + V_HR3_SOV + V_HR4_SOV + V_HR5_SOV + V_HR6_SOV + V_HR7_SOV
NT2_HOV = V_HR1_HOV + V_HR2_HOV + V_HR3_HOV + V_HR4_HOV + V_HR5_HOV + V_HR6_HOV + V_HR7_HOV
NT2_TRK = V_HR1_TRK + V_HR2_TRK + V_HR3_TRK + V_HR4_TRK + V_HR5_TRK + V_HR6_TRK + V_HR7_TRK

NT2_TOT = NT2_SOV + NT2_HOV + NT2_TRK

; VC Ratio
VC_RATIO_HR1 = LI.1.VC_1
VC_RATIO_HR2 = LI.2.VC_1
VC_RATIO_HR3 = LI.3.VC_1
VC_RATIO_HR4 = LI.4.VC_1
VC_RATIO_HR5 = LI.5.VC_1
VC_RATIO_HR6 = LI.6.VC_1
VC_RATIO_HR7 = LI.7.VC_1

; Toll
TOLL_HR1 = LI.1.LW_TOLL_REV_1
TOLL_HR2 = LI.2.LW_TOLL_REV_1
TOLL_HR3 = LI.3.LW_TOLL_REV_1
TOLL_HR4 = LI.4.LW_TOLL_REV_1
TOLL_HR5 = LI.5.LW_TOLL_REV_1
TOLL_HR6 = LI.6.LW_TOLL_REV_1
TOLL_HR7 = LI.7.LW_TOLL_REV_1

; Congested Speed (CSPD)
CSPD_HR1 = LI.1.DISTANCE/LI.1.LW_CGTIME_1*60
CSPD_HR2 = LI.2.DISTANCE/LI.2.LW_CGTIME_1*60
CSPD_HR3 = LI.3.DISTANCE/LI.3.LW_CGTIME_1*60
CSPD_HR4 = LI.4.DISTANCE/LI.4.LW_CGTIME_1*60
CSPD_HR5 = LI.5.DISTANCE/LI.5.LW_CGTIME_1*60
CSPD_HR6 = LI.6.DISTANCE/LI.6.LW_CGTIME_1*60
CSPD_HR7 = LI.7.DISTANCE/LI.7.LW_CGTIME_1*60

;Time
TIME_HR1 = LI.1.LW_CGTIME_1
TIME_HR2 = LI.2.LW_CGTIME_1
TIME_HR3 = LI.3.LW_CGTIME_1
TIME_HR4 = LI.4.LW_CGTIME_1
TIME_HR5 = LI.5.LW_CGTIME_1
TIME_HR6 = LI.6.LW_CGTIME_1
TIME_HR7 = LI.7.LW_CGTIME_1

;V_HR1_SL = LI.1.V11_1+LI.1.V12_1+LI.1.V13_1+LI.1.V14_1+LI.1.V15_1+LI.1.V16_1+LI.1.V17_1+LI.1.V18_1
;V_HR2_SL = LI.2.V11_1+LI.2.V12_1+LI.2.V13_1+LI.2.V14_1+LI.2.V15_1+LI.2.V16_1+LI.2.V17_1+LI.2.V18_1
;V_HR3_SL = LI.3.V11_1+LI.3.V12_1+LI.3.V13_1+LI.3.V14_1+LI.3.V15_1+LI.3.V16_1+LI.3.V17_1+LI.3.V18_1
;V_HR4_SL = LI.4.V11_1+LI.4.V12_1+LI.4.V13_1+LI.4.V14_1+LI.4.V15_1+LI.4.V16_1+LI.4.V17_1+LI.4.V18_1
;V_HR5_SL = LI.5.V11_1+LI.5.V12_1+LI.5.V13_1+LI.5.V14_1+LI.5.V15_1+LI.5.V16_1+LI.5.V17_1+LI.5.V18_1
;V_HR6_SL = LI.6.V11_1+LI.6.V12_1+LI.6.V13_1+LI.6.V14_1+LI.6.V15_1+LI.6.V16_1+LI.6.V17_1+LI.6.V18_1
;V_HR7_SL = LI.7.V11_1+LI.7.V12_1+LI.7.V13_1+LI.7.V14_1+LI.7.V15_1+LI.7.V16_1+LI.7.V17_1+LI.7.V18_1
;NT2_TOT_SL = V_HR1_SL+V_HR2_SL+V_HR3_SL+V_HR4_SL+V_HR5_SL+V_HR6_SL+V_HR7_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00P.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='NT'
FILEO NETO = "{SCENARIO_DIR}\LOADED_NT.NET",
EXCLUDE=NT1_SOV,NT1_HOV,NT1_TRK,NT1_TOT,NT2_SOV,NT2_HOV,NT2_TRK,NT2_TOT
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_NT2.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_NT1.NET"

MERGE RECORD=FALSE

NT_SOV = NT1_SOV + NT2_SOV
NT_HOV = NT1_HOV + NT2_HOV
NT_TRK = NT1_TRK + NT2_TRK

NT_TOT = NT_SOV + NT_HOV + NT_TRK

;NT_TOT_SL = NT1_TOT_SL + NT2_TOT_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\00NET00Q.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Final Daily Loaded Network'
FILEI LINKI[4] = "{SCENARIO_DIR}\LOADED_NT.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_DY.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_MD.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_PM.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_AM.NET"

MERGE RECORD=FALSE
DY_SOV = LI.1.AM_SOV + LI.2.PM_SOV + LI.3.MD_SOV + LI.4.NT_SOV
DY_HOV = LI.1.AM_HOV + LI.2.PM_HOV + LI.3.MD_HOV + LI.4.NT_HOV
DY_TRK = LI.1.AM_TRK + LI.2.PM_TRK + LI.3.MD_TRK + LI.4.NT_TRK

DY_TOT = DY_SOV + DY_HOV + DY_TRK

;DY_TOT_SL = LI.1.AM_TOT_SL + LI.2.PM_TOT_SL + LI.3.MD_TOT_SL + LI.4.NT_TOT_SL
ENDRUN


; Script for program NETWORK in file "M:\Projects\Northern Coin ELToDv2.3 2017-0628\APP\01NET00F.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Convert Daily Loaded Network to Shape file'
FILEO NETO = "{SCENARIO_DIR}\LOADED_DY.SHP"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_DY.NET"


ENDRUN


