#!/bin/bash -x

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive
    
# Denote which script we wish to run in parallel
SCRIPTNAME=${SCRIPTS}/*_script_SecondLvlAnalysis.sh

# Denote the number of scripts that we wish to run in parallel at any given time
NSUBJ=4

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# For each of our runs ...
for RUN in 1 2; do

    # Print a statement regarding which subject we are currently analyzing
    echo "+++++ Second Level Processing ${SUBJ} +++++"

    # While the number of concurrent active jobs matching SCRIPTNAME is equal to NSUBJ ...
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NSUBJ ]; do

        # Do nothing except checking bakc every minute
        sleep 1m

    # If the number of active jobs drops below NSUBJ
    done

    # Run the script for this run
    bash $SCRIPTNAME $RUN &

    # And wait 5 seconds before doing the next thing
    sleep 5s
   
done