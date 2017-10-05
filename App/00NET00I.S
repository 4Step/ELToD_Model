;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK
FILEO PRINTO[1] = "{SCENARIO_DIR}\Daily_Assign_Vol.PRN"
FILEI LINKI[1] = "{SCENARIO_DIR}\Loaded_Daily.NET"

PROCESS  PHASE=LINKMERGE  
  IF (Y2012Cnt > 0)
    PRINT CSV=T, LIST=A(5.0), B(5.0), Y2012Cnt(10.0), V_1(10.0), PRINTO=1
  ENDIF

ENDPROCESS


ENDRUN
