# function to calculate confidence intervals, effect size, and NHST and Bayes t-test and Wilcoxon test
# based on code by Frederick Verbruggen (frederick.verbruggen@ugent.be)
# modified by Zhang Chen (zhang.chen@ugent.be)

TES <- function (x,y, paired = TRUE, conf = 0.95){
  library(BayesFactor)
  
  # calculate the means and standard deviations of x and y
  mean_x <- mean(x, na.rm = T)
  sd_x   <- sd(x, na.rm = T)
  mean_y <- mean(y, na.rm = T)
  sd_y   <- sd(y, na.rm = T)
  
  # within-subjects (paired) or between-subjects comparison
  if (paired == TRUE){
    test <- t.test(x, y, paired=TRUE, conf.level = conf) # Do a t-test
    BF.test <- ttestBF(x, y, paired=TRUE) # Bayes equivalent of a t-test
    wilcox.test <- wilcox.test(x, y, paired = TRUE) # do a wilcoxon test
    
    # effect size
    diff = test$estimate[[1]]
    dav <- abs((mean(x) - mean(y)) / ((sd(x)+sd(y))/2)) # Calculate dav
    gav <- dav*(1-(3/(4*(length(x)*2)-9))) # Corresponding Hedges g
    dz <- abs(test$statistic[[1]]/sqrt(length(x))) # Calculate dz  
    ES <- data.frame(dav = dav, gav = gav, dz = dz)
  }else{
    test <- t.test(x, y, paired=FALSE, var.equal = FALSE, conf.level = conf) # Do a t-test
    BF.test <- ttestBF(x, y, paired=FALSE) # Bayes equivalent of a t-test
    wilcox.test <- wilcox.test(x, y, paired = FALSE) # do a wilcoxon test
    
    # effect size
    diff = test$estimate[[1]]-test$estimate[[2]] # numerical difference
    d <- abs(test$statistic[[1]]*sqrt(1/length(x)+1/length(y))) # Calculate d
    g <- d*(1-(3/(4*(length(x)+length(y))-9))) # Corresponding Hedges g
    ES <- data.frame(d = d, g = g)
  }
  
  # combine all necessary values into one vector
  descriptive <- data.frame(mean_x = mean_x, sd_x = sd_x, mean_y = mean_y, sd_y = sd_y)
  diff_CI <- data.frame(diff = diff, lowerCI = test$conf.int[[1]], upperCI = test$conf.int[[2]])
  NHST <- data.frame(df=test$parameter[[1]], t=test$statistic[[1]], pt=test$p.value[[1]], pw = wilcox.test$p.value)
  BF <- data.frame(logBF = BF.test@bayesFactor[['bf']], BF = exp(BF.test@bayesFactor[['bf']]))
  
  output <- cbind(descriptive, diff_CI, NHST, BF, ES)
  
  return(output)
}
