; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=MATRIX PRNFILE="HEFT_Y2025.PRN" MSG='AM Peak Period'
FILEO MATO[1] = "output_correlated_YR2040_OP.MAT", ;new smaller aggregated matrix, 33x daily
  MO=1-3, NAME=SOV,HOV,TRK
FILEI MATI[1] = "NewTT_OP.MAT" ; original full matrix, 103x daily

MW[1]  = mi.1.1  ; SOV
;MW[2]  = mi.1.2  ; HOV
;MW[3]  = mi.1.3  ; TRK


RENUMBER, 
 FILE = "COMPRESS.PRN",
          MISSINGZI=M, MISSINGZO=W

ENDRUN
