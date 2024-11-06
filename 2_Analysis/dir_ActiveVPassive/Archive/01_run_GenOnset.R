## Libraries
pacman::p_load(here, tidyverse)

# Loading the custom cleaning function
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/rucleaner.R", local= T)

# Noting the index number of all .csv files in the directory
dir <- paste0(here(), "/3_Data/Task/")
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
df_behav_FH <- subset(df,
                      df$Video != "StimVidControl.mp4" &
                      df$Video != "StimVidControl_Undoing.mp4" &
                      df$Condition == "A",
                      select = c(PID, CertRate, Seconds)) %>% 
                arrange(PID, Seconds) %>%  # Sort by PID and Seconds
                mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
                mutate(ButtonPress = if_else(abs(Change) == 5, 1, 0),  # Identify button presses
                       Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
                group_by(Interval) %>%  # Group by Interval only
                summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav_FH$TotalButtonPresses <- scale(df_behav_FH$TotalButtonPresses) %>% as.numeric()
df_behav_FH$Interval <- df_behav_FH$Interval + 60
df_behav_FH$Dur <- 2
df_behav_FH <- subset(df_behav_FH,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav_FH, paste0(here(), "/2_Analysis/run-1_vols-729.txt"), sep = "\t", col.names = F, row.names = F)
df_behav_FH$Interval <- df_behav_FH$Interval + 30
write.table(df_behav_FH, paste0(here(), "/2_Analysis/run-1_vols-759.txt"),sep = "\t", col.names = F, row.names = F)

## Creating a dataframe of only second half raters 
df_behav_SH <- subset(df,
                      df$Video != "StimVidControl.mp4" &
                        df$Video != "StimVidControl_Undoing.mp4" &
                        df$Condition == "A",
                      select = c(PID, CertRate, Seconds)) %>% 
  arrange(PID, Seconds) %>%  # Sort by PID and Seconds
  mutate(Change = c(0, diff(CertRate))) %>%  # Calculate changes in CertRate, prepend 0 for the first row
  mutate(ButtonPress = if_else(abs(Change) == 5, 1, 0),  # Identify button presses
         Interval = floor(Seconds / 2) * 2) %>%  # Create 2-second intervals
  group_by(Interval) %>%  # Group by Interval only
  summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')  # Count button presses per interval and drop grouping

df_behav_SH$TotalButtonPresses <- scale(df_behav_SH$TotalButtonPresses) %>% as.numeric()
df_behav_SH$Interval <- df_behav_SH$Interval + 60
df_behav_SH$Dur <- 2
df_behav_SH <- subset(df_behav_SH,select = c("Interval", "Dur", "TotalButtonPresses"))
write.table(df_behav_SH, paste0(here(), "/2_Analysis/run-2_vols-729.txt"), sep = "\t", col.names = F, row.names = F)
df_behav_SH$Interval <- df_behav_SH$Interval + 30
write.table(df_behav_SH, paste0(here(), "/2_Analysis/run-2_vols-759.txt"), sep = "\t", col.names = F, row.names = F)
