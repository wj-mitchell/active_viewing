RUN=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive

# Now everything is set up to run feat
echo "===> Running FEAT for Run ${RUN} using file: design_run-${RUN}_ActiveVPassive.fsf"
/usr/local/fsl/bin/feat ${SCRIPTS}/*_script_design_lvl2_run-${RUN}.fsf