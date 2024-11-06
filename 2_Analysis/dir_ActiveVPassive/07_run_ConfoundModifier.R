## Libraries
pacman::p_load(here, tidyverse)

# Noting our participant IDs
PIDs <- read.table("00_Participants.txt")[,1] %>%
          sprintf("%04d",.)

# Creating a function to write the data into text files
file_editer <- function(subs, run, additional_confounds){
  
  # Iterating through each unique PID present in the dataframe
  for (PID in subs){
    
    # Searching for a specific case of a subject ID being entered incorrectly and correcting it
    if (PID == "SR-30461"){
      df_individ$PID <- "SR-3046"
      PID <- "SR-3046"
    }
    
    # Reading in the subject's confound file
    df_confounds <- read.table(paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-",
                                      str_extract(PID, "....$"),
                                      "/func/sub-", str_extract(PID, "....$"),
                                      "_task-uncertainty_run-", run, "_desc-confounds_timeseries_reduced.tsv"), 
                               header = T,
                               sep = "\t")
    
    # If the subject ID is one of the following
    if (PID %in% c("SR-0035", "SR-4590", "SR-6943", "SR-6799", "SR-6977", "SR-8746", "SR-5006")){
    
      # Adding additional confounds manually
      if (!is.null(additional_confounds)){
        
        # Adding 0s for the fixation and visual check screens
        zero_start <- as.data.frame(matrix(0, nrow = 45, 
                                           ncol = ncol(additional_confounds), 
                                           dimnames = list(1:45, 
                                                           names(additional_confounds))))
        zero_end <- as.data.frame(matrix(0, nrow = (nrow(df_confounds) - nrow(additional_confounds) - nrow(zero_start)), 
                                         ncol = ncol(additional_confounds), 
                                         dimnames = list(1:(nrow(df_confounds) - nrow(additional_confounds) - nrow(zero_start)), 
                                                         names(additional_confounds))))
        
        # Combining the dataframes
        df_confounds <- additional_confounds %>%
                        rbind(zero_start, ., zero_end) %>%
                        cbind(df_confounds, .)
      }
      
    }
    
    # If the subject ID is one of the others
    if (!(PID %in% c("SR-0035", "SR-4590", "SR-6943", "SR-6799", "SR-6977", "SR-8746", "SR-5006"))){
      
      # Adding additional confounds manually
      if (!is.null(additional_confounds)){
        
        # Adding 0s for the fixation and visual check screens
        zero_start <- as.data.frame(matrix(0, nrow = 30, 
                                           ncol = ncol(additional_confounds), 
                                           dimnames = list(1:30, 
                                                           names(additional_confounds))))
        zero_end <- as.data.frame(matrix(0, nrow = (nrow(df_confounds) - nrow(additional_confounds) - nrow(zero_start)), 
                                         ncol = ncol(additional_confounds), 
                                         dimnames = list(1:(nrow(df_confounds) - nrow(additional_confounds) - nrow(zero_start)), 
                                                         names(additional_confounds))))
        
        # Combining the dataframes
        df_confounds <- additional_confounds %>%
                       rbind(zero_start, ., zero_end) %>%
                       cbind(df_confounds, .)
      }
    }
    
    # Writing the confound data 
    df_confounds %>%
      write.table(., paste0("/data/Uncertainty/data/deriv/pipeline_1/fmriprep/sub-",
                            str_extract(PID, "....$"),
                            "/func/sub-", str_extract(PID, "....$"),
                            "_task-uncertainty_run-", run, "_desc-confounds_timeseries_reduced.tsv"),
                  sep = "\t", col.names = T, row.names = F)
  }
}

# Reading in stimlus specific confound information
df_a_stimvars <- read.csv("/data/Uncertainty/data/audio/StimVidTestFirstHalf_comp_audio_z.csv", row.names = 1) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestFirstHalf_luminance_z.csv", row.names = 1)) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/audio/StimVidTestFirstHalf_dialogue.csv")) %>%  
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestFirstHalf_faces.csv")) 

df_b_stimvars <- read.csv("/data/Uncertainty/data/audio/StimVidTestLastHalf_comp_audio_z.csv", row.names = 1) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestLastHalf_luminance_z.csv", row.names = 1)) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/audio/StimVidTestFirstHalf_dialogue.csv")) %>%  
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestFirstHalf_faces.csv")) 

# Updating column names
names(df_a_stimvars)[1:4] <- c("volume_z", "luminance_z", "speech_z", "face_z")
names(df_b_stimvars)[1:4] <- c("volume_z", "luminance_z", "speech_z", "face_z")

# Z-scoring the dummy coded face and dialogue variables 
df_a_stimvars$speech_z <- df_a_stimvars$speech_z %>% scale() %>% as.numeric
df_b_stimvars$speech_z <- df_b_stimvars$speech_z %>% scale() %>% as.numeric
df_a_stimvars$face_z <- df_a_stimvars$face_z %>% scale() %>% as.numeric
df_b_stimvars$face_z <- df_b_stimvars$face_z %>% scale() %>% as.numeric

## Creating a group dataframe of only first half raters
file_editer(subs = PIDs, run = 1, additional_confounds = df_a_stimvars)
file_editer(subs = PIDs, run = 2, additional_confounds = df_b_stimvars)
