PermaComp2 <- function(Dat, Y, X, Adj = "bonferroni", Alpha = 0.05){
  
  # Necessary libraries
  suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
  suppressWarnings(suppressPackageStartupMessages(library(vegan)))
  suppressWarnings(suppressPackageStartupMessages(library(rcompanion)))
  
  # Data set manipulation
  Data = as.data.frame(Dat)
  
  # A simpler way to get the variable names from the function arguments
  Response_var_name <- as.character(substitute(Y))
  Factor_var_name <- as.character(substitute(X))
  
  # Rename columns for easier use in the function
  Data$Response <- Data[[Response_var_name]]
  Data$Factor <- as.factor(Data[[Factor_var_name]])
  
  # Only the variables involved are saved
  Data <- transmute(Data, Response = Response, Factor = Factor)
  
  # Necessary objects
  Combinations <- combn(levels(Data$Factor), 2)
  Comparisons <- choose(length(levels(Data$Factor)), 2)
  Table <- as.data.frame(matrix(data=NA, nrow=Comparisons, ncol=2))
  colnames(Table) <- c("Comparison", "P_Value")
  VariationCounter = 0
  
  # Paired permanovas cycle
  for (i in 1:Comparisons) {
    DataComp <- filter(Data,
                       Factor == Combinations[1,i] | Factor == Combinations[2,i])
    DataComp <- na.omit(DataComp)
    
    # Check for variation
    if (max(DataComp$Response) - min(DataComp$Response) == 0) {
      Table$P_Value[i]<- 1
      VariationCounter = VariationCounter + 1
    } else {
      set.seed(73)
      # Use adonis2 and correctly extract the p-value
      # The key change is here:
      Perma <- adonis2(DataComp$Response ~ DataComp$Factor,
                      permutations = 999, method = "euclidean")
      
      # Correct way to get the p-value from adonis2 output
      Pvalor <- Perma$`Pr(>F)`[1]
      Table$P_Value[i] <- Pvalor
    }
    
    Table$Comparison[i]<- paste(Combinations[,i], collapse = "-")
  }
  
  # P-Values are adjusted
  Table$P_Adj<- p.adjust(Table$P_Value, method = Adj)
  
  # Groups are built
  CLD<-cldList(P_Adj ~ Comparison, data = Table, threshold = Alpha)
  
  # Print results
  Message1 <- ("P-Values of the comparisons:")
  cat("\n", Message1, "\n")
  print(Table, row.names = FALSE)
  Message2 <- ("Groups in letter format (CLD):")
  cat("\n", Message2,"\n")
  print(CLD[,1:2], row.names = FALSE)
  
  # Warnings
  if (VariationCounter/Comparisons >= 0.1 & VariationCounter/Comparisons != 1) {
    Message3 <- ("ATTENTION: Your data shows little variation")
    cat("\n",Message3,"\n")
    Percentage <- round(VariationCounter/Comparisons*100, 2)
    cat("The", Percentage, "% of comparisons were made between data without variation.\n")
  }
  if (VariationCounter/Comparisons == 1) {
    Message6 <- ("ATTENTION: Your data does not present variation")
    cat("\n", Message6,"\n")
  }
}
