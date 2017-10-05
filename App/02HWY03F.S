;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY PRNFILE="{SCENARIO_DIR}\RUNLOG@HR@.PRN"
FILEI MATI[2] = "{SCENARIO_DIR}\Dir.MAT"
FILEO PRINTO[4] = "{SCENARIO_DIR}\VDF@HR@.PRN"
FILEO PRINTO[3] = "{SCENARIO_DIR}\RUNDETAIL_HOV@HR@.PRN"
FILEO PRINTO[2] = "{SCENARIO_DIR}\CAL_TOLL@HR@.PRN"
FILEO PRINTO[1] = "{SCENARIO_DIR}\RUNDETAIL_SOV@HR@.PRN"
FILEO PATHO[1] = "{SCENARIO_DIR}\PATH@HR@.PTH"
FILEO NETO = "{SCENARIO_DIR}\LOADED_HOUR@HR@.NET",
 INCLUDE=LW.TOLL,LW.TOLL_REV,LW.DUMMY_TIME,LW.CGTIME,LW.TIMEWEIGHT,LW.TWGT_1LANE
FILEO MATO[2] = "{SCENARIO_DIR}\REV@HR@.MAT",
MO=201,105,202,211,115,212, NAME=SOV_TOLL,SOV_VOL,SOV_REV,HOV_TOLL,HOV_VOL,HOV_REV, COMBINE = TRUE
FILEO MATO[1] = "{SCENARIO_DIR}\SKIM@HR@.MAT",
MO=101,1,106,2,116, NAME=EL_SHARE_SOV,VOL_SOV,VMT_SOV,VOL_HOV,VMT_HOV, COMBINE = TRUE
FILEI LOOKUPI[1] = "{Hourly Parameters}"
FILEI NETI = "{SCENARIO_DIR}\Assign_Input_Net.NET"
FILEI MATI[1] = "{SCENARIO_DIR}\Trip Table @HR@.MAT"

PARAMETERS COMBINE={Assignment Method} MAXITERS={Max Iteration}
;!!!CUBE CLUSTER INTRASTEP IS NOT RECOMMENDED IN THIS MODEL!!!
;Toll Constant
LOOKUP LOOKUPI=1, NAME=GETCOEFF, LOOKUP[1]=1, RESULT=2, 
                                 LOOKUP[2]=1, RESULT=3,INTERPOLATE=F
_FieldName=0
_Counter = 0
_BPR = 0
_Akcelik = 0

PROCESS PHASE=LINKREAD
  DISTANCE = LI.DISTANCE
  LW.TL_DIST = LI.TL_DIST
  LW.NUM_LANES = LI.NUM_LANES
  LW.FTYPE = LI.FTYPE
  ;Set dummy speed on toll links
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_SPD = 80
  ELSE
    LW.DUMMY_SPD = LI.SPEED
  ENDIF
  T0 = DISTANCE/LI.SPEED*60
  LW.FFTIME = T0
  LW.CGTIME = T0
  LW.PERCV_TIME = T0
  LW.CM_TIME = T0
  LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60  
  C = LI.CAPACITY*LI.NUM_LANES
  LW.SPD = LI.SPEED
  LW.TOLLSEGNUM = LI.TOLLSEGNUM   ;Links that charge tolls
  LW.TOLLSEGLEN = LI.TOLLSEGLEN

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
    LW.TOLL = LW.MINSEGTOLL
    LW.TOLL_REV = LW.MINSEGTOLL
  ELSE
    LW.TOLL = 0
    LW.TOLL_REV = 0
  ENDIF
  ;Toll link group
  IF (LW.FTYPE={Toll Link FTYPE Number})
    ADDTOGROUP=1
  ENDIF
  ;HOV link group could be any discount or other difference of users from base
  IF (LW.FTYPE={HOV Link FTYPE Number})
    ADDTOGROUP=2
  ENDIF
  
  ;Indicate whether BPR/Akcelik is used
  IF ('{Volume Delay Function}'='Akcelik')
      _Akcelik = 1
  ELSE
      _BPR = 1
  ENDIF
  
ENDPROCESS

