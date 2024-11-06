SUBJ=$1

# PROJECT captures the filepath for all relevant project data, scripts, documents, etc.
PROJECT=/data/Uncertainty

# SCRIPTS should contain the analysis scripts for this project
SCRIPTS=${PROJECT}/scripts/2_Analysis/dir_ActiveVPassive
    
# DERIV  should contain our data that has been processed through fMRIPrep. 
DERIV=${PROJECT}/data/deriv/pipeline_1/fmriprep

# ANAT should contain this subjects anatomical directory
ANAT=${DERIV}/sub-${SUBJ}/anat

# Loop through all T1-weighted MRI files in the input directory
for t1_image in $ANAT/*_T1w.nii.gz; do

  # Extract filename without extension
  filename=$(basename "$t1_image" .nii.gz)
  
  # Output file path
  output_file="${ANAT}/${filename}_brain.nii.gz"
  
  # Run BET
  bet "$t1_image" "$output_file" -f 0.2 -g 0
  
  echo "Processed $t1_image -> $output_file"

done

