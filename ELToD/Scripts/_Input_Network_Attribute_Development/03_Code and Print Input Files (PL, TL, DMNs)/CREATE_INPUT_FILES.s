RUN PGM=NETWORK
FILEI LINKI[1] = "unloaded_with_vclose2040_v13.96.net"
FILEO PRINTO[1] = "Toll_Link.csv"
FILEO PRINTO[2] = "Pull_Link.csv"
FILEO PRINTO[3] = "DMNs.csv"
FILEO NETO = "unloaded_with_vclose2040_v14.net"


PROCESS PHASE=NODEMERGE
;Print Header
_Cnt=_Cnt+1
_TOLL_POLICY=1
_TOLL=0

  
  IF (_CNT=1)
    PRINT CSV=T LIST='  A,  B, TOLLSEGNUM , TOLL_POLICY, TOLL, DIRECTION' PRINTO=1
  ENDIF
   
  IF (_CNT=1)
    PRINT CSV=T LIST='  A,  B,  DIRECTION, SEGMENT ID' PRINTO=2
  ENDIF
  
  IF (_CNT=1)
    PRINT CSV=T LIST='  N,  SEGNUM,  PROHIBIT_LINKS' PRINTO=3
  ENDIF
 
 ;Decision Making Nodes
  IF ((ni.1.dmn=1) && (ni.1.segnumid>=0))
  
    PRINT CSV=T LIST=n,segnumid,PRINTO=3
  
  ENDIF

ENDPROCESS

PROCESS PHASE=LINKMERGE
  
 ;XL NB EB = 1
  IF (li.1.xl_nb_eb=1)
  direction=1
   
  PRINT CSV=T LIST=a,b,direction,segment_id, PRINTO=2
 
  ENDIF 

  ;XL SB WB = 1
  IF (li.1.xl_sb_wb=1)
  xl_sb_wb=2
  direction=2
  
  PRINT CSV=T LIST=a,b,direction,segment_id, PRINTO=2
 
  ENDIF 

  ;GU NB EB = 1
  IF (li.1.gu_nb_eb=1)
  gu_nb_eb=3
  direction=3
  
  PRINT CSV=T LIST=a,b,direction,segment_id, PRINTO=2
 
  ENDIF
  
  ;GU SB WB = 1
  IF (li.1.gu_sb_wb=1)
  gu_sb_wb=4
  direction=4
 
  PRINT CSV=T LIST=a,b,direction,segment_id, PRINTO=2
 
  ENDIF
  
   ;Toll Link
  IF (li.1.tolllink_id=1)

  PRINT CSV=T LIST=a,b,segment_id,_toll_policy,_toll, direction, PRINTO=1
  ;A,  B, TOLLSEGNUM , TOLL_POLICY, TOLL, DIRECTION, SEG_DISTANCE,
  
  ENDIF
  
 ENDPROCESS
  
ENDRUN
