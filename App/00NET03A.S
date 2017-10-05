;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Set Input Attributes'
FILEI LINKI[2] = "{Toll Link File}",
VAR=A,B,TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL,PULL(c)
FILEI LINKI[1] = "{Network}"
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net.NET"
ZONES = {Number of Zones}

MERGE RECORD=TRUE

;Free flow speed
IF(LI.1.TIME2=0)
  SPEED=999
ELSE
  SPEED = LI.1.DISTANCE/LI.1.TIME2*60
ENDIF

;Distance
IF(LI.1.DISTANCE=0)
  DISTANCE=0.001
ELSE
  DISTANCE = LI.1.DISTANCE/100
ENDIF


;Lanes
IF(LI.1.ASGNGRP=0)
  NUM_LANES = 1
ELSE
  NUM_LANES = LI.1.ASGNGRP
ENDIF

;Type
FTYPE = LI.1.LINKGRP2

;Capacity per Lane
IF(LI.1.CAPACITY=0)
  CAPACITY = 9999
ELSE
  CAPACITY = LI.1.CAPACITY/10
ENDIF

ENDRUN
