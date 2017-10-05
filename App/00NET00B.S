;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Export output'
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_HOUR@IterNum@.NET"
FILEO PRINTO = "{SCENARIO_DIR}\VOL@IterNum@.CSV"
IF (LI.1.PULL = '#')
  PRINT CSV=T, LIST=A(5.0),B(5.0),V_1(10.0), CSPD_1(10.2), VC_1(10.2), LW_TOLL_1(10.2), LW_ENTROPY_1(15.6), PRINTO=1
ENDIF
ENDRUN
