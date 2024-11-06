#!/bin/bash

# Define the input atlas file
atlas_file="/data/tools/schaefer_parcellations/MNI/Schaefer2018_400Parcels_Kong2022_17Networks_order_FSLMNI152_1mm.nii.gz"

# Define an array of parcel indices and their corresponding intensities
declare -A parcels_intensity=(
    [56]=0.014
    [248]=0.022
)

# Create an empty file to accumulate results
fslmaths ${atlas_file} -mul 0 temp_atlas.nii.gz

# Loop through each parcel and apply the intensity
for parcel in "${!parcels_intensity[@]}"; do
    intensity=${parcels_intensity[$parcel]}
    echo "Processing parcel ${parcel} with intensity ${intensity}"

    # Create a mask for the current parcel
    fslmaths ${atlas_file} -thr ${parcel} -uthr ${parcel} -bin parcel_${parcel}.nii.gz

    # Multiply the mask by the desired intensity
    fslmaths parcel_${parcel}.nii.gz -mul ${intensity} parcel_${parcel}_intensity.nii.gz

    # Add the result to the accumulated file
    fslmaths temp_atlas.nii.gz -add parcel_${parcel}_intensity.nii.gz temp_atlas.nii.gz
done

# Apply the mask to zero out undesired areas
fslmaths temp_atlas.nii.gz -bin -mul temp_atlas.nii.gz positive_results_overlay.nii.gz

# Clean up temporary files
rm parcel_*.nii.gz temp_atlas.nii.gz


# Define an array of parcel indices and their corresponding intensities
declare -A parcels_intensity=(

    [108]=0.026
    [225]=0.012
    [311]=0.014
    [337]=0.011
)

# Create an empty file to accumulate results
fslmaths ${atlas_file} -mul 0 temp_atlas.nii.gz

# Loop through each parcel and apply the intensity
for parcel in "${!parcels_intensity[@]}"; do
    intensity=${parcels_intensity[$parcel]}
    echo "Processing parcel ${parcel} with intensity ${intensity}"

    # Create a mask for the current parcel
    fslmaths ${atlas_file} -thr ${parcel} -uthr ${parcel} -bin parcel_${parcel}.nii.gz

    # Multiply the mask by the desired intensity
    fslmaths parcel_${parcel}.nii.gz -mul ${intensity} parcel_${parcel}_intensity.nii.gz

    # Add the result to the accumulated file
    fslmaths temp_atlas.nii.gz -add parcel_${parcel}_intensity.nii.gz temp_atlas.nii.gz
done

# Apply the mask to zero out undesired areas
fslmaths temp_atlas.nii.gz -bin -mul temp_atlas.nii.gz negative_results_overlay.nii.gz

# Clean up temporary files
rm parcel_*.nii.gz temp_atlas.nii.gz
