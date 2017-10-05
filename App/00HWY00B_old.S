;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@IterNum@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@ITERNUM@.PTH"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @IterNum@.MAT"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@IterNum@.NET",
INCLUDE=LW.ENTROPY, LW.TOLL
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL@ITERNUM@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@ITERNUM@.PRN"
;FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@ITERNUM@.PTH"
FILEO MATO = "{SCENARIO_DIR}\SKIM@IterNum@.MAT", MO=11,21,13,23,101,1,102,103,
                NAME=SOV_GU_Time,SOV_ML_Time,GU_TOLL,XL_TOLL,XL_SHARE,VOL_SOV_TOT,VOL_SOV_GU,VOL_SOV_XL

PARAMETERS COMBINE=PATH, VARIABLEDEMAND=T MAXITERS={Max Iteration}

;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 INTERPOLATE=F
_FieldName=0
PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  SPEED = LI.SPEED
  ;Set dummy speed on toll links
  IF (LW.FTYPE=91)
    LW.DUMMY_SPD = 999
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/SPEED*60
  LINKCLASS=1
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  LW.FTYPE = LI.FTYPE
  C = LI.CAPACITY*LI.NUM_LANES
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN
  LW.ENTROPY = 0.0*DISTANCE  ;Initial entropy
  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override MINSEGTOLL with 0
      LW.MINSEGTOLL = LI.MINSEGTOLL
    ELSE
      LW.MINSEGTOLL = {Min Per Segment Toll}
    ENDIF
  ELSE
    LW.MINSEGTOLL = {Min Per Segment Toll}
  ENDIF
  
  ;Initial toll
  IF (LW.TOLLSEGNUM>0)   
    LW.TOLL = MAX({Min Per Mile Toll}*LW.TOLLSEGLEN, LW.MINSEGTOLL)
  ELSE
    LW.TOLL = 0
  ENDIF
  
  ;Toll link group
  IF (LW.FTYPE=91)
    ADDTOGROUP=1
  ENDIF
  ;HOV link group
  IF (LW.FTYPE=0)
    ADDTOGROUP=2
  ENDIF
  ;Test
  ;IF ((A=102 && B=104)||(A=105 && B=103))
    ;ADDTOGROUP=3
  ;ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;SOV GU lane path 
  PATHLOAD PATH=TIME, MW[11]=PATHTRACE(TIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[14]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path
  PATHLOAD PATH=LW.DUMMY_TIME, MW[21]=PATHTRACE(TIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, 
             MW[24]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=2
              
  ;HOV GU lane path 
  PATHLOAD PATH=TIME, MW[31]=PATHTRACE(TIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[34]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path
  PATHLOAD PATH=LW.DUMMY_TIME, MW[41]=PATHTRACE(TIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, 
              MW[44]=PATHTRACE(LW.ENTROPY), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  
  ;TRK GU lane path 
  PATHLOAD PATH=TIME, MW[51]=PATHTRACE(TIME), NOACCESS=9999, MW[52]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[53]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[54]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1 
  ;TRK Toll lane path
  IF({Prohibit Trucks from Toll Lanes}=1)
    PATHLOAD PATH=LW.DUMMY_TIME, MW[61]=PATHTRACE(TIME), NOACCESS=9999, MW[62]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[63]=PATHTRACE(LW.TOLL), NOACCESS=0, 
              MW[64]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1,2
  ELSE
    PATHLOAD PATH=LW.DUMMY_TIME, MW[61]=PATHTRACE(TIME), NOACCESS=9999, MW[62]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[63]=PATHTRACE(LW.TOLL), NOACCESS=0, 
              MW[64]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=2
  ENDIF 
  MW[53] = MW[53]*{Truck Toll Multiplier}
  MW[63] = MW[63]*{Truck Toll Multiplier}
  
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[23] = 0)  'No valid toll path found
      MW[101] = 0
    ELSE
      MW[101] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Traval Time Coefficient}*(MW[11]-MW[21])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*(MW[14])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[22],{Distance Penalty X}))/{Distance Penalty X})))   
    ENDIF
    
    MW[102] = MW[1] * (1-MW[101])   ;GU trip table
    MW[103] = MW[1] - MW[102]   ;ML trip table
    
    ;HOV
    IF(MW[43] = 0)  'No valid toll path found
      MW[111] = 0
    ELSE
    MW[111] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Traval Time Coefficient}*(MW[31]-MW[41])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*(MW[34])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[42],{Distance Penalty X}))/{Distance Penalty X})))   
    ENDIF
    
    MW[112] = MW[2] * (1-MW[111])   ;GU trip table
    MW[113] = MW[2] - MW[112]   ;ML trip table
    
    ;TRK
    IF(MW[63] = 0)  'No valid toll path found
      MW[121] = 0
    ELSE
    MW[121] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Traval Time Coefficient}*(MW[51]-MW[61])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[63]-MW[53])-{Reliability Coefficient}*(MW[54])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[62],{Distance Penalty X}))/{Distance Penalty X})))   
    ENDIF
    
    MW[122] = MW[3] * (1-MW[121])   ;GU trip table
    MW[123] = MW[3] - MW[122]   ;ML trip table
    
    ;Write log file with details   
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5R),'I'(5R),'J'(5R),'SOV_GU_Time'(15R),'SOV_ML_Time'(15R),'SOV_GU_Dist'(15R),'SOV_ML_Dist'(15R),'SOV_GU_Toll'(15R),'SOV_ML_Toll'(15R),'SOV_GU_Entropy'(15R),'SOV_ML_Entropy'(15R),'SOV_Xshare'(15R),'SOV_Trip_TOT'(15R),'SOV_Trip_GU'(15R),'SOV_Trip_ML'(15R),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[11](10.4),MW[21](10.4),MW[12],MW[22],MW[13],MW[23],MW[14],MW[24],MW[101](15.4),MW[1],MW[102],MW[103],PRINTO=1
    ENDIF
    
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2;, PATHO=1, NAME='SOV_GU', INCLUDECOST=T ;SOV_GU 
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2;, PATHO=1, NAME='SOV_ML', INCLUDECOST=T ;SOV_ML
  
  PATHLOAD PATH=TIME, VOL[3] = MW[112], EXCLUDEGROUP=1;, PATHO=1, NAME='HOV_GU', INCLUDECOST=T ;HOV_GU 
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[4] = MW[113];, PATHO=1, NAME='HOV_ML', INCLUDECOST=T ;HOV_ML
  
  PATHLOAD PATH=TIME, VOL[5] = MW[122], EXCLUDEGROUP=1,2;, PATHO=1, NAME='TRK_GU', INCLUDECOST=T ;TRK_GU 
  IF({Prohibit Trucks from Toll Lanes}=1)
    PATHLOAD PATH=LW.DUMMY_TIME, VOL[6] = MW[123], EXCLUDEGROUP=1,2;, PATHO=1, NAME='TRK_ML', INCLUDECOST=T ;TRK_ML
  ELSE
    PATHLOAD PATH=LW.DUMMY_TIME, VOL[6] = MW[123], EXCLUDEGROUP=2;, PATHO=1, NAME='TRK_ML', INCLUDECOST=T ;TRK_ML
  ENDIF
