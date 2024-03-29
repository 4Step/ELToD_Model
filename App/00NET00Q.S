;;<<Default Template>><<NETWORK>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Final Daily Loaded Network'
FILEI LINKI[4] = "{SCENARIO_DIR}\LOADED_NT.NET"
FILEO NETO = "{SCENARIO_DIR}\LOADED_DY.NET",
EXCLUDE=HRCAP,FFSPD,TOLL,TIME1,TIME2,LINKGRP1,LINKGRP2,LINKGRP3,ASGNGRP,USER,COST,TWOWAY,
VOLUME,DIRCODE,VOLPURP1,CGSTDTIME,V_1,TIME_1,VC_1,VT_1,CSPD_1,VDT_1,VHT_1,V1_1,V2_1,V3_1,V4_1,V5_1,V6_1,V7_1,V8_1,V1T_1,V2T_1,V3T_1,V4T_1,V5T_1,
V6T_1,V7T_1,V8T_1,LW_TOLL_1,LW_DUMMY_TIME_1,LW_CGTIME_1
FILEI LINKI[3] = "{SCENARIO_DIR}\LOADED_MD.NET"
FILEI LINKI[2] = "{SCENARIO_DIR}\LOADED_PM.NET"
FILEI LINKI[1] = "{SCENARIO_DIR}\LOADED_AM.NET"

MERGE RECORD=FALSE
DY_SOV = LI.1.AM_SOV + LI.2.PM_SOV + LI.3.MD_SOV + LI.4.NT_SOV
DY_HOV = LI.1.AM_HOV + LI.2.PM_HOV + LI.3.MD_HOV + LI.4.NT_HOV
DY_TRK = LI.1.AM_TRK + LI.2.PM_TRK + LI.3.MD_TRK + LI.4.NT_TRK

DY_TOT = DY_SOV + DY_HOV + DY_TRK

;DY_TOT_SL = LI.1.AM_TOT_SL + LI.2.PM_TOT_SL + LI.3.MD_TOT_SL + LI.4.NT_TOT_SL
ENDRUN
