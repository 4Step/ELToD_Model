;  Matrix Factoring - Periods >>>
;Input  DY Matrix File: 
;Output AM,PM,OP Matrix Files: 
;;<<End Parameters>>;;
RUN PGM=MATRIX
FILEI MATI[1]="output_correlated.mat"
FILEI MATI[2]="output_correlated.mat"
FILEI MATI[3]="output_correlated.mat"
FILEO MATO[1]="Y2040 AM.MAT",MO=11-13,NAME=SOV,HOV,TRK
FILEO MATO[2]="Y2040 PM.MAT",MO=21-23,NAME=SOV,HOV,TRK
FILEO MATO[3]="Y2040 OP.MAT",MO=31-33,NAME=SOV,HOV,TRK
;   ----- CONVERT Daily Matrix TO Peak Matrix set
    MW[11]= MI.1.1*.20 ;AM period matrix factor
    MW[12]= 0
    MW[13]= 0
           
    MW[21]= MI.2.1*.22 ;PM period matrix factor
    MW[22]= 0
    MW[23]= 0
           
    MW[31]= MI.2.1*.58 ;OP period matrix factor
    MW[32]= 0
    MW[33]= 0
ENDRUN
