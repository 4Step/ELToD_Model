FILEO PRINTO[1] = "{SCENARIO_DIR}\Parameters.PRN"

PRINT CSV=T, LIST= 'Input Files'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Network File'(50L), '{Network}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Link File'(50L), '{Toll Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Directional Link File'(50L), '{Directional Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Pull Link File'(50L), '{Pull Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Cap Speed File'(50L), '{Cap Spd Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Express Lane Link File'(50L), '{Express Lane Link File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Link FTYPE Number'(50L), '{Toll Link FTYPE Number}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  HOV Link FTYPE Number'(50L), '{HOV Link FTYPE Number}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table Type'(50L), '{Trip Table Type}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table Factor'(50L), '{Trip Table Factor}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Trip Table File'(50L), '{Trip Table}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Hourly Distribution File'(50L), '{Hourly Distribution File}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Number of Zones'(50L), '{Number of Zones}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Link Attribute Name'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Distance'(50L), '{Distance}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Number of Lanes'(50L), '{Number of Lanes}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Facility Type'(50L), '{Facility Type}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Free Flow Speed'(50L), '{Free Flow Speed}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Capacity per Line'(50L), '{Capacity per Lane}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Assignment Parameters'(50L), PRINTO=1
PRINT CSV=T, LIST= '  Assignment Method'(50L), '{Assignment Method}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Max Iteration'(50L), '{Max Iteration}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Relative Gap'(50L), '{Relative Gap}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Min Link Congested Speed'(50L), '{Min Link Congested Speed}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use Cube Cluster'(50L), '{Use Cube Cluster}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Pricing Policy'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Minimum Per Segment Toll'(50L), '{Min Per Segment Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Maximum Per Segment Toll'(50L), '{Max Per Segment Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use Minimum Per Segment Toll in Network'(50L), '{Override Minimum Per Segment Toll in Network}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Minimum Per Trip Toll'(50L), '{Min Trip Toll}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  HOV Discount Rate'(50L), '{HOV Discount Rate}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Policy Curve Exponent Coefficient'(50L), '{Toll Exponent}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  VC Toll Offset'(50L), '{VC Toll Offset}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Volume Delay Function Parameters'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Volume Delay Function'(50L), '{Volume Delay Function}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik P'(50L), '{Akcelik P}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik T'(50L), '{Akcelik T}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik pb'(50L), '{Akcelik pb}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Akcelik Offset'(50L), '{Akcelik Offset}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  BPR Alpha'(50L), '{BPR Alpha}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  BPR Beta'(50L), '{BPR Beta}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Use BPR Coefficients in Network'(50L), '{Override BPR Coefficients in Network}'(90L),PRINTO=1

PRINT CSV=T, LIST= 'Choice Model Coefficients'(50L),PRINTO=1
PRINT CSV=T, LIST= '  Hourly Parameters'(50L), '{Hourly Parameters}'(190L),PRINTO=1
PRINT CSV=T, LIST= '  Toll Coefficient (beta)'(50L), '{Toll Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Travel Time Coefficient (alpha)'(50L), '{Travel Time Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Coefficient'(50L), '{Reliability Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Time Coefficient Gamma'(50L), '{Reliability Time Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Reliability Distance Coefficient Eta'(50L), '{Reliability Distance Coefficient}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Coefficient Steepness'(50L), '{Perceived Time Coefficient Alpha}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Mid Point VC Ratio'(50L), '{Perceived Time Min VC Ratio}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Perceived Time Max VC Ratio'(50L), '{Perceived Time Max VC Ratio}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty Y'(50L), '{Distance Penalty Y}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty X1'(50L), '{Distance Penalty X1}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  Distance Penalty X2'(50L), '{Distance Penalty X2}'(90L),PRINTO=1
PRINT CSV=T, LIST= '  One Express Lane Time Weight'(50L), '{One Express Lane Time Weight}'(90L),PRINTO=1

