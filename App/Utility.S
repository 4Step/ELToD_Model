; Script for program NETWORK in file "M:\KN815LW\I95_XLTOD\CUBE\APP\00NET00C.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Covert Shapefile Network'
FILEI LINKI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_links_NORTH.dbf"
FILEI NODEI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_nodes_NORTH.dbf"

FILEI GEOMI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_links_NORTH.SHP"
FILEO NETO = "{SCENARIO_DIR}\Converted_Input.NET"

ENDRUN


; Script for program MATRIX in file "M:\KN815LW\I95_XLTOD\CUBE\APP\00MAT00D.S"
;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX MSG='Convert Trip Table from csv'
FILEI MATI = "M:\kn815lw\HEFT_XLTOD\Cube\Input\Trip Table 2040.csv", FIELDS=#1,2,0,3-5,PATTERN=IJM:V
FILEO MATO = "M:\kn815lw\HEFT_XLTOD\Cube\Input\Trip Table 2040.MAT", MO=1-3, NAME=AM,OP,PM
ZONES=19
MW[1] = MI.1.1
MW[2] = MI.1.2
MW[3] = MI.1.3
ENDRUN


