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

df$CertRate <- df$CertRate %>% as.numeric()

## Creating a dataframe of only first half raters 
df_behav <- subset(df,
                   df$Video != "StimVidControl.mp4" &
                   df$Video != "StimVidControl_Undoing.mp4" &
                   df$Condition == "A",
                   select = c(PID, CertRate, Seconds)) %>%
                group_by(PID) %>%
                arrange(PID, Seconds) %>%  # Sort by PID and Seconds
                mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
                mutate(ButtonPress = if_else(Change == 5, 1, 0),  # Identify button presses
                       Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
                group_by( Interval) %>%  # Group by Interval only
                summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav$TotalButtonPresses <- scale(df_behav$TotalButtonPresses) %>% as.numeric()
df_behav$Interval <- df_behav$Interval + 60
df_behav$Dur <- 2
df_behav <- subset(df_behav,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run1_paramod-Group_contrast-Middle_vols-729.txt"), 
            sep = "\t", col.names = F, row.names = F)
df_behav$Interval <- df_behav$Interval + 30
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run1_paramod-Group_contrast-Middle_vols-759.txt"), 
            sep = "\t", col.names = F, row.names = F)


## Creating a dataframe of only first half raters 
df_behav <- subset(df,
                   df$Video != "StimVidControl.mp4" &
                     df$Video != "StimVidControl_Undoing.mp4" &
                     df$Condition == "A",
                   select = c(PID, CertRate, Seconds)) %>%
  group_by(PID) %>%
  arrange(PID, Seconds) %>%  # Sort by PID and Seconds
  mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
  mutate(ButtonPress = if_else(Change == -5, 1, 0),  # Identify button presses
         Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
  group_by( Interval) %>%  # Group by Interval only
  summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav$TotalButtonPresses <- scale(df_behav$TotalButtonPresses) %>% as.numeric()
df_behav$Interval <- df_behav$Interval + 60
df_behav$Dur <- 2
df_behav <- subset(df_behav,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run1_paramod-Group_contrast-Index_vols-729.txt"), 
            sep = "\t", col.names = F, row.names = F)
df_behav$Interval <- df_behav$Interval + 30
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run1_paramod-Group_contrast-Index_vols-759.txt"), 
            sep = "\t", col.names = F, row.names = F)


## Creating a dataframe of only first half raters 
df_behav <- subset(df,
                   df$Video != "StimVidControl.mp4" &
                     df$Video != "StimVidControl_Undoing.mp4" &
                     df$Condition == "B",
                   select = c(PID, CertRate, Seconds)) %>%
  group_by(PID) %>%
  arrange(PID, Seconds) %>%  # Sort by PID and Seconds
  mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
  mutate(ButtonPress = if_else(Change == 5, 1, 0),  # Identify button presses
         Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
  group_by(Interval) %>%  # Group by Interval only
  summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav$TotalButtonPresses <- scale(df_behav$TotalButtonPresses) %>% as.numeric()
df_behav$Interval <- df_behav$Interval + 60
df_behav$Dur <- 2
df_behav <- subset(df_behav,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run2_paramod-Group_contrast-Middle_vols-729.txt"), 
            sep = "\t", col.names = F, row.names = F)
df_behav$Interval <- df_behav$Interval + 30
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run2_paramod-Group_contrast-Middle_vols-759.txt"), 
            sep = "\t", col.names = F, row.names = F)


## Creating a dataframe of only first half raters 
df_behav <- subset(df,
                   df$Video != "StimVidControl.mp4" &
                     df$Video != "StimVidControl_Undoing.mp4" &
                     df$Condition == "B",
                   select = c(PID, CertRate, Seconds)) %>%
  group_by(PID) %>%
  arrange(PID, Seconds) %>%  # Sort by PID and Seconds
  mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
  mutate(ButtonPress = if_else(Change == -5, 1, 0),  # Identify button presses
         Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
  group_by(Interval) %>%  # Group by Interval only
  summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav$TotalButtonPresses <- scale(df_behav$TotalButtonPresses) %>% as.numeric()
df_behav$Interval <- df_behav$Interval + 60
df_behav$Dur <- 2
df_behav <- subset(df_behav,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run2_paramod-Group_contrast-Index_vols-729.txt"), 
            sep = "\t", col.names = F, row.names = F)
df_behav$Interval <- df_behav$Interval + 30
write.table(df_behav, paste0(here(), "/../data/deriv/pipeline_1/fmriprep/group_onsets/task-Run2_paramod-Group_contrast-Index_vols-759.txt"), 
            sep = "\t", col.names = F, row.names = F)

