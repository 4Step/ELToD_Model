RUN PGM=NETWORK 

FILEI LINKI[1] = "unloaded_with_vclose2040_v13.96.net"
FILEO NETO = "unloaded_with_vclose2040_v14.net"
FILEO PRINTO[1] = "Directional_Link.csv"

 PHASE=LINKMERGE
  IF (li.1.ftc2=91)  ; General Use Lanes
 
      _abs_x=abs(a.x - b.x)
      _abs_y=abs(a.y - b.y)
      iF (_abs_x >= _abs_y) 
         IF (a.x>b.x)
            dir1=0      ; Westbound
            dir2=1
            dir3=0
            dir4=0
         ELSE
            dir1=1     ; Eastbound
            dir2=0
            dir3=0
            dir4=0
         ENDIF
      ELSE
         IF (a.y>b.y)
            dir1=0      ; Southbound
            dir2=1
            dir3=0
            dir4=0
         ELSE
            dir1=1      ; Northbound
            dir2=0
            dir3=0
            dir4=0
         ENDIF
      ENDIF
 ENDIF 
 
  IF (li.1.ftc2=96)  ; Express Lanes 

      iF (_abs_x >= _abs_y) 
         IF (a.x>b.x)
            dir1=0      ; Westbound
            dir2=0
            dir3=0      
            dir4=1
         ELSE
            dir1=0      ; Eastbound
            dir2=0   
            dir3=1     
            dir4=0
         ENDIF
      ELSE
         IF (a.y>b.y)
            dir1=0      ; Southbound
            dir2=0   
            dir3=0      
            dir4=1
         ELSE
            dir1=0      ; Northbound
            dir2=0   
            dir3=1      
            dir4=0
         ENDIF
      ENDIF
      
  ENDIF 
      _Cnt=_Cnt+1

IF (_CNT=1)
  PRINT CSV=T LIST='  A,  B,  Dir1, Dir2, Dir3, Dir4, Comments: 1=I595 EB & 2=I595 WB' PRINTO=1

ENDIF

IF ((dir1=1,0,0,0) && (dir2=0,1,0,0) && (dir3=0,0,1,0) && (dir4=0,0,0,1) && (FTC2=91,96)) ; General Use Lanes & Express Lanes

  PRINT CSV=T LIST=a,b,dir1,dir2,dir3,dir4,dir_id, PRINTO=1

ENDIF

ENDPHASE

ENDRUN
