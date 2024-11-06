library(tidyverse)
library(reshape2)

rating <- "C:/Users/wjpmi/Documents/GitHub/Social_Regulation/3_Data/conditions.csv" %>%
  read.csv() %>% 
  .[,1:2]

qualtrics <- "C:/Users/wjpmi/Documents/GitHub/Social_Regulation/3_Data/Qualtrics/df_qualtrics.csv" %>%
  read.csv(row.names = 1) %>%
  select("PID", starts_with("Theory"), starts_with("ChrAssess_")) %>%
  na.omit() %>%
  merge(x = rating,
        y = .,
        by.x = "Subject",
        by.y = "PID")

df <- qualtrics %>%
  pivot_longer(cols = starts_with("ChrAssess_"),
               names_to = "Category",
               values_to = "Assessment") %>%
  mutate(Character = str_extract(string = Category, "(?<=ChrAssess_)[^_]+"),
         Category = str_extract(string = Category, "[^_]+$"))

traits <- df$Category %>% unique()
characters <- df$Character %>% unique()

for (TRAIT in traits){
  print(t.test(x = df$Assessment[df$Condition == "A" & df$Category == TRAIT],
         y = df$Assessment[df$Condition == "B" & df$Category == TRAIT]))
}

for (CHARACTER in characters){
  print(t.test(x = df$Assessment[df$Condition == "A" & df$Character == CHARACTER],
               y = df$Assessment[df$Condition == "B" & df$Character == CHARACTER]))
}


# Transform to wide format
df_wide <- df %>%
  select(Subject, Assessment, Category, Character) %>%
  pivot_wider(names_from = Subject, values_from = Assessment)


df_rsa <- df_wide %>%
  
  # Step 1: Select only the Assessment columns
  select(starts_with("SR-")) %>%

  # Step 2: Calculate pairwise correlations across all Assessment columns
  cor(use = "complete.obs") %>%
  
  # Step 3: Remove the upper triangle by setting it to NA
  { .[upper.tri(., diag = TRUE)] <- NA; . } %>%

  # Step 4: Melt the matrix for ggplot
  melt(na.rm = TRUE) %>%
  
  # Step 5: Add condition columns by joining with rating data
  left_join(rating, by = c("Var1" = "Subject")) %>%
  rename(Condition_Var1 = Condition) %>%
  left_join(rating, by = c("Var2" = "Subject")) %>%
  rename(Condition_Var2 = Condition) %>%
  
  # Step 6: Add a column indicating if the conditions match or not
  mutate(Condition_Match = ifelse(Condition_Var1 == Condition_Var2, "Match", "Do Not Match"))

  
# Calculating if there's a difference by condition in a t-test
print(t.test(x = df_rsa$value[df_rsa$Condition_Match == "Match"],
             y = df_rsa$value[df_rsa$Condition_Match == "Do Not Match"]))
  
  # for reproducibility
  set.seed(123) 
  
  # Assuming `similarity_matrix` is your dataframe with same/different condition categorization
  observed_diff <- df_rsa %>%
    group_by(Condition_Match) %>%
    summarize(mean_correlation = mean(value)) %>%
    spread(Condition_Match, mean_correlation) %>%
    summarize(diff = `Match` - `Do Not Match`) %>%
    pull(diff)
  
  # Initialize parameters
  n_permutations <- 5000
  permuted_diffs <- numeric(n_permutations)
  
  # Permutation loop
  for (i in 1:n_permutations) {
    
    # Randomly shuffle condition labels
    shuffled_conditions <- sample(df_rsa$Condition_Match)
    
    # Calculate mean difference for shuffled data
    permuted_diff <- df_rsa %>%
      mutate(Shuffled_Condition = shuffled_conditions) %>%
      group_by(Shuffled_Condition) %>%
      summarize(mean_correlation = mean(value)) %>%
      spread(Shuffled_Condition, mean_correlation) %>%
      summarize(diff = `Match` - `Do Not Match`) %>%
      pull(diff)
    
    # Store the permuted difference
    permuted_diffs[i] <- permuted_diff
  }
  
  # Calculate p-value
  p_value <- mean(abs(permuted_diffs) >= abs(observed_diff))
  
  # Display results
  cat("Observed Difference:", observed_diff, "\n")
  cat("p-value:", p_value, "\n")

