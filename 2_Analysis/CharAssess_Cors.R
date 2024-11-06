# Dependencies
pacman::p_load(corrplot,
               here,
               tidyverse)

# Setting Working Directory
dir_Work <- here::here()

# Reading in the Qualtrics data
df <- read.csv(paste0(dir_Work, 
                      "/GitHub/Neuro_Uncertainty/3_Data/Qualtrics/df_qualtrics.csv"),
               row.names = 1)

# Selecting data to keep
df <- df[, grep("PID|TheoryEnd|^ChrAssess", names(df))] %>%
      na.omit()

# Removing responses from pilot participants, which are formatted as SR-999*
df <- df[-which(str_detect(string = df$PID, pattern = "SR-999.")),]

# Remove the prefix from each column
names(df) <- sub("ChrAssess_", "", names(df))

# Transpose the dataframe
df <- t(df)

# Setting PID as column names
colnames(df) <- as.character(paste0(df[1,], "_", df[2,]))

# Remove the first row
df <- df[-(1:2), ] %>%
      as.data.frame()

# Convert list columns to character
df <- data.frame(lapply(df, 
                        function(x) if(is.list(x)) unlist(x) else x))

# Convert all columns to numeric
df <- data.frame(lapply(df, 
                        as.numeric))

# Defining the characters that participants rated
Characters <- c("Grace", "Jonathan", "Franklin", "Fernando")

# Iterating through the index of each of those characters
for (CHARACTER in 1:length(Characters)){
    
  # Generating correlation matrix
  df_cor <- df[(1 + ((CHARACTER - 1) * 12)):(12 + ((CHARACTER - 1) * 12)),] %>% 
            cor(use = "complete.obs")
  
  # Printing the median value of the matrix
  print(paste("Character:", Characters[CHARACTER], 
              " | MEDIAN:", median(df_cor),
              " | SD:", sd(df_cor)))
  
  # Define a reversed blue-red color palette
  col_rev <- rev(colorRampPalette(c("red", "black", "blue"))(200))
  
  # Export the visualization
  pdf(paste0(dir_Work,
             "/GitHub/Neuro_Uncertainty/4_Plots/Plot-CorMat_Analysis-CharacterCorrs_Character-", 
             Characters[CHARACTER],".pdf"),
      width = 12, 
      height = 12)
  
  # Visualize the correlation matrix
  corrplot(df_cor, 
           method = "color", 
           type = "full", order = "FPC",
           tl.col = "black", 
           tl.srt = 45,
           col = col_rev, 
           addCoef.col = "white", number.cex = 0.65)
  
  dev.off()
}

# Generating
df_cor <- df %>% 
    cor(use = "complete.obs")

# Export the visualization
pdf(paste0(dir_Work,
           "/GitHub/Neuro_Uncertainty/4_Plots/Plot-CorMat_Analysis-CharacterCorrs_Character-All.pdf"),
    width = 12, 
    height = 12)

# Visualize the correlation matrix
corrplot(df_cor, 
         method = "color", 
         type = "full", order = "FPC",
         tl.col = "black", 
         tl.srt = 45,
         col = col_rev, 
         addCoef.col = "white", number.cex = 0.65)

dev.off()
