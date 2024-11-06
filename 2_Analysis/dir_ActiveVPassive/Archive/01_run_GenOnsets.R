# Calling the tidyverse package
pacman::p_load(here,  
               tidyverse)

## Listing all of the relevant files
files <- list.files(paste0(here(), "/3_Data/AvgROIs"), 
                                full.names = TRUE)
    
## Removing file names that do not match the type
files <- files[grepl(pattern = "run-1_nROI-100", files)]
        
## Iterating through each of these files
for (FILE in 1:length(files)){
  
  ## Reading in the data for this iteration
  df_ <- read.csv(files[FILE])
                  
  ## Identifying the Run for this participant
  Run <- sub(".*/sub-\\d+_(run-\\d+)_.*", "\\1", files[FILE])
  
  ## Identifying the Participant ID for this file 
  PID <- sub(".*/sub-(\\d+)_.*", "\\1", files[FILE])
            
  ## Renaming the column headers
  names(df_) <- paste0("sub-", PID, "_", Run, "_ROI-",1:ncol(df_))

  # Check directory
  if (!dir.exists(paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-", PID,"/onset/"))){
    
    # If the directory isn't there, make it
    dir.create(paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-", PID,"/onset/"))
    
  }

  # If the participant's file has 759 datapoints 
  if (nrow(df_) == 759){

    # Create a new dataframe of onset sequences that removes the first 90 and last 90 seconds, plus the 17 second buffer
    data <- data.frame(onset = 107, duration = (nrow(df_) * 2) - 90, mod = 1)

  }
  
  # If the participant's file has 729 datapoints
  if (nrow(df_) == 729){
    
    # Create a new dataframe of onset sequences that removes the first 60 and last 60 seconds, plus the 17 second buffer
    data <- data.frame(onset = 77, duration = (nrow(df_) * 2) - 60, mod = 1)

  }

  # Saving the onset files
  write.table(data, 
              paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-", PID,"/onset/sub-", PID, "ActiveVPassive_timing.txt"), 
              sep = "\t", col.names = F, row.names = F)
}
