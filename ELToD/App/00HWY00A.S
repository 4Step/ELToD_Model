;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table@IterNum@.MAT"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@IterNum@.NET",
INCLUDE=LW.ENTROPY, LW.TOLL, LW.COST
;FILEO MATO = "{SCENARIO_DIR}\SKIM@IterNum@.MAT", MO=11,21,12,22,23,14,24,101,1,31,32,
                    ;NAME=GU_TIME,ML_TIME,GU_DIST,ML_DIST,ML_TOLL,GU_ENTROPY,ML_ENTROPY,xSHARE,TRIP_TOT,TRIP_GU,TRIP_ML
PARAMETERS COMBINE=EQUI MAXITERS={Max Iteration}

LOOKUP LOOKUPI=1, NAME=GETTOLLRATE, LOOKUP[1]=1, RESULT=2, 
                                  LOOKUP[2]=1, RESULT=3,
                                  LOOKUP[3]=1, RESULT=4, 
                                  INTERPOLATE=F

LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=5, 
                                  LOOKUP[2]=1, RESULT=6,INTERPOLATE=F

PROCESS PHASE=LINKREAD
  LW.DISTANCE = LI.DISTANCE
  LW.SPEED = LI.SPEED
  T0 = LW.DISTANCE/LW.SPEED*60
  LW.FTYPE = LI.FTC2_ORG
  C = LI.CAPACITY*LI.NUM_LANES
  LW.TOLLLINK = LI.TOLLLINK
  LW.TLSEGMENT = LI.SECTIONNUM
  LW.TOLLSEGLENGTH = LI.TOLLSEGLENGTH
  LW.ENTROPY = 0.0*LW.DISTANCE  ;Initial entropy
  ;Initial toll
  IF (LW.TOLLLINK=1)
    LW.TOLL = MAX(GETTOLLRATE(1, @IterNum@)*LW.TOLLSEGLENGTH, GETTOLLRATE(3, @IterNum@))
  ELSE
    LW.TOLL = 0
  ENDIF
  ;ML link group
  IF (LW.FTYPE=81)
    ADDTOGROUP=1
  ENDIF
  LW.COST = T0 + LW.ENTROPY
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1
  
  ;GU lane path
  PATHLOAD PATH=TIME, MW[11]=PATHTRACE(TIME), NOACCESS=9999, MW[12]=PATHTRACE(LW.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[14]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1 
  ;ML lane path
  PATHLOAD PATH=TIME, MW[21]=PATHTRACE(TIME), NOACCESS=9999, MW[22]=PATHTRACE(LW.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, 
              MW[24]=PATHTRACE(LW.ENTROPY), NOACCESS=9999
  
  JLOOP 
    ;Divert ML share
      MW[101] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Traval Time Coefficient}*(MW[11]-MW[21])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*(MW[14])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[22],{Distance Penalty X}))/{Distance Penalty X})))   

    MW[31] = MW[1] * (1-MW[101])   ;GU trip table
    MW[32] = MW[1] - MW[31]   ;ML trip table
    
    ;Write log file with details   
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5R),'I'(5R),'J'(5R),'GU_Time'(10R),'ML_Time'(10R),'GU_Dist'(10R),'ML_Dist'(10R),'GU_Toll'(10R),'ML_Toll'(10R),
                        'GU_Entropy'(10R),'ML_Entropy'(10R),'Xshare'(10R),'Trip_TOT'(10R),'Trip_GU'(10R),'Trip_ML'(10R),PRINTO=1
    ENDIF
    IF (MW[11]<1000000)  ;Log only when there is path between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[11],MW[21],MW[12],MW[22],MW[13],MW[23],MW[14],MW[24],MW[101],MW[1],MW[31],MW[32],PRINTO=1
    ENDIF
    
  ENDJLOOP
 
  PATHLOAD PATH=LW.COST, VOL[1] = MW[31], EXCLUDEGROUP=1, PATHO=1, NAME='GU', INCLUDECOST=T ;GU 
  PATHLOAD PATH=LW.COST, VOL[2] = MW[32], PATHO=1, NAME='ML', INCLUDECOST=T ;ML
ENDPROCESS

PROCESS PHASE=ADJUST
  IF ('{Volume Delay Function}'='Akcelik')
    TC = T0*(1/LW.SPEED + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPEED)
  ELSE
    
  ENDIF
  
  ;Link entropy_X_Distance
  LW.ENTROPY={Entropy Scalar}*EXP({Entropy Constant}+V/C*{Entropy Beta VC})/(1+EXP({Entropy Constant}+V/C*{Entropy Beta VC}))*LW.DISTANCE
  
  ;Link cost
  LW.COST = TIME + (-1)*{Reliability Coefficient}/{Traval Time Coefficient}*LW.ENTROPY
  
  ;Adjust toll rate
  IF (LW.TOLLLINK=1)
    _TollRate = (GETTOLLRATE(1,@IterNum@) + (GETTOLLRATE(2,@IterNum@)-GETTOLLRATE(1,@IterNum@))*(V/C+GETCOEFF(2,@IterNum@))^{Toll Exponent})    
    _TollRate_adj = Min(MAX(_TollRate,GETTOLLRATE(1,@IterNum@)), GETTOLLRATE(2,@IterNum@))*LW.TOLLSEGLENGTH
    IF ({Segment Toll Rounded to}<>0)
      LW.TOLL = Round(_TollRate_adj/{Segment Toll Rounded to})*{Segment Toll Rounded to}
    ELSE
      LW.TOLL = _TollRate_adj
    ENDIF
    IF (LW.TOLL < GETTOLLRATE(3, @IterNum@)) ;Min section toll
      LW.TOLL = GETTOLLRATE(3, @IterNum@)
    ENDIF
    PRINT CSV=T, LIST=ITERATION(5.0),LW.TLSEGMENT(5.0),GETTOLLRATE(1,@IterNum@),GETTOLLRATE(2,@IterNum@),GETCOEFF(2,@IterNum@),{Toll Exponent},V/C,LW.TOLL,PRINTO=2
  ENDIF

ENDPROCESS

PROCESS PHASE=CONVERGE
  IF (RGAP<0.001)
    BALANCE = 1
  ENDIF
ENDPROCESS
ENDRUN
