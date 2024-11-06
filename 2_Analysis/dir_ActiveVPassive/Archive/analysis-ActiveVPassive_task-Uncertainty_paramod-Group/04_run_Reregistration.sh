#!/bin/bash -x

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive/analysis-ActiveVPassive_task-Uncertainty_paramod-Group

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Use this .txt file to find Subject IDs
SUBJECTS=`cat ${SCRIPTS}/../00_Participants.txt`

# For every subject that we analyzed at the first level ...
for SUBJ in ${SUBJECTS}; do

    # ... and for every run for every subject ...
    for RUN in 1 2; do
        
        # print this statement ...
        echo "+ Fixing Registration For ${SUBJ}'s Run ${RUN} ActiveVPassive Data+" 
        
        # denote the path to their feat directory
        FEATPATH=${DERIV}/sub-${SUBJ}/func/analysis-ActiveVPassive_task-Run${RUN}_paramod-Group_lvl-1.feat

        # Remove any matrix files from registration
        mkdir ${FEATPATH}/archive
        mv ${FEATPATH}/reg/*.mat \
            ${FEATPATH}/archive

        # Copy the standard identity matrix in place of it    
        cp $FSLDIR/etc/flirtsch/ident.mat \
            ${FEATPATH}/reg/example_func2standard.mat

        # Replace the standard with the mean functional image 
        cp ${FEATPATH}/mean_func.nii.gz \
            ${FEATPATH}/reg/standard.nii.gz

        # If there is no standard file    
        if [ ! -f "${FEATPATH}/reg/standard.nii.gz" ]; then

            # Print this statement
            echo "sub-${SUBJ}; ActiveVPassive Run ${RUN} standard.nii.gz"
        fi

        # If there is no identity matrix file
        if [ ! -f "${FEATPATH}/reg/example_func2standard.mat" ]; then

            # Print this statement
            echo "sub-${SUBJ}; ActiveVPassive Run ${RUN} example_func2standard.mat"
        fi
    done
done