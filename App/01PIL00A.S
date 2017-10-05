; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
IF ('{Trip Table Type}'='Daily')
  Trip_Table = 1
ELSEIF('{Trip Table Type}'='Hourly')
  Trip_Table = 2
ELSEIF('{Trip Table Type}'='PK_OP')
  Trip_Table = 3
ELSEIF('{Trip Table Type}'='ODME')
  Trip_Table = 4
ENDIF


