PermaComp (Multiple comparisons using permanovas)

Description: A function to make multiple comparisons (pairwise comparisons) using permanovas for a single response variable in R.

The function requires the following libraries: dplyr, vegan, rcompanion.

The function provides p-values and adjusted p-values for pairwise comparisons, as well as results in Compact Letter Display (CLD) format.

The function allows you to set the desired significance level (alpha) and the type of adjustment to be made. 
These are set using the arguments Alpha = value, Adj = "option". The options for p-value adjustments are:

•	Dunn (1961) (“bonferroni”)

•	Holm (1979) (“holm”)

•	Hochberg (1988) (“hochberg”)

•	Hommel (1988) (“hommel”)

•	Benjamini & Hochberg (1995) (“BH”)

•	Benjamini & Yekutieli (2001) (“BY”)


By default, these arguments are set as follows: Alpha = 0.05,  Adj = "bonferroni".

References:

•	Benjamini, Y., and Hochberg, Y. (1995). Controlling the false discovery rate: a practical and powerful approach to multiple testing. Journal of the Royal Statistical Society Series B, 57, 289–300. doi: 10.1111/j.2517-6161.1995.tb02031.x. Link.

•	Benjamini, Y., and Yekutieli, D. (2001). The control of the false discovery rate in multiple testing under dependency. Annals of Statistics, 29, 1165–1188. doi: 10.1214/aos/1013699998.

•	Dunn, O. J. (1961). Multiple Comparisons Among Means. Journal of the American Statistical Association. 56 (293): 52–64. CiteSeerX 10.1.1.309.1277. doi:10.1080/01621459.1961.10482090.

•	Hochberg, Y. (1988). A sharper Bonferroni procedure for multiple tests of significance. Biometrika, 75, 800–803. doi: 10.2307/2336325.

•	Holm, S. (1979). A simple sequentially rejective multiple test procedure. Scandinavian Journal of Statistics, 6, 65–70. Link.

•	Hommel, G. (1988). A stagewise rejective multiple test procedure based on a modified Bonferroni test. Biometrika, 75, 383–386. doi: 10.2307/2336190.

