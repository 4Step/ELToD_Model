;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Covert Shapefile Network'
FILEI LINKI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_links_NORTH.dbf"
FILEI NODEI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_nodes_NORTH.dbf"

FILEI GEOMI = "M:\kn815jk\FDOT Projects - other\Congestion Pricing Project 2\GIS\HEFT\HEFT_Central_2013-0716_CubeInput\shape_Projected\Rev_HEFT_links_NORTH.SHP"
FILEO NETO = "{SCENARIO_DIR}\Converted_Input.NET"

ENDRUN
