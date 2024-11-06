
# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Use this .txt file to find Subject IDs
SUBJECTS=`cat ${SCRIPTS}/00_Participants.txt`

# For every subject that we analyzed at the first level ...
for SUBJ in ${SUBJECTS}; do

    # Rename the feat directories
    mv ${DERIV}/sub-${SUBJ}/func/lvl-1_ActiveVPassive.feat ${DERIV}/sub-${SUBJ}/func/lvl-1_run-1_ActiveVPassive.feat
    mv ${DERIV}/sub-${SUBJ}/func/lvl-1_ActiveVPassive+.feat ${DERIV}/sub-${SUBJ}/func/lvl-1_run-2_ActiveVPassive.feat

done