;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Convert Daily Loaded Network to Shape file'
FILEO NETO = "{SCENARIO_DIR}\LOADED_DY.SHP"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_DY.NET"


ENDRUN
