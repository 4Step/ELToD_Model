;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Export to Shape File'
FILEO NETO = "{SCENARIO_DIR}\LOADED_DY_LINK.SHP"
FILEO NODEO = "{SCENARIO_DIR}\LOADED_DY_NODE.SHP",
 FORMAT=SHP
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_DY.NET"
ENDRUN
