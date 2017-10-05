; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
IF ({use-ODME-Hourly-Tables} = 0)
      Factor_or_ODME = 1
ELSEIF({use-ODME-Hourly-Tables} = 1)
      Factor_or_ODME = 2
ENDIF     
