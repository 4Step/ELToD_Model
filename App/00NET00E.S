;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Set Input Attributes'
FILEI LINKI[1] = "{Network}"
FILEI LINKI[2] = "{Toll Section Length File}",
 VAR=A,B,TOLLSEGLENGTH,SEGNUM,DIRECTION
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net.NET"
ZONES = {Number of Zones}

MERGE RECORD=TRUE

;Toll links
IF (LI.1.LINKGRP2=91)
  SECTIONNUM = VAL(LI.1.SECTION)
ENDIF

IF (LI.1.PULL = '#' && LI.1.LINKGRP2=91)
  TOLLLINK = 1
ENDIF

;Free flow speed
SPEED = LI.1.SPEED

;Distance
DISTANCE = LI.1.LENMILES

;Lanes
NUM_LANES = LI.1.NUM_LANES

;Type
FTYPE = LI.1.LINKGRP2

;Make ML more attractive
;IF (LI.1.LINKGRP2=91)
  ;SPEED = 70
;ENDIF

;Capacity
CAPACITY = LANECAP

ENDRUN
