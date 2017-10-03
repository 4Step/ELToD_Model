; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=NETWORK MSG='Unbuild the Network'
FILEI LINKI[1] = "Original.net"
FILEO NODEO = "NODE.DBF",
    INCLUDE=X,Y,N
FILEO LINKO = "LINK.DBF",
    INCLUDE=A,B,NUM_LANES,CAPACITY,DISTANCE,SPEED,FTC2;VOL_PULL,EDITID,TOLLLINK,PULLLINK

; Unbuild Network

ENDRUN

RUN PGM=NETWORK MSG='Rebuild the Network'

FILEI NODEI[1] = "NODE.DBF"
FILEI LINKI[1] = "LINK.DBF"
FILEO NETO = "Updated.net",
  EXCLUDE=FTC2
  
  ZONES=103 ;enter # of TAZs in network

  FTYPE=LI.1.FTC2
  
  
; Rebuild Network

ENDRUN