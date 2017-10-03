;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Covert Shapefile Network'
FILEI LINKI[2] = "{Toll Section Length File}"
FILEI LINKI[1] = "{Network}"
FILEI NODEI[1] = "M:\KN815JK\FDOT DISTRICT 4\I-95 EXPRESS LANES 2013\GIS\I-95_NET_2013-0726\NODES.DBF"

FILEI GEOMI[1] = "M:\KN815JK\FDOT DISTRICT 4\I-95 EXPRESS LANES 2013\GIS\I-95_NET_2013-0726\LINKS.SHP"
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net.NET"

ENDRUN
