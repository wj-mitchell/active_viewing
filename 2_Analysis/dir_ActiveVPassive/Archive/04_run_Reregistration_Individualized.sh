#!/bin/bash -x

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive/Archive

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# For each of our runs ...
for RUN in 1 2; do

    # If run is equal to 1 or 2 ...
    case "$RUN" in

        1 )
            # Use this .txt file to find Subject IDs
            SUBJECTS=`cat ${SCRIPTS}/00_CondA.txt` ;;

        2 )
            # Use this .txt file to find Subject IDs
            SUBJECTS=`cat ${SCRIPTS}/00_CondB.txt` ;;

    esac

    # For every subject that we analyzed at the first level ...
    for SUBJ in ${SUBJECTS}; do

        # print this statement ...
        echo "+ Fixing Registration For ${SUBJ}'s ActiveVPassive Data (Run ${RUN})+" 
        
        # denote the path to their feat directory
        FEATPATH=${DERIV}/sub-${SUBJ}/func/lvl-1_run-${RUN}_ActiveVPassive_Individualized.feat

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