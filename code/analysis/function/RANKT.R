# R function for conducting frequentist rank-based tests:
# Wilcoxon rank sum and Wilcoxon signed rank test
# author: Zhang Chen (zjuchenzhang@gmail.com)

library(effectsize)

RANKT <- function(x, y, paired = TRUE, file = NULL, ...){
  
  if(paired){
    
    # if x and y are paired values, conduct Wilcoxon signed rank test
    wilcox_results <- wilcox.test(x, y, paired = TRUE)
    
    # compute the rank biserial correlation as standardized effect size
    rank_biserial_eff <- rank_biserial(x, y, paired = TRUE, iterations = 1000)
    
    # combine all results as a data frame
    results <- data.frame(V = wilcox_results$statistic[[1]],
                          p = wilcox_results$p.value,
                          rank_biserial = rank_biserial_eff$r_rank_biserial,
                          lowerCI = rank_biserial_eff$CI_low,
                          upperCI = rank_biserial_eff$CI_high)
    
  } else {
    
    # if x and y are not paired values, conduct Wilcoxon rank sum test
    wilcox_results <- wilcox.test(x, y, paired = FALSE)
    
    # compute the rank biserial correlation as standardized effect size
    rank_biserial_eff <- rank_biserial(x, y, paired = FALSE, iterations = 1000)
    
    # combine all results as a data frame
    results <- data.frame(W = wilcox_results$statistic[[1]],
                          p = wilcox_results$p.value,
                          rank_biserial = rank_biserial_eff$r_rank_biserial,
                          lowerCI = rank_biserial_eff$CI_low,
                          upperCI = rank_biserial_eff$CI_high)
  }
  
  return(results)
  
}