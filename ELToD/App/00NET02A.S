;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_DAILY_TEMP.NET"

PROCESS  PHASE=LINKMERGE 
IF (@HR@=1)
  V_DAILY = LI.1.V_1 + LI.2.V_1
ELSE
  V_DAILY = LI.1.V_DAILY + LI.2.V_1
ENDIF
  

ENDPROCESS

ENDRUN
