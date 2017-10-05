; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG1.PRN" MSG='Assignment'
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"

FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table 1.MAT"
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR1.NET",
 INCLUDE=LW.TOLL,LW.ENTROPY,LW.DUMMY_TIME 
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV1.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL1.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV1.PRN"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF1.PRN"
FILEO PRINTO[5] = "{SCENARIO_DIR}\ENTROPY1.PRN"
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM1.MAT",
 MO=101,1,102,103, NAME=XL_SHARE_SOV,TOT_VOL_SOV,GU_VOL_SOV,XL_VOL_SOV
FILEO MATO[2] = "{SCENARIO_DIR}\REV1.MAT",
 MO=201,103,202,211,113,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH1.PTH"
                
PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 INTERPOLATE=F
_FieldName=0
PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 999
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.CGTIME=T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN
  LW.ENTROPY = 0.0*LW.DISTANCE  ;Initial entropy
  IF ({Override Minimum Per Segment Toll in Network} = 1)
    IF (LI.MINSEGTOLL > 0)   ;Can't override if MINSEGTOLL = 0
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
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.CGTIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[14]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.CGTIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0,MW[24]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0,MW[74]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.CGTIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[34]=PATHTRACE(LW.ENTROPY), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.CGTIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0,MW[44]=PATHTRACE(LW.ENTROPY), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0,MW[84]=PATHTRACE(LW.ENTROPY), NOACCESS=9999
  MW[33] = MW[33]*(1-{HOV Discount Rate})
  MW[49] = MW[43] ;Toll skim time based
  MW[43] = MW[43]*(1-{HOV Discount Rate})
  MW[89] = MW[83] ;Toll skim forced on toll lane
  MW[83] = MW[83]*(1-{HOV Discount Rate})
    
  JLOOP 
    ;Divert ML share
    ;SOV
    IF(MW[13]<{Min Trip Toll} && MW[13]>0)
      MW[13] = {Min Trip Toll}
    ENDIF
    IF(MW[23]<{Min Trip Toll} && MW[23]>0)
      MW[23] = {Min Trip Toll}
    ENDIF
    IF(MW[73]<{Min Trip Toll} && MW[73]>0)
      MW[73] = {Min Trip Toll}
    ENDIF
    IF(MW[23] = 0)    ;No toll links are used in the time based toll path
      IF(MW[73] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Travel Time Coefficient}*(MW[11]-MW[71])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*(MW[14])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[72],{Distance Penalty X}))/{Distance Penalty X})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[73]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Travel Time Coefficient}*(MW[11]-MW[21])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*(MW[14])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[22],{Distance Penalty X}))/{Distance Penalty X})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[23]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
        
    ;HOV
    ;Min trip toll is applied to HOV unless it is free.
    IF(MW[33]<{Min Trip Toll} && MW[33]>0 && {HOV Discount Rate}<>1)
      MW[33] = {Min Trip Toll}
    ENDIF
    IF(MW[43]<{Min Trip Toll} && MW[43]>0 && {HOV Discount Rate}<>1)
      MW[43] = {Min Trip Toll}
    ENDIF
    IF(MW[83]<{Min Trip Toll} && MW[83]>0 && {HOV Discount Rate}<>1)
      MW[83] = {Min Trip Toll}
    ENDIF
    IF(MW[49] = 0)    ;No toll links are used in the time based toll path
      IF(MW[89] = 0)  ;No toll links are used in the forced toll path
        MW[111] = 0
        MW[112] = MW[2]
        MW[211] = 0   ;HOV toll charged
        MW[212] = 0   ;Revenue
      ELSE  ;Forced toll path
        MW[111] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Travel Time Coefficient}*(MW[31]-MW[81])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*(MW[34])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[82],{Distance Penalty X}))/{Distance Penalty X})))
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[113] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[83]                ;HOV toll charged
        MW[212] = MW[211]*MW[113]       ;Revenue
      ENDIF
    ELSE    ;Time based toll path
      MW[111] = 1/(1+EXP({Scale Coefficient}*(-1*GETCOEFF(1,@IterNum@)+{Travel Time Coefficient}*(MW[31]-MW[41])*{Time Saving Bias Factor}-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*(MW[34])-{Distance Penalty y}*({Distance Penalty X}-MIN(MW[42],{Distance Penalty X}))/{Distance Penalty X}))) 
      MW[112] = MW[2] * (1-MW[111])   ;GU trip table
      MW[114] = MW[2] - MW[112]       ;ML trip table
      MW[211] = MW[43]                ;HOV toll charged
      MW[212] = MW[211]*MW[114]       ;Revenue
    ENDIF
       
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5R),'I'(5R),'J'(5R),'GU_Time'(15R),'ML_Time'(15R),'GU_Dist'(15R),'ML_Dist'(15R),'GU_Toll'(15R),'ML_Toll'(15R),'GU_Entropy'(15R),'ML_Entropy'(15R),'Xshare'(15R),'Trip_TOT'(15R),'Trip_GU'(15R),'Trip_ML_T'(15R),'Trip_ML_F'(15R),'F_ML_Time'(15R),'F_ML_Dist'(15R),'F_ML_Toll'(15R),'F_ML_Entropy'(15R),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[11](10.4),MW[21](10.4),MW[12],MW[22],MW[13],MW[23],MW[14],MW[24],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[71](10.4),MW[72],MW[73],MW[74],PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5R),'I'(5R),'J'(5R),'GU_Time'(15R),'ML_Time'(15R),'GU_Dist'(15R),'ML_Dist'(15R),'GU_Toll'(15R),'ML_Toll'(15R),'GU_Entropy'(15R),'ML_Entropy'(15R),'Xshare'(15R),'Trip_TOT'(15R),'Trip_GU'(15R),'Trip_ML_T'(15R),'Trip_ML_F'(15R),'F_ML_Time'(15R),'F_ML_Dist'(15R),'F_ML_Toll'(15R),'F_ML_Entropy'(15R),PRINTO=3
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[31](10.4),MW[41](10.4),MW[32],MW[42],MW[33],MW[43],MW[34],MW[44],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[81](10.4),MW[82],MW[83],MW[84],PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.CGTIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2;, PATHO=1, NAME='SOV_GU', INCLUDECOST=T ;SOV_GU 
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2;, PATHO=1, NAME='SOV_ML', INCLUDECOST=T ;SOV_ML_FORCED_PATH
  PATHLOAD PATH=LW.CGTIME, VOL[3] = MW[104], EXCLUDEGROUP=2;, PATHO=1, NAME='SOV_ML', INCLUDECOST=T ;SOV_ML_TIME_PATH
  
  PATHLOAD PATH=LW.CGTIME, VOL[4] = MW[112], EXCLUDEGROUP=1;, PATHO=1, NAME='HOV_GU', INCLUDECOST=T ;HOV_GU 
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113];, PATHO=1, NAME='HOV_ML', INCLUDECOST=T ;HOV_ML_FORCED_PATH
  PATHLOAD PATH=LW.CGTIME, VOL[6] = MW[114];, PATHO=1, NAME='HOV_ML', INCLUDECOST=T ;HOV_ML_TIME_PATH
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.CGTIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2;, PATHO=1, NAME='TRK_GU', INCLUDECOST=T ;TRK_GU 
  PATHLOAD PATH=LW.CGTIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2;, PATHO=1, NAME='TRK_GU', INCLUDECOST=T ;TRK_ML
