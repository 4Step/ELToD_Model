RUN PGM=NETWORK 

FILEI LINKI[1] = "HEFT_40v3.net"
FILEO NETO = "unloaded_directional.net"
FILEO PRINTO[1] = "Directional_Link.csv"
;ELTODV3 SCRIPT
;if two distributions are used, the dir1-4 need to be defined for each of the four directional distributions after establishing the output link lists
;dir1 should be distribution 1 WB,SB for one subnet, dir2 is distribution 1 for EB,NB for same subnet then the dir3&4 for the other subnet
;once the two sub networks have their own link lists, they should be combined and dir1-4 columns defined according to the distribution defintions.
;see SW10th notes on details for application
 PHASE=LINKMERGE
  IF (li.1.FTYPE=91)  ; General Use Lanes
 
      _abs_x=abs(a.x - b.x)
      _abs_y=abs(a.y - b.y)
      iF (_abs_x >= _abs_y) 
         IF (a.x>b.x)
            dir1=1      ; Westbound
            dir2=0
            dir3=0
            dir4=0
         ELSE
            dir1=0     ; Eastbound
            dir2=1
            dir3=0
            dir4=0
         ENDIF
      ELSE
         IF (a.y>b.y)
            dir1=0      ; Southbound
            dir2=0
            dir3=1
            dir4=0
         ELSE
            dir1=0      ; Northbound
            dir2=0
            dir3=0
            dir4=1
         ENDIF
      ENDIF
 ENDIF 
 
  IF (li.1.FTYPE=96)  ; Express Lanes 
  
      _abs_x=abs(a.x - b.x)
      _abs_y=abs(a.y - b.y)
      IF (_abs_x >= _abs_y) 
         IF (a.x>b.x)
            dir1=1      ; Westbound
            dir2=0
            dir3=0      
            dir4=0
         ELSE
            dir1=0      ; Eastbound
            dir2=1   
            dir3=0     
            dir4=0
         ENDIF
      ELSE
         IF (a.y>b.y)
            dir1=0      ; Southbound
            dir2=0   
            dir3=1      
            dir4=0
         ELSE
            dir1=0      ; Northbound
            dir2=0   
            dir3=0      
            dir4=1
         ENDIF
      ENDIF
      
  ENDIF 
      _Cnt=_Cnt+1

IF (_CNT=1)
  PRINT CSV=T LIST='  A,  B,  Dir1, Dir2, Dir3, Dir4, FTYPE, Comments: WB=1 EB=2 SB=3 NB=4' PRINTO=1; specifies titles for output csv file
;PRINT CSV=T LIST='  A,  B,  Dir1, Dir2, Dir3, Dir4, Comments: 1=I595 EB & 2=I595 WB'
ENDIF

IF ((dir1=1,0,0,0) && (dir2=0,1,0,0) && (dir3=0,0,1,0) && (dir4=0,0,0,1) && (FTYPE=91,96)) ; This outputs only for specified FTypes (General Use Lanes & Express Lanes)

  PRINT CSV=T LIST=a,b,dir1,dir2,dir3,dir4,FTYPE, PRINTO=1

ENDIF

ENDPHASE

ENDRUN
