
RUN PGM=MATRIX ;converting a csv to cube matrix
FILEI MATI[1] = "2040_AM.csv",
  PATTERN=IJ:V, FIELDS=#1,0,2-34
FILEO MATO[1] = "2040_AM.MAT",
  MO=1-3 NAME=SOV,HOV,TRK
  
zones=33

MW[1]=MI.1.1

ENDRUN

RUN PGM=MATRIX ;converting a csv to cube matrix
FILEI MATI[1] = "2040_PM.csv",
  PATTERN=IJ:V, FIELDS=#1,0,2-34
FILEO MATO[1] = "2040_PM.MAT",
  MO=1-3 NAME=SOV,HOV,TRK
  
zones=33  

MW[1]=MI.1.1

ENDRUN

RUN PGM=MATRIX ;converting a csv to cube matrix
FILEI MATI[1] = "2040_OP.csv",
  PATTERN=IJ:V, FIELDS=#1,0,2-34
FILEO MATO[1] = "2040_OP.MAT",
  MO=1-3 NAME=SOV,HOV,TRK
  
zones=33  

MW[1]=MI.1.1

ENDRUN