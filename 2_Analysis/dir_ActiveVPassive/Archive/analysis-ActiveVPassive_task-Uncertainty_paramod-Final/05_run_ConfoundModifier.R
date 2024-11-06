## Libraries
pacman::p_load(here, tidyverse)

# Loading the custom cleaning function
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/rucleaner.R", local= T)

# Noting the index number of all .csv files in the directory
dir <- paste0(here(), "/../data/behav/")
files <- list.files(path = dir, 
                    full.names = F) %>%
         .[grep(pattern = "*\\.csv",
              x = .)]

# Iterating through sequential integers up to the total number of .csvs
# Taking this approach rather than using the index numbers directly makes
# this code robust to any ordering changes that might occur in the files.
# (i.e., if the .csv files were listed after the .txts for some reason,
# the conditional statements binding the data together would get confused)
for (INDEX in 1:length(files)) {
  
  # Running the cleaner function for an individual file within the noted directory
  df_temp <- rucleaner(file = files[INDEX],
                       dir = dir,
                       unit_secs = NA,
                       shave_secs = 0)
  
  # if this is the first file we're cleaning . . .
  if (INDEX == 1) {
    
    # Make it the master dataframe
    df <- df_temp
    
    # Remove the temporary dataframe
    rm(df_temp)
    
  }
  
  # If this is not the first file we're cleaning . . .
  if (INDEX != 1) {
    
    # Append it to the end of the master dataframe
    df <- rbind(df, df_temp)
    
    # Remove the temporary dataframe
    rm(df_temp)
    
  }
  
}

# Coercing the stucture of my data into a numeric format
df$CertRate <- df$CertRate %>% as.numeric()

# Creating a function to clean the data into subsets
group_subsetter <- function(data = ., condition){

  # Return these values
  return( 
    
    # Subset data from select columns that is not from the control video and comes from the specified condition
   subset(data, 
           data$Video != "StimVidControl.mp4" & data$Video != "StimVidControl_Undoing.mp4" & data$Condition == condition, 
           select = c(PID, CertRate, Seconds)) %>%
      
    # Group this data by PID
    group_by(PID) %>%
      
    # Sort this data by PID and time
    arrange(PID, Seconds) %>% 
      
    # Calculate changes in certainty rating and prepend 0 for the first row to keep the length of the column equal
    mutate(Change = c(0, diff(CertRate))) %>% 
      
    # Identify all finger button presses, based upon rating changes, within a given two second interval
    mutate(ButtonPress = if_else(abs(Change) == 5, 1, 0), Interval = floor(Seconds / 2) * 2) %>%  
      
    # Group the data by Intervals
    group_by(Interval) %>%  
      
    # Count the number of button presses for each interval.
    summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')
  )
}

# Creating a function to clean the data into subsets
subsetter <- function(data = ., condition){
  
  # Return these values
  return( 
    
    # Subset data from select columns that is not from the control video and comes from the specified condition
    subset(data, 
           data$Video != "StimVidControl.mp4" & data$Video != "StimVidControl_Undoing.mp4" & data$Condition == condition, 
           select = c(PID, CertRate, Seconds)) %>%
      
      # Group this data by PID
      group_by(PID) %>%
      
      # Sort this data by PID and time
      arrange(PID, Seconds) %>% 
      
      # Calculate changes in certainty rating and prepend 0 for the first row to keep the length of the column equal
      mutate(Change = c(0, diff(CertRate))) %>% 
      
      # Identify all finger button presses, based upon rating changes, within a given two second interval
      mutate(ButtonPress = if_else(abs(Change) == 5, 1, 0), Interval = floor(Seconds / 2) * 2) %>%  
      
      # Group the data by Intervals
      group_by(PID, Interval) %>%  
      
      # Count the number of button presses for each interval.
      summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')
  )
}

# Creating a function to write the data into text files
file_editer <- function(group_data, individ_data, subs, run, additional_confounds){
  
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
    
    # If this subject was within this condition
    if (PID %in% unique(individ_data$PID)){
      
      # Subset out this specific subjects observations
      df_individ <- individ_data[individ_data$PID == PID,]
      
      # Subtract this timecourse from the group time course
      group_data$TotalButtonPresses <- group_data$TotalButtonPresses - df_individ$TotalButtonPresses
      
    }
    
    # Scale this time course
    group_data$TotalButtonPresses <- scale(group_data$TotalButtonPresses) %>% as.numeric()
    
    # Creating a new column in the confound dataframe
    df_confounds$avg_rating_timecourse <- 0
    
    # If the subject ID is one of the following
    if (PID %in% c("SR-0035", "SR-4590", "SR-6943", "SR-6799", "SR-6977", "SR-8746", "SR-5006")){
      
      # Copying over the confound in the appropriate location for each subject
      df_confounds$avg_rating_timecourse[45 + (1:nrow(group_data))] <- group_data$TotalButtonPresses
      
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
      
      # Copying over the confound in the appropriate location for each subject
      df_confounds$avg_rating_timecourse[30 + (1:nrow(group_data))] <- group_data$TotalButtonPresses
      
      
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
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestFirstHalf_faces.csv")) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/emonet/StimVidTestFirstHalf_emonet.csv", row.names = 1))  

df_b_stimvars <- read.csv("/data/Uncertainty/data/audio/StimVidTestLastHalf_comp_audio_z.csv", row.names = 1) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestLastHalf_luminance_z.csv", row.names = 1)) %>%
                 cbind(.,read.csv("/data/Uncertainty/data/audio/StimVidTestFirstHalf_dialogue.csv")) %>%  
                 cbind(.,read.csv("/data/Uncertainty/data/visuals/StimVidTestFirstHalf_faces.csv")) %>% 
                 cbind(.,read.csv("/data/Uncertainty/data/emonet/StimVidTestFirstHalf_emonet.csv", row.names = 1)) 

# Updating column names
names(df_a_stimvars)[1:4] <- c("volume_z", "luminance_z", "speech_z", "face_z")
names(df_b_stimvars)[1:4] <- c("volume_z", "luminance_z", "speech_z", "face_z")

# Z-scoring the dummy coded face and dialogue variables 
df_a_stimvars$speech_z <- df_a_stimvars$speech_z %>% scale() %>% as.numeric
df_b_stimvars$speech_z <- df_b_stimvars$speech_z %>% scale() %>% as.numeric
df_a_stimvars$face_z <- df_a_stimvars$face_z %>% scale() %>% as.numeric
df_b_stimvars$face_z <- df_b_stimvars$face_z %>% scale() %>% as.numeric

## Creating a group dataframe of only first half raters
df_a_group <- group_subsetter(data = df, condition = "A")
df_b_group <- group_subsetter(data = df, condition = "B")
df_a_individ <- subsetter(data = df, condition = "A")
df_b_individ <- subsetter(data = df, condition = "B")
file_editer(group_data = df_a_group, individ_data = df_a_individ, subs = unique(df$PID), run = 1, additional_confounds = df_a_stimvars)
file_editer(group_data = df_b_group, individ_data = df_b_individ, subs = unique(df$PID), run = 2, additional_confounds = df_b_stimvars)
