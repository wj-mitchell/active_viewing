# Dependencies
library(tidyverse)

emonet_extract <- function(input, output, TR = 2, duration = 1337){
  
# Reading in emonet results
df <- read.csv(input) %>%
      pivot_wider(names_from = EmotionCategory,
                  values_from = Probability) %>%
      select(-c("FrameID"))

# Copying names
names <- names(df)

# Calculating framerate
framerate <- nrow(df)/duration
frames_per_TR <- framerate * TR

# Calculating the approximate frames which mark the onset of each TR
TR_onsets <- seq(1,nrow(df), frames_per_TR) %>% round ()

# Caculating how many frames are contained within each TR
TR_durations <- TR_onsets %>% diff() %>% c(., nrow(df) - sum(.))

# Function to calculate averages based on TR_durations
calculate_means <- function(data, durations) {
  
  # Create an index tracker to increment
  index_start <- 1
  index_end <- 0
  
  # Creating a new dataframe to store means within
  averaged_data <- data.frame()
  
  # Incrementing through TRs
  for (TR in durations) {
    
    # incrementing our index_tracker
    index_end <- index_end + TR
        
    # Identify the rows we target within this TR
    segment <- data[index_start:index_end, ]
    
    # calculating column averages
    avg_segment <- colMeans(segment, na.rm = TRUE)
    
    # Binding rows to our new dataframe
    averaged_data <- rbind(averaged_data, avg_segment)
    
    # incrementing our index_tracker
    index_start <- index_start + TR
  }
  
  return(as.data.frame(averaged_data))
}

# Calculate the average value of each column for every TR
df <- calculate_means(df, TR_durations)

# Standardize columns
df <- df %>%
      mutate(across(everything(), ~ (. - mean(.)) / sd(.)))

# Change column names
names(df) <- names

# Write the new csv
write.csv(df, output)

}

emonet_extract(input = "/data/Uncertainty/data/emonet/StimVidTestFirstHalf_emonet_raw.csv",
               output = "/data/Uncertainty/data/emonet/StimVidTestFirstHalf_emonet.csv")


emonet_extract(input = "/data/Uncertainty/data/emonet/StimVidTestLastHalf_emonet_raw.csv",
               output = "/data/Uncertainty/data/emonet/StimVidTestLastHalf_emonet.csv")