ENDPROCESS

PROCESS PHASE=ADJUST
  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5R),'A'(5R),'B'(5R),'FFTIME'(10R),'SYS_TIME'(10R),'LAST_TIME'(10R),'TIME_CAL'(10R),'TIME_MSA'(10R),'CGT_SPD'(10R),'VC_RATIO'(15R),'CAPACITY'(10R),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5R),'A'(5R),'B'(5R),'TOLLSEGNUM'(10R),'TL_CURVE'(15R),'TL_PERML_ADJ'(15R),'TL_LAST_ITER'(15R),'TL_SEG_ADJ'(15R),'TL_MSA_ADJ'(15R),'VC_RATIO'(10R),'TL_EXPO'(10R),PRINTO=2
      PRINT CSV=T,LIST='ITER'(5R),'A'(5R),'B'(5R),'VC_RATIO'(10R),'DISTANCE'(15R),'ENTROPY_LSTITER'(15R),'ENTROPY_CURITER'(15R),'ENTROPY_MSA'(15R),PRINTO=5
      _FieldName=1
  ENDIF
  IF (LW.CGTIME_LASTITER=0)
    LW.SPD = MAX(DISTANCE/T0*60,{Min Link Congested Speed})
  ELSE
    LW.SPD = MAX(DISTANCE/LW.CGTIME_LASTITER*60,{Min Link Congested Speed})
  ENDIF
  
  IF ('{Volume Delay Function}'='Akcelik')
    _CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;_CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      _CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 
  ;MSA for time
  LW.CGTIME = LW.CGTIME_LASTITER*(1-1/ITERATION)+_CGTIME*(1/ITERATION) 
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),TIME(10.2),
          LW.CGTIME_LASTITER(10.2),_CGTIME(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),C(10.0),PRINTO=4
  LW.CGTIME_LASTITER = LW.CGTIME
  
  V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]
  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = 0.0001
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

  ;Link entropy_X_Distance
  _Entropy={Entropy Scalar}*EXP({Entropy Constant}+V/C*{Entropy Beta VC})/(1+EXP({Entropy Constant}+V/C*{Entropy Beta VC}))*DISTANCE
  ;MSA for entropy
  LW.ENTROPY =LW.ENTROPY_LASTITER*(1-1/ITERATION)+_Entropy*(1/ITERATION)  
  PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),V/C(10.2),DISTANCE(15.2),LW.ENTROPY_LASTITER(15.2),_Entropy(15.2),LW.ENTROPY(15.2),PRINTO=5
  LW.ENTROPY_LASTITER = LW.ENTROPY
  
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)
    ;Toll curve
    _TollRate = ({Min Per Mile Toll} + ({Max Per Mile Toll}-{Min Per Mile Toll})*(V/C+{VC Toll Offset})^{Toll Exponent})  
    ;Adjust for min and max per mile toll
    _TollRate_adj = Min(MAX(_TollRate,{Min Per Mile Toll}), {Max Per Mile Toll})*LW.TOLLSEGLEN   
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, {Min Per Segment Toll})
    ;MSA for toll      
    LW.TOLL = LW.TOLL_LASTITER*(1-1/ITERATION)+_TollRate_Current*(1/ITERATION) 
    
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),LW.TOLL_LASTITER(15.2), _TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2
    LW.TOLL_LASTITER = LW.TOLL
  ENDIF

ENDPROCESS

PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    BALANCE = 1
  ENDIF
ENDPROCESS
ENDRUN
