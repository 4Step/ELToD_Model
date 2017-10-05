; Script for program NETWORK in file "M:\Projects\Veterans ELToDv2.3 2017-0628_PDNE\APP\01NET00D.S"
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


