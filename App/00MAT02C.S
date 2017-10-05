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
