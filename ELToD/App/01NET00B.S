;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Network for Assignment'
FILEO PRINTO[1] = "{SCENARIO_DIR}\Attributes.csv"
FILEI LINKI[5] = "{Directional Link File}",
VAR=A,B,DIR1,DIR2,DIR3,DIR4
FILEI LINKI[4] = "{Cap Spd Link File}",
VAR=A,B,HRCAP,FFSPD
FILEI LINKI[3] = "{Express Lane Link File}",
VAR=A,B,FTYPE
FILEI LINKI[2] = "{Toll Link File}",
VAR=A,B,TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL
FILEO NETO = "{SCENARIO_DIR}\Assign_Input_Net_1.NET",
INCLUDE = TOLLSEGNUM,TOLLSEGLEN,MINSEGTOLL,DISTANCE,SPEED,NUM_LANES,FTYPE,CAPACITY,DIR1,DIR2,DIR3,DIR4
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

;Number of Lanes
IF({Number of Lanes}=0)
  NUM_LANES = 0 ;1
ELSE
  NUM_LANES = {Number of Lanes}
ENDIF

IF({Number of Lanes}=0) ABORT MSG='***Number of Lanes = 0 - Review Network File***'

;Facility Type
IF(LI.3.Ftype=91)
  FTYPE = 91
ELSEIF({Facility Type}=0)
  FTYPE = 52
ELSEIF({Facility Type}=90)
  FTYPE = 10
ELSE
  FTYPE = {Facility Type}
ENDIF

;Free Flow Speed
IF({Free Flow Speed}>0)
  SPEED = {Free Flow Speed}
/*ELSEIF(LI.1.TIME2=0)
  SPEED = 999*/
ELSE
  SPEED = {Free Flow Speed} ;{Distance}/LI.1.TIME2*60
ENDIF

;Capacity per lane per hour
IF({Capacity per Lane}=0)
  CAPACITY = 9999
ELSEIF(LI.4.HRCAP>0)
  CAPACITY = LI.4.HRCAP
ELSE
  CAPACITY = {Capacity per Lane};/10/LI.1.NUM_LANES
ENDIF

;DIR
;IF(LI.5.DIR1=1)
  ;DIR1 = 1
IF (LI.5.A=LI.1.A && LI.5.B=LI.1.B)
  DIR1=LI.5.Dir1
  DIR2=LI.5.Dir2
  DIR3=LI.5.Dir3
  DIR4=LI.5.Dir4
ELSE
  DIR1=0
  DIR2=0
  DIR3=0
  DIR4=0  
ENDIF

;Print Attributes
PRINT CSV=T, LIST=A(10.0L),B(10.0L),{Distance}(10.4L),{Number of Lanes}(5.0L),{Facility Type}(5.0L),{Free Flow Speed}(5.3L),{Capacity per Lane}(5.0L),PRINTO=1
;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise 
ENDRUN
