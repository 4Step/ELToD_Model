; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

IF (HR=8-10)
  TP = 'AM'
ELSEIF (HR=17-19)
  TP = 'PM'
ELSE
  TP = 'OP'
ENDIF
;*COPY "{Trip Table}Trip Table *.MAT" "{SCENARIO_DIR}"
