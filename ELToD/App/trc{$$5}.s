; Script for program NETWORK in file "D:\ELToD v2\ELToD Test w Jack 7.15.16\ELToD_Model_v212_edited_7.16.16_additional_modif\APP\01NET00B.S"
;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Network for Assignment'
FILEO PRINTO[1] = "{SCENARIO_DIR}\Attributes.csv"
FILEI LINKI[5] = "{Directional Link File}",
VAR=A,B,DIR1
FILEI LINKI[4] = "{Cap Spd Link File}",
VAR=A,B,HRCAP,FFSPD
FILEI LINKI[3] = "{Express Lane Link File}",
VAR=A,B,FTYPE
FILEI LINKI[2] = "{Toll Link File}",
VAR=A,B,TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net_1.NET",
INCLUDE = TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL,DISTANCE,SPEED,NUM_LANES,FTYPE,CAPACITY,DIR1
FILEI LINKI[1] = "{Network}"
ZONES = {Number of Zones}
MERGE RECORD=FALSE

;Print Header
_Cnt=_Cnt+1

IF (_Cnt=1)
  PRINT CSV=T, LIST='A,B,DISTANCE,NUMBER OF LANES,FACILITY TYPE,FREE FLOW SPEED,CAPACITY PER LANE',PRINTO=1
  
ENDIF

;Toll segment number
IF(LI.2.TOLLSEGNUM>0)
  TOLLSEGNUM = LI.2.TOLLSEGNUM
ELSE
  TOLLSEGNUM = 0
ENDIF

;Toll segment length
IF(LI.2.TOLLSEGLEN>0)
  TOLLSEGLEN = LI.2.TOLLSEGLEN
ENDIF

;Minimum segment toll
IF(LI.2.MINSEGTOLL>0)
  MINSEGTOLL = LI.2.MINSEGTOLL
ENDIF


;Distance
IF({Distance}=0)
  DISTANCE=0.001
ELSE
  DISTANCE = {Distance};/100
ENDIF

;Lanes
IF({Number of Lanes}=0)
  NUM_LANES = 1 ;0
ELSE
  NUM_LANES = {Number of Lanes}
ENDIF

/*;Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF(LI.1.Facility_type=0)
  FTYPE = 80
ELSEIF(LI.1.Facility_type=91)
  FTYPE = 10
ELSE
  FTYPE = LI.1.Facility_type
ENDIF
*/

;Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF({Facility Type}=0)
  FTYPE = 52
ELSEIF({Facility Type}=90)
  FTYPE = 10
ELSE
  FTYPE = {Facility Type}
ENDIF

;Free flow speed
IF({Free Flow Speed}>0)
  SPEED = {Free Flow Speed}
ELSEIF(LI.1.TIME2=0)
  SPEED = 999
ELSE
  SPEED = {Distance}/LI.1.TIME2*60
ENDIF
;postspd

;Capacity
IF({Capacity per Lane}=0)
  CAPACITY = 9999
ELSEIF(LI.4.HRCAP>0)
  CAPACITY = LI.4.HRCAP
ELSE
  CAPACITY = {Capacity per Lane};/10/LI.1.NUM_LANES
ENDIF
;CAPACITY_lane

;DIR1
IF(LI.5.DIR1=1)
  DIR1 = 1
ENDIF


;Print Attributes
PRINT CSV=T, LIST=A(10.0L),B(10.0L),{Distance}(10.4L),{Number of Lanes}(5.0L),{Facility Type}(5.0L),{Free Flow Speed}(5.3L),{Capacity per Lane}(5.0L),PRINTO=1

/* === modified script that works on 7.16.16 ===
;Toll segment number
IF(LI.2.TOLLSEGNUM>0)
  TOLLSEGNUM = LI.2.TOLLSEGNUM
ELSE
  TOLLSEGNUM = 0
ENDIF

;Toll segment length
IF(LI.2.TOLLSEGLEN>0)
  TOLLSEGLEN = LI.2.TOLLSEGLEN
ENDIF

;Minimum segment toll
IF(LI.2.MINSEGTOLL>0)
  MINSEGTOLL = LI.2.MINSEGTOLL
ENDIF


;Distance
IF(LI.1.DISTANCE=0)
  DISTANCE=0.001
ELSE
  DISTANCE = LI.1.DISTANCE;/100
ENDIF

;Lanes
IF(LI.1.NUM_LANES=0)
  NUM_LANES = 1 ;0
ELSE
  NUM_LANES = LI.1.NUM_LANES
ENDIF
*/
/*;Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF(LI.1.Facility_type=0)
  FTYPE = 80
ELSEIF(LI.1.Facility_type=91)
  FTYPE = 10
ELSE
  FTYPE = LI.1.Facility_type
ENDIF
*/
/*
;Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF(LI.1.FTC2=0)
  FTYPE = 52
ELSEIF(LI.1.FTC2=90)
  FTYPE = 10
ELSE
  FTYPE = LI.1.FTC2
ENDIF

;Free flow speed
IF(LI.1.speed>0)
  SPEED = LI.1.speed
ELSEIF(LI.1.TIME2=0)
  SPEED = 999
ELSE
  SPEED = LI.1.DISTANCE/LI.1.TIME2*60
ENDIF
;postspd

;Capacity
IF(LI.1.CAPACITY=0)
  CAPACITY = 9999
ELSEIF(LI.4.HRCAP>0)
  CAPACITY = LI.4.HRCAP
ELSE
  CAPACITY = LI.1.CAPACITY;/10/LI.1.NUM_LANES
ENDIF
;CAPACITY_lane

;DIR1
IF(LI.5.DIR1=1)
  DIR1 = 1
ENDIF
*/

ENDRUN


