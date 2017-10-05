;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Renumber Zones'
FILEO MATO[1] = "{SCENARIO_DIR}\Trip Table.MAT",
MO=1
FILEI MATI[1] = "{Trip Table}"

RENUMBER, FILE = "{ZONE RENUMBER FILE}",
MISSINGZI=W,MISSINGZO=W
MW[1]=MI.1.1
ENDRUN
