# ELToD_Model
Express Lanes Time of Day Model

This repository holds all ELToD versions along with ongoing work. The release tabs show the model versions.

Currently only static assignment models are in used for project applications. The dynamic assignment version ELToD v 3.0 needs to be re-written for runtime efficiency and to cover other planning needs.

## Static Assignment Models:
1. ELToD v 2.2: Old Policy
2. ELToD v 2.3: New Policy
3. ELToD v 2.3.1: Combined Old & New Policies
4. ELToD v 2.3.2: Integrated Policies

## DTA Models:
- ELToD 3.0 shall be on a different project or branch
- ELToD 4.0 shall be on a different project or branch

At some point, dynamic versions (ELToD 3.0 and ongoing ELToD v 4.0) shall be maintained here possibly as separate branch.

# Development vs Application
ELToD is considered "Development" and any project that uses "ELToD" is considered an application project. The application projects include all forecasting work whether it's revenue forecast or traffic or PD&E forecasts. All ELToD Model versions (at least 2.x) shall be maintained under **ELToD_MODEL** repository. All **projects** that use these versions are maintained under repsective projecct repos with "ELTOD_Model" repo as submodule. In short all project that contain ELToD model shall be pointed to here (downloaded from here).

# Sub-Module
The goal is to maintain a proejct independent repo for ELToD and any application related changes are maintained in project repo. Typicaly application changes include: changes to input files, CAT key values to project files, scenario management (child & sibilings). If it is required to modify ELToD scripts, APP and CAT files (such as creating new keys or adding new sub-APP or modifing scripts) then those changes can be made directly to this repo (or project > submodule repo). However, all modifications to "ELToD_Model" repo from a project repo (submodule) should be approved by designated "gate keepers" before the mergeing into master branch. This can be implemented in one of the two ways:

1. **Limit push access**: Only designated users are allowed to make changes to this repo while everyone can access it. This allows to maintain a working copy at all times while allowing users to freely apply ELToD Model.  
2. **Merge branch restriction from sub-module"**: Any changes coming from sub-module should be approved by one additional person. All users have same rights but since the ELToD modifications are made in project specific repos, someelse else should second (QC) it (not sure if git has this feature). 



