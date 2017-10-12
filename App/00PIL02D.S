; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.

IF (HR=6-8)
  TP = 'AM'
ELSEIF (HR=16-18)
  TP = 'PM'
ELSE
  TP = 'OP'
ENDIF
;*COPY "{Trip Table}Trip Table *.MAT" "{SCENARIO_DIR}"