PROCESS PHASE=ILOOP
  ;Input
  MW[1] = MI.1.1  ;SOV
  MW[2] = MI.1.2  ;HOV
  MW[3] = MI.1.3  ;TRK
  
  ;Path building
  ;SOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[11]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[12]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[13]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[313]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[14]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[15]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[17]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1,2 
  ;SOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[21]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[22]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[23]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[323]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[24]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[25]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[26]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[27]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[28]=PATHTRACE(LW.TOLLSEGLEN), NOACCESS=9999,EXCLUDEGROUP=2
  ;SOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[71]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[72]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[73]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[373]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[74]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[75]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[76]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[77]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[78]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=2 
             
  ;HOV GU lane path 
  PATHLOAD PATH=LW.PERCV_TIME, MW[31]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[32]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[33]=PATHTRACE(LW.TOLL), NOACCESS=9999, MW[333]=PATHTRACE(LW.TOLL_REV), NOACCESS=9999, MW[34]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[35]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[37]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, EXCLUDEGROUP=1 
  ;HOV Toll lane path time based
  PATHLOAD PATH=LW.PERCV_TIME, MW[41]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[42]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[43]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[343]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[44]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[45]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[46]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[47]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[48]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
  ;HOV Toll lane path forced on toll lane
  PATHLOAD PATH=LW.DUMMY_TIME, MW[81]=PATHTRACE(LW.CGTIME), NOACCESS=9999, MW[82]=PATHTRACE(LI.DISTANCE), NOACCESS=9999, MW[83]=PATHTRACE(LW.TOLL), NOACCESS=0, MW[383]=PATHTRACE(LW.TOLL_REV), NOACCESS=0, MW[84]=PATHTRACE(LW.PERCV_TIME), NOACCESS=9999, MW[85]=PATHTRACE(LW.FFTIME), NOACCESS=9999, MW[86]=PATHTRACE(LW.TL_DIST), NOACCESS=9999, MW[87]=PATHTRACE(LW.CM_TIME), NOACCESS=9999, MW[88]=PATHTRACE(LW.CM_TIME), NOACCESS=9999
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
    ;Find the toll constant
    IF (MW[99] > 0)
      _TollConstant = GETCOEFF(1,@HR@)
    ELSE
      _TollConstant = GETCOEFF(2,@HR@)
    ENDIF
    
    ;Changed to test if toll distance = 0 (used to test cost)
    IF(MW[28] = 0)    ;No toll links are used in the time based toll path
      IF(MW[78] = 0)  ;No toll links are used in the forced toll path
        MW[101] = 0
        MW[102] = MW[1]
        MW[201] = 0   ;SOV toll charged
        MW[202] = 0   ;Revenue
      ELSE  ;Forced toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[77]-MW[17])-{Toll Coefficient}*(MW[73]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[75]-MW[71])*MW[72]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[76]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[103] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[373]                ;SOV toll charged
      MW[202] = MW[201]*MW[103]       ;Revenue
      ENDIF
    ELSE  ;Time based toll path
      MW[101] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[27]-MW[17])-{Toll Coefficient}*(MW[23]-MW[13])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[15]-MW[11])*MW[12]^(-1*{Reliability Distance Coefficient})-(MW[25]-MW[21])*MW[22]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[26]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))  
      MW[102] = MW[1] * (1-MW[101])   ;GU trip table
      MW[104] = MW[1] - MW[102]       ;ML trip table
      MW[201] = MW[323]                ;SOV toll charged
      MW[202] = MW[201]*MW[104]       ;Revenue
    ENDIF
    MW[105] = MW[103] + MW[104]
    MW[106] = MW[102] * MW[12] + MW[104] * MW[22]  + MW[103] * MW[72]   ;VMT SOV
    
    ;HOV
    IF({HOV Discount Rate}=1) ;HOV is free
      MW[111] = 1
      MW[112] = 0
      MW[113] = 0
      MW[114] = MW[2]
      MW[211] = 0   ;HOV toll charged
      MW[212] = 0   ;Revenue
    ELSE
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
      
          ;Changed to test if toll distance = 0 (used to test cost)
      IF(MW[48] = 0)    ;No toll links are used in the time based toll path
        IF(MW[88] = 0)  ;No toll links are used in the forced toll path
          MW[111] = 0
          MW[112] = MW[2]
          MW[211] = 0   ;HOV toll charged
          MW[212] = 0   ;Revenue
        ELSE  ;Forced toll path
          MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[87]-MW[37])-{Toll Coefficient}*(MW[83]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[85]-MW[81])*MW[82]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[86]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y})))
          MW[112] = MW[2] * (1-MW[111])   ;GU trip table
          MW[113] = MW[2] - MW[112]       ;ML trip table
          MW[211] = MW[383]                ;HOV toll charged
          MW[212] = MW[211]*Round(MW[113])       ;Revenue
        ENDIF
      ELSE    ;Time based toll path
        MW[111] = 1/(1+EXP(-1*_TollConstant-{Travel Time Coefficient}*(MW[47]-MW[37])-{Toll Coefficient}*(MW[43]-MW[33])-{Reliability Coefficient}*{Travel Time Coefficient}*{Reliability Time Coefficient}*((MW[35]-MW[31])*MW[32]^(-1*{Reliability Distance Coefficient})-(MW[45]-MW[41])*MW[42]^(-1*{Reliability Distance Coefficient}))+MIN(MAX({Distance Penalty Y}-{Distance Penalty Y}*(MW[46]-{Distance Penalty X1})/({Distance Penalty X2}-{Distance Penalty X1}),0),{Distance Penalty Y}))) 
        MW[112] = MW[2] * (1-MW[111])   ;GU trip table
        MW[114] = MW[2] - MW[112]       ;ML trip table
        MW[211] = MW[343]                ;HOV toll charged
        MW[212] = MW[211]*Round(MW[114])       ;Revenue
      ENDIF      
    ENDIF
    MW[115] = MW[113] + MW[114]
    MW[116] = MW[112] * MW[32] + MW[114] * MW[42]  + MW[113] * MW[82]   ;VMT HOV
    
    MW[4] = 0 ;TRK place holder
    ;Write log file with details 
    ;SOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=1
    ENDIF
    IF (MW[1]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[15](10.4),MW[11](10.4),MW[25](10.4),MW[21](10.4),MW[14](10.4),MW[24](10.4),MW[12],MW[22],MW[26],MW[13],MW[23],MW[101](15.4),MW[1],MW[102],MW[104],MW[103],MW[75](10.4),MW[71](10.4),MW[74](10.4),MW[72],MW[73],MW[76],_TollConstant,PRINTO=1
    ENDIF
    ;HOV
    IF (ITERATION=1 && I=1 && J=1)  ;Write header in detail log file
      PRINT CSV=T,LIST='ITER'(5L),'I'(5L),'J'(5L),'NTL_FFTime'(10L),'NTL_Time'(10L),'TL_FFTime'(10L),'TL_Time'(10L),'NTL_Pcv_Time'(12L),'TL_Pcv_Time'(12L),'NTL_Dist'(10L),'TL_Dist'(10L),'TL_ONLY_Dist'(12L),'NTL_Toll'(10L),'TL_Toll'(10L),'Share'(10L),'Trip_TOT'(10L),'Trip_NTL'(10L),'Trip_TL'(10L),'Trip_TL_F'(10L),'F_TL_FFTime'(10L),'F_TL_Time'(10L),'F_TL_PcvTime'(12L),'F_TL_Dist'(10L),'F_TL_Toll'(10L),'F_TL_ONLY_Dist'(15L),'Toll_Const'(10L),PRINTO=3
    ENDIF
    IF (MW[2]>0)  ;Log only when there are trips between the zone pair
      PRINT CSV=T,LIST=ITERATION(5.0),I(5.0),J(5.0),MW[35](10.4),MW[31](10.4),MW[45](10.4),MW[41](10.4),MW[34](10.4),MW[44](10.4),MW[32],MW[42],MW[46],MW[33],MW[43],MW[111](15.4),MW[2],MW[112],MW[114],MW[113],MW[85](10.4),MW[81](10.4),MW[84](10.4),MW[82],MW[83],MW[86],_TollConstant,PRINTO=3
    ENDIF
  ENDJLOOP
 
  ;PATHLOAD
  PATHLOAD PATH=LW.PERCV_TIME, VOL[1] = MW[102], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[2] = MW[103], EXCLUDEGROUP=2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[3] = MW[104], EXCLUDEGROUP=2
  
  PATHLOAD PATH=LW.PERCV_TIME, VOL[4] = MW[112], EXCLUDEGROUP=1
  PATHLOAD PATH=LW.DUMMY_TIME, VOL[5] = MW[113]
  PATHLOAD PATH=LW.PERCV_TIME, VOL[6] = MW[114]
  
  ;TRK is prohibited from XL lane and HOV lane
  PATHLOAD PATH=LW.PERCV_TIME, VOL[7] = MW[3], EXCLUDEGROUP=1,2
  PATHLOAD PATH=LW.PERCV_TIME, VOL[8] = MW[4], EXCLUDEGROUP=1,2
ENDPROCESS

PROCESS PHASE=ADJUST

  IF (_FieldName=0)
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'FFTIME'(10L),'TIME'(15L),'CGT_SPD'(10L),'VC_RATIO'(15L),'PRCV_TIME_WGT'(15L),'ONELANE_TIME_WGT'(20L),'CAPACITY'(10L),PRINTO=4
      PRINT CSV=T,LIST='ITER'(5L),'A'(5L),'B'(5L),'TOLLSEGNUM'(10L),'TL_CURVE'(15L),'TL_MAX_ADJ'(15L),'TL_MIN_ADJ'(15L),'TL_ADJ'(15L),'TL_REV'(15L),'VC_RATIO'(10L),'EXP'(10L),PRINTO=2
      _FieldName=1
  ENDIF
  
;Volume is sum of class flows
FUNCTION {

V = VOL[1]+VOL[2]+VOL[3]+VOL[4]+VOL[5]+VOL[6]+VOL[7]+VOL[8]

}

;Calculate Congested time
  IF ('{Volume Delay Function}'='Akcelik')
    LW.CGTIME = T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)
  ELSE
    IF ({Override BPR Coefficients in Network}=1)
      ;LW.CGTIME = T0*(1+LI.BPR_Alpha*(V/C)^LI.BPR_Beta)
    ELSE
      LW.CGTIME = T0*(1+{BPR Alpha}*(V/C)^{BPR Beta})
    ENDIF
  ENDIF 

