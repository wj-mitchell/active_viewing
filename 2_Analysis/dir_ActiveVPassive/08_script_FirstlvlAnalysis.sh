SUBJ=$1
RUN=$2
COND=$3

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Creating a folder for each participant to house .fsf's
echo "===> Starting processing of ${SUBJ}"
mkdir ${DERIV}/sub-${SUBJ}/func/DesignFiles

    case $COND in
        "A")
			case $RUN in
				"1")
					# Creating a design file name
					TEMPLATE=${SCRIPTS}/*_script_design_lvl1_rating.fsf
					FILENAME=analysis-ActiveVPassive_task-Run${RUN}_lvl-1_rating.fsf 
					;;
				"2")
					# Creating a design file name
					TEMPLATE=${SCRIPTS}/*_script_design_lvl1_non-rating.fsf
					FILENAME=analysis-ActiveVPassive_task-Run${RUN}_lvl-1_non-rating.fsf 
					;;
			esac
			;;
        "B")
			case $RUN in
				"1")
					# Creating a design file name
					TEMPLATE=${SCRIPTS}/*_script_design_lvl1_non-rating.fsf
					FILENAME=analysis-ActiveVPassive_task-Run${RUN}_lvl-1_non-rating.fsf 
					;;
				"2")
					# Creating a design file name
					TEMPLATE=${SCRIPTS}/*_script_design_lvl1_rating.fsf
					FILENAME=analysis-ActiveVPassive_task-Run${RUN}_lvl-1_rating.fsf 
					;;
			esac
			;;
    esac

# Iterating through each run
echo "===> Creating .fsf file for ${SUBJ}, run ${RUN}"
			
# Copy the design files into the subject directory to be modified
cp $TEMPLATE \
	${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}

# Replacing subject ID in each file
# We are using the | character to delimit the patterns
case "$SUBJ" in

	0035 | 4590 | 6943 | 6799 | 6977 | 8746 | 5006 )
		sed -i -e "s|0295|${SUBJ}|g" \
				-e "s|run-1|run-${RUN}|g" \
				-e "s|run1|run${RUN}|g" \
				-e "s|Run-1|Run-${RUN}|g" \
				-e "s|Run1|Run${RUN}|g" \
				${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
	* )
		sed -i -e "s|0295|${SUBJ}|g" \
				-e "s|run-1|run-${RUN}|g" \
				-e "s|run1|run${RUN}|g" \
				-e "s|Run-1|Run-${RUN}|g" \
				-e "s|Run1|Run${RUN}|g" \
				-e "s|759|729|g"\
				${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
esac

# Now everything is set up to run feat
echo "===> Running FEAT for ${SUBJ}, run ${RUN}"
/usr/local/fsl/bin/feat ${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}