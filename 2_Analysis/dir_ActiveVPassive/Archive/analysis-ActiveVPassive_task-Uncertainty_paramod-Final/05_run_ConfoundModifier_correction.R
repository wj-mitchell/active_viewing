## Libraries
pacman::p_load(here, tidyverse)

# Noting our participant IDs
PIDs <- read.table("00_Participants.txt")[,1] %>%
  sprintf("%04d",.)

# Iterating through each unique PID present in the dataframe
for (PID in PIDs){
  
  for (RUN in c(1,2)){
    
    # Reading in the subject's confound file
    df_confounds <- read.table(paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-",
                                      PID, "/func/sub-", PID, "_task-uncertainty_run-", RUN, 
                                      "_desc-confounds_timeseries_reduced.tsv"), 
                               header = T,
                               sep = "\t")
    
    # Checking if the columns is present
    if ("avg_rating_timecourse" %in% names(df_confounds)){
      
      # Removing Average Rating time Course
      df_confounds <- df_confounds %>% select(-c(avg_rating_timecourse))
      
    }
    
    # Writing the confound data 
    df_confounds %>%
      write.table(., paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-",
                            PID, "/func/sub-", PID, "_task-uncertainty_run-", RUN, 
                            "_desc-confounds_timeseries_reduced.tsv"), 
                  sep = "\t", col.names = T, row.names = F)
    
  }
}