;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEO PRINTO[1] = "{SCENARIO_DIR}\Log_Trip Table Totals.csv",
  APPEND=T
FILEI MATI[1] = "{SCENARIO_DIR}\ODME_TripTables\Trip Table @IterNum@.MAT"
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table @IterNum@.MAT",
 MO=1-3,NAME=SOV,HOV,TRK
                                                               
MW[1] = MI.1.1 * {Trip Table Factor}   ;SOV
MW[2] = MI.1.2 * {Trip Table Factor}   ;HOV
MW[3] = MI.1.3 * {Trip Table Factor}   ;TRK

; Row Total
_SUM = _SUM + ROWSUM(1) + ROWSUM(1) + ROWSUM (3)
IF (I={Number of Zones})
  PRINT CSV=T, LIST=@IterNum@, _SUM, PRINTO=1
ENDIF

ENDRUN
