RUN PGM=NETWORK
FILEI LINKI[1] = "Network_YR2040v3.net"
FILEO PRINTO[1] = "Toll_Link.csv"
FILEO PRINTO[2] = "Pull_Link.csv"
;FILEO PRINTO[3] = "DMNs.csv"
FILEO NETO = "Network_YR2045v3out.net"


PROCESS PHASE=NODEMERGE
;Print Header
_Cnt=_Cnt+1
_TOLL_POLICY=1
_TOLL=0

  
  IF (_CNT=1);TOLL LINK FILE
    PRINT CSV=T LIST='  A,  B, TOLLSEGNUM , TOLLSEGLEN, MINSEGTOLL' PRINTO=1 ;these are the titles for the csv file fields
  ENDIF
   
  IF (_CNT=1);PULL LINK FILE
    PRINT CSV=T LIST='  A,  B,  PULL, SEGMENT ID' PRINTO=2 ;these are the titles for the ELToDv2 csv file fields
  ENDIF
 /* 
  IF (_CNT=1)
    PRINT CSV=T LIST='  N,  SEGNUM,  PROHIBIT_LINKS' PRINTO=3
  ENDIF
 
 ;Decision Making Nodes
  IF ((ni.1.dmn=1) && (ni.1.segnumid>=0))
  
    PRINT CSV=T LIST=n,segnumid,PRINTO=3
  
  ENDIF
*/
ENDPROCESS

PROCESS PHASE=LINKMERGE
 ;PULL LINK FILE (ONLY NEED ONE IF FOR ELTODv2 (comment out direction 2-4 as below).
 ;XL NB EB = 1
  IF (li.1.PULLLINK>0)
  ;direction=1
   
  PRINT CSV=T LIST=a,b,PULL,seg_id, PRINTO=2 ;these are the link attributes to include in the csv file
 
  ENDIF 
/*
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
  */
   ;Toll Link
  IF (li.1.tolllink>0)

  PRINT CSV=T LIST=a,b,seg_id,TOLLSEGLEN,MINSEGTOLL PRINTO=1 ;these are the link attributes to include in the csv file
  ;ELToDv2 = A,  B, TOLLSEGNUM , TOLLSEGLEN, MINSEGTOLL
  ;ELToDv3 = A,  B, TOLLSEGNUM, TOLL_POLICY, TOLL, DIRECTION, SEG_DISTANCE,
  
  ENDIF
  
 ENDPROCESS
  
ENDRUN
