;;<<Default Template>><<HIGHWAY>><<Default>>;;
; Do not change filenames or add or remove FILEI/FILEO statements using an editor. Use Cube/Application Manager.
RUN PGM=HIGHWAY
FILEI MATI[1] = "{Trip Table}"
FILEI NETI = "{Network}"

PROCESS PHASE=LINKREAD
; Use this phase to obtain initial values from the input network (LI.varname) and compute 
; link values (LW.varname) that can be used in other phases.


ENDPROCESS


PROCESS PHASE=ILOOP
; This phase performs a zonal loop (I=1,Zones).  This phase is required and must contain
; at least 1 PATHLOAD statement.  Almost all MATRIX operation are available in this phase
; and the PATHLOAD statement can be used to build and load paths for assignment


ENDPROCESS


PROCESS PHASE=ADJUST
; This phase is automatically run after the ILOOP phase.  The volume-delay functions (TC) are
; automatically recomputed in this phase to update the link congested travel times based 
; on the volumes from the ILOOP phase.  User defined link computations (LW.varname) that 
; need to be updated based on the new congested travel times should be coded in this phase.


ENDPROCESS

;PROCESS  PHASE=CONVERGE

; The CONVERGE phase process is provided to allow the user to program his/her own method of 
; setting convergence. The user can write script to determine if the desired measure has been met. 
; When the results are satisfactory, the script should set the variable BALANCE to 1. 
; That will indicate to the program that further iterations are not to be undertaken. 
; Note that if PHASE=CONVERGE is detected within the script, the standard tests are not performed and 
; termination will be determined by the value of BALANCE after the phase is completed. If BALANCE 
; is never set to 1, the program will continue until MAXITERS is satisfied. BALANCE is automatically 
; set to 0 when the phase begins.
; An example of a statement setting BALANCE in this PHASE might be:
;  IF (RGAP <= 0.001) BALANCE=1
; This setting would continue to perform addtional iterations until the computed relative gap measure
; is <=0.001 or the MAXITERS PARAMETER value is reached.

;ENDPROCESS 


ENDRUN
