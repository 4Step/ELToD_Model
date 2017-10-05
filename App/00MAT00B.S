;;<<Default Template>><<MATRIX>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX
FILEI MATI[1] = "{Trip Table}Trip Table @TP@.MAT"
FILEO MATO[1] = "Trip Table @IterNum@.MAT",
MO=11-13,NAME=SOV,HOV,TRK
FILEI LOOKUPI[1] = "{Hourly Distribution File}"
LOOKUP LOOKUPI=1, NAME=GETHRFACTOR, LOOKUP[1]=1, RESULT=2, 
                                    LOOKUP[2]=1, RESULT=3,INTERPOLATE=F

IF (@IterNum@=7-9)     ;AM                              
  MW[1]=MI.1.AM_SOV
  MW[2]=MI.1.AM_HOV
  MW[3]=MI.1.AM_TRK
ELSEIF (@IterNum@=10-16) ;MD
  MW[1]=MI.1.MD_SOV
  MW[2]=MI.1.MD_HOV
  MW[3]=MI.1.MD_TRK
ELSEIF (@IterNum@=17-19) ;PM
  MW[1]=MI.1.PM_SOV
  MW[2]=MI.1.PM_HOV
  MW[3]=MI.1.PM_TRK
ELSE  ;NT
  MW[1]=MI.1.NT_SOV
  MW[2]=MI.1.NT_HOV
  MW[3]=MI.1.NT_TRK
ENDIF
;The diurnal factors need to be normalized to each time period. 
IF (I={Zones in Direction 1})  ;                                
  MW[11] = MW[1]*GETHRFACTOR(1,@IterNum@)
  MW[12] = MW[2]*GETHRFACTOR(1,@IterNum@)
  MW[13] = MW[3]*GETHRFACTOR(1,@IterNum@)
ELSE  ;NB
  MW[11] = MW[1]*GETHRFACTOR(2,@IterNum@)
  MW[12] = MW[2]*GETHRFACTOR(2,@IterNum@)
  MW[13] = MW[3]*GETHRFACTOR(2,@IterNum@)
ENDIF


ENDRUN