ENDPROCESS

PROCESS PHASE=ADJUST
  IF ('{Volume Delay Function}'='Akcelik')
    TC[1] = T0*(1/SPEED + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;TC = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      TC[1] = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF
  V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]
  ;Dummy time
  IF (LW.FTYPE=91)
    LW.DUMMY_TIME = 0.0001
  ELSE
    LW.DUMMY_TIME = T0*(1/SPEED + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/SPEED)
  ENDIF
  
  ;Link entropy_X_Distance
  LW.ENTROPY={Entropy Scalar}*EXP({Entropy Constant}+V/C*{Entropy Beta VC})/(1+EXP({Entropy Constant}+V/C*{Entropy Beta VC}))*DISTANCE
  
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)
    _TollRate = ({Min Per Mile Toll} + ({Max Per Mile Toll}-{Min Per Mile Toll})*(V/C+{VC Toll Offset})^{Toll Exponent})  
    _TollRate_adj = Min(MAX(_TollRate,{Min Per Mile Toll}), {Max Per Mile Toll})*LW.TOLLSEGLEN
    
    ;Min segment toll 
    LW.TOLL = MAX(_TollRate_adj, {Min Per Segment Toll})
    IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5R),'A'(5R),'B'(5R),'TOLLSEGNUM'(10R),'TLRATE_CURVE'(15R),'TL_SEG_ADJ'(15R),'TL_SEG'(15R),'VC_RATIO'(10R),'TL_EXPO'(10R),PRINTO=2
      _FieldName=1
    ENDIF
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2
  ENDIF

ENDPROCESS

PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    BALANCE = 1
  ENDIF
ENDPROCESS
ENDRUN
