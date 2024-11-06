# Calling our custom function
source("https://github.com/wj-mitchell/neuRotools/blob/main/ConfoundReducer.R?raw=TRUE")

# Calling the tidyverse package
library(tidyverse)

# Setting our working directory
setwd("/data/Uncertainty/scripts/2_Analysis/dir_ActiveVPassive")

# Noting our participant IDs
PIDs <- read.table("00_Participants.txt")[,1] %>%
        sprintf("%04d",.)

# Generating onset files for those participants
ConfoundReducer(PIDs = PIDs,
                check_VIF = FALSE)
