PermaComp <- function(Dat,Y, X, Adj = "bonferroni", Alpha = 0.05){

  # Necessary libraries
  # (loaded without printing warnings or messagess):
  suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
  suppressWarnings(suppressPackageStartupMessages(library(vegan)))
  suppressWarnings(suppressPackageStartupMessages(library(rcompanion)))

  # Data set manipulation:
  suppressMessages(attach(Dat)) # Loads without printing messages
  Response <- Y
  Factor <- X
  Data = as.data.frame(Dat)
  Data$Response = as.numeric(Y)
  Data$Factor = as.factor(X)

  Data <- transmute(Data,
                     Response = Response,
                     Factor = Factor) # Only the variables involved are saved
  # Necessary objects:
  Combinations <-combn(levels(Data$Factor), 2) # Creates a matrix where the columns are the treatment combinations (factor levels)
  Comparisons <- choose(length(levels(Data$Factor)),2) # Calculate the number of comparisons
  Table <- as.data.frame(matrix(data=NA,nrow=Comparisons,ncol=2)) # Creates the results table
  colnames(Table) <- c("Comparison", "P_Value")
  VariationCounter = 0 # Counter to keep track of the number of comparisons without variation (i.e., all observations have the same value)

  # Paired permanovas cycle:
  for (i in 1:Comparisons) {
    DataComp <-  filter(Data,
                         Factor == Combinations[1,i] | Factor == Combinations[2,i])
    DataComp <- na.omit(DataComp) # Remove NAs

    # It is checked if the comparison presents variation (if does not, 1 is assigned to the P_Value). Otherwise adonis command gives an error
    if (max(DataComp$Response) - min(DataComp$Response) == 0) {
      Table$P_Value[i]<- 1
      VariationCounter = VariationCounter + 1
    } else {
      set.seed(73)
      Perma <- adonis(Response ~ Factor, data = DataComp,
                      permutations = 999, method = "euclidean")
      Pvalor <- as.matrix(Perma$aov.tab[6])
      Table$P_Value[i]<- Pvalor[1,1]}

    Table$Comparison[i]<- paste(Combinations[,i], collapse = "-")
  }

  # P_Values are adjusted:
  Table$P_Adj<- p.adjust(Table$P_Value,method= Adj)

  # Groups are built (compact letter display is used to identify groups):
  CLD<-cldList(P_Adj ~ Comparison, data = Table, threshold  = Alpha)

  # Results are printed:
  Message1 <- ("P_Values of the comparisons:")
  #cat("\n", noquote(Message1), "\n")
  cat("\n", Message1, "\n")
  print(Table,row.names = FALSE)
  Message2 <- ("Groups in letter format (CLD):")
  #cat("\n", noquote(Message2),"\n")
  cat("\n", Message2,"\n")
  print(CLD[,1:2],row.names = FALSE)

  # If more than 10% of the comparisons show no variation, a warning message is printed.
  if (VariationCounter/Comparisons >= 0.1 & VariationCounter/Comparisons != 1) {
    Message3 <- ("ATTENTION: Your data shows little variation")
    cat("\n",Message3,"\n")
    Message4 <- (" The")
    Percentage <- round(VariationCounter/Comparisons*100, 2)
    Message5 <- ("percent of comparisons were made between data without variation")
    cat(Message4, Percentage, Message5)
  }
  # If there is no variation in the data, a warning message is printed.
  if (VariationCounter/Comparisons == 1) {
    Message6 <- ("ATTENTION: Your data does not present variation")
    cat("\n", Message6,"\n")
  }
}
