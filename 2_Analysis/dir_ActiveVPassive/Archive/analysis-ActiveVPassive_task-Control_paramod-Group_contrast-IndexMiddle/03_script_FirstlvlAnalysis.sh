SUBJ=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive/Control_Task

# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# Creating a folder for each participant to house .fsf's
echo "===> Starting processing of ${SUBJ}"
mkdir ${DERIV}/sub-${SUBJ}/func/DesignFiles

# Creating a design file name
FILENAME=design_ControlTask_ActiveVPassive.fsf

# Iterating through each run
echo "===> Creating .fsf file for ${SUBJ}"
			
# Copy the design files into the subject directory to be modified
cp ${SCRIPTS}/*_script_design_lvl1.fsf \
	${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}

# Replacing subject ID in each file
# We are using the | character to delimit the patterns
case "$SUBJ" in

	0035 | 4590 | 6943 | 6799 | 6977 | 8746 | 5006 )
		sed -i -e "s|0035|${SUBJ}|g" \
				${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
	* )
		sed -i -e "s|0035|${SUBJ}|g" \
				-e "s|240|210|g"\
				-e "s|fish|luma|g" \
				${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME} ;;
esac

# Now everything is set up to run feat
echo "===> Running FEAT for ${SUBJ}"
/usr/local/fsl/bin/feat ${DERIV}/sub-${SUBJ}/func/DesignFiles/${FILENAME}