;Define link times for use in Cube-generated reports
;LW.CGTIME does not work properly but method below is okay
;Users should update formula if using link-specific BPR coefficients 
FUNCTION {

    TC[1] = _Akcelik * (T0*(1/LI.SPEED + ({Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+(8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T})))^0.5)))/(1/LI.SPEED)) + _BPR * (T0*(1+{BPR Alpha}*(V/C)^{BPR Beta}))
        
}
 
    ;Constrained speed used in Dummy Path
    LW.SPD = MAX(DISTANCE/LW.CGTIME*60,{Min Link Congested Speed})
  ;;;

  ;One lane time weight
  IF (LW.FTYPE={Toll Link FTYPE Number} && LW.NUM_LANES=1)
    LW.TWGT_1LANE = {One Express Lane Time Weight}
  ELSE
    LW.TWGT_1LANE = 1
  ENDIF
  ;Perceived time weight
  LW.TIMEWEIGHT = ({Perceived Time Max VC Ratio}-1)/(1+EXP(-{Perceived Time Coefficient Alpha}*(V/C-{Perceived Time Min VC Ratio}))) + 1  
  LW.PERCV_TIME = LW.CGTIME * LW.TIMEWEIGHT   ;Time used for path building
  LW.CM_TIME = LW.CGTIME * LW.TIMEWEIGHT * LW.TWGT_1LANE  ;Time used in the choice model Time
    
  PRINT CSV=T,LIST=ITERATION(5.0),A(5.0),B(5.0),T0(10.2),LW.CGTIME(10.2),LW.SPD(10.2),V/C(10.2),LW.TIMEWEIGHT(15.2),LW.TWGT_1LANE(20.2),C(10.0),PRINTO=4

  ;Dummy time
  IF (LW.FTYPE={Toll Link FTYPE Number})
    LW.DUMMY_TIME = DISTANCE/LW.DUMMY_SPD*60
  ELSE
    LW.DUMMY_TIME = T0*(1/LW.SPD + {Akcelik pb}*{Akcelik T}*((V/C+{Akcelik Offset}-1)+((V/C+{Akcelik Offset}-1)^2+8*0.1*(V/C+{Akcelik Offset})/(C*{Akcelik T}))^0.5))/(1/LW.SPD)
  ENDIF

 ;Adjust toll rate
 ;4 piece function: flat 0 for LOSA, linear increase to "min toll" for LOSA/LOSB transition, "min toll" for LOSB, dynamic curve for LOSC and worse
 
  IF (LW.TOLLSEGNUM>0)
  IF (LI.TOLLPOLICY == 1)
      ;Toll curve
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      
  ELSE
    IF ((V/C)<{LOS A PriceInc VC})
    
      _TollRate = 0
      _TollRate_adj = 0
      _TollRate_Current= 0
    
    ELSEIF ((V/C)<{LOS B VC})
     
      _TollRate = (((V/C)-{LOS A PriceInc VC})/({LOS B VC}-{LOS A PriceInc VC}))*LW.MINSEGTOLL
      _TollRate_adj = _TollRate
      _TollRate_Current= _TollRate   
  
    ELSEIF (V/C<{LOS C VC})
      
      _TollRate = LW.MINSEGTOLL
      _TollRate_adj = LW.MINSEGTOLL
      _TollRate_Current= LW.MINSEGTOLL
      
      ELSE
      ;Toll curve
      _MaxCorrection = ({LOS C VC}+{VC Toll Offset})^{Toll Exponent}
      _Correction = -1 * _MaxCorrection/{LOS C VC} + min(1,(V/C)) * (_MaxCorrection/(1-{LOS C VC}))
      
      _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(_Correction + (V/C+{VC Toll Offset})^{Toll Exponent}))     
      
      ;Adjust for max segment toll
      _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
      ;Adjust for min segment toll 
      _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
      ENDIF
 ENDIF         
    LW.TOLL = _TollRate_Current 
    
 IF (LI.TOLLPOLICY == 1)
    LW.TOLL_REV = LW.TOLL
 ELSE
     ;Adjust toll used for calculating revenue if LOSA conditions or the EL speed was below the policy minimum    
    IF ((V/C) < {LOS B VC} || LW.SPD < {Policy Min EL Speed}) 
      LW.TOLL_REV = 0
    ELSE
      LW.TOLL_REV = LW.TOLL
    ENDIF
 ENDIF   
        PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),LW.TOLL_REV(15.2),V/C(10.2),{Toll Exponent}(10.2),_MaxCorrection(15.2),PRINTO=2

  ENDIF
  
 /*
 ;ORIGINAL SCRIPT AS OF 2017-0516
  ;Adjust toll rate
  IF (LW.TOLLSEGNUM>0)   
    ;Toll curve
    _TollRate = (LW.MINSEGTOLL + ({Max Per Segment Toll}-LW.MINSEGTOLL)*(V/C+{VC Toll Offset})^{Toll Exponent})
    ;Adjust for max segment toll
    _TollRate_adj = MIN(_TollRate, {Max Per Segment Toll})
    ;Adjust for min segment toll 
    _TollRate_Current = MAX(_TollRate_adj, LW.MINSEGTOLL)
    
    ;MSA for toll      
    LW.TOLL = _TollRate_Current 
  
    PRINT CSV=T, LIST=ITERATION(5.0),A(5.0),B(5.0),LW.TOLLSEGNUM(10.0),_TollRate(15.2),_TollRate_adj(15.2),_TollRate_Current(15.2),LW.TOLL(15.2),V/C(10.2),{Toll Exponent}(10.2),PRINTO=2

  ENDIF
*/
;Define cost in terms of pathfinding variables; once the pathfinding variables stablize, changes to results will be small and gradual
FUNCTION {

COST = (LW.CM_TIME*(V1+V3+V4+V6+V7+V8) + LW.DUMMY_TIME*(V2+V5)) / CmpNumRetNum(V,'=',0,1,V)

}  
  
  
ENDPROCESS

;Avoid stopping early since model uses MSA and the RGAP values are approximate; Stop when RGAP is low for many consecutive iterations
PROCESS PHASE=CONVERGE
  IF (RGAP<{Relative Gap})
    _Counter = _Counter + 1
  ELSE
    _Counter = 0  
  ENDIF
  
  IF (_Counter >= 30)
      BALANCE = 1
  ENDIF

;ELToD Model developed by AECOM with support from RSG for Florida's Turnpike Enterprise  
ENDPROCESS
ENDRUN
