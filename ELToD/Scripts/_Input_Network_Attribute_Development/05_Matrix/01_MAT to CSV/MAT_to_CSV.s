RUN PGM=MATRIX 
FILEO PRINTO[1] = "Output.csv"
FILEI MATI[1] = "FinalHTTAB_G40_SA _Adj.MAT"

    JLOOP
      if (j=1) print printo=1 list=i(10.2L),',',j(10.2L),',' ; 2 decimals
      PRINT PRINTO=1 LIST='\\',MI.1.1(10.2L)    ; write value without changing line - 2 decimals 
      IF(J<ZONES) PRINT PRINTO=1 LIST='\\,'     ; write comma without changing line - 2 decimals
    ENDJLOOP


ENDRUN
