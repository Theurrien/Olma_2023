#The code here is to estimate the T-size RMSEA and T-size CFI;
#as described in the article
#"Confirm Structural Equation Models by Equivalence Testing with Adjusted Fit Indices"
#by Yuan, Chan, Marcoulides and Bentler;

#-----------Part 1: This part is a function for estimating the noncentrality-----------#;
#------------------------do not change anything of this function-----------------------#;
#The formula is from Venables 1975 for obtaining the noncentrality 
#of a non-central chi-square distribution;
#The inputs are significance level (alpha), observed statistic T_ml, and degrees of freedom (df);
ncp_chi2=function(alpha, T_ml,df){
  z=qnorm(1-alpha);
  z2=z*z; z3=z2*z; z4=z3*z; z5=z4*z;
  sig2=2*(2*T_ml-df+2);
  sig=sqrt(sig2); sig3=sig*sig2; sig4=sig2*sig2;sig5=sig4*sig;
  sig6=sig2*sig4;
  
  delta=T_ml-df+2+sig*
    (
      z+(z2-1)/sig-z/sig2 + 2*(df-1)*(z2-1)/(3*sig3)
      +( -(df-1)*(4*z3-z)/6+(df-2)*z/2 )/sig4
      +4*(df-1)*(3*z4+2*z2-11)/(15*sig5)
      +(
        -(df-1)*(96*z5+164*z3-767*z)/90-4*(df-1)*(df-2)*(2*z3-5*z)/9
        +(df-2)*z/2
      )/sig6
    );
  delta=max(delta,0);
  return(delta)
}
#--------------------------------------------------------------------------------------#;
#-------------------Part 2: Input and Calculating RMSEA_t and CFI_t--------------------#;
#needed inputs are the observed statistic T_ml, its degrees of freedom (df), sample size (N);
#for estimating T-size CFI, additional inputs are the observed statistic 
#at the independence model T_mli, and the number of observed variables (p);

#------------------------Input-----------------------#;
N=554; p=24;
T_ml= 457.234; df=227;
T_mli= 6213.278; 
alpha=.05;
df_i=p*(p+1)/2-p;

#------------------For T-size RMSEA------------------#;
delta_c=max(0,T_ml-df);
RMSEA_c=sqrt(delta_c/((N-1)*df));

delta_t=ncp_chi2(alpha, T_ml,df);
RMSEA_t=sqrt(delta_t/(df*(N-1)));

cat("Conventional RMSEA =", RMSEA_c, "\n");
cat("T-size RMSEA in equivalence testing =", RMSEA_t, "\n");

#------------------For T-size CFI------------------#;
delta_i=T_mli-df_i;
CFI_c=1-delta_c/max(delta_c,delta_i,0);

delta_t=ncp_chi2(alpha/2, T_ml,df);
delta_it=ncp_chi2(1-alpha/2, T_mli,df_i);
CFI_t=1-max(delta_t,0)/max(delta_t,delta_it,0);

cat("Conventional CFI =", CFI_c, "\n");
cat("T-size CFI in equivalence testing =", CFI_t, "\n");

#------------------CFI Cut-Off------------------#;
#Ich gahe davon aus, dass die Werte df, N, p oben schon definiert wurden
#The code is to evaluate the cutoff values CFI_e in equivalence testing
#corresponding to the conventional cutoff values of CFI=.99, .95, .92, and .90, respectively;
#as described in the article
#"Confirm Structural Equation Models by Equivalence Testing with Adjusted Fit Indices"
#by Yuan, Chan, Marcoulides and Bentler;

#needed inputs are degrees of freedom (df), sample size (N), and number of observed variables (p);

df=23; N=145; p=9; 
n=N-1; df_i=p*(p-1)/2;

CFI_e99=1-exp(
  4.67603-.50827*log(df)+.87087*(df^(1/5))-.59613*((df_i)^(1/5))-1.89602*log(n)
  + .10190*((log(n))^2)+ .03729*log(df)*log(n)
);
#corresponding to R-square=.9836;

CFI_e95=1-exp(
  4.12132-.46285*log(df)+.52478*(df^(1/5))-.31832*((df_i)^(1/5))-1.74422*log(n)
  +.13042*((log(n))^2)-.02360*(n^(1/2))+.04215*log(df)*log(n)
);
#corresponding to R-square=.9748;

CFI_e92=1-exp(
  6.31234-.41762*log(df)+.01554*((log(df))^2)-.00563*((log(df_i))^2)-1.30229*log(n)
  +.19999*((log(n))^2)-2.17429*(n^(1/5))+.05342*log(df)*log(n)-.01520*log(df_i)*log(n)
);
#corresponding to R-square=.9724;


CFI_e90=1-exp(
  5.96633-.40425*log(df)+.01384*((log(df))^2)-.00411*((log(df_i))^2)-1.20242*log(n)
  +.18763*((log(n))^2)-2.06704*(n^(1/5))+.05245*log(df)*log(n)-.01533*log(df_i)*log(n)
);
#corresponding to R-square=.9713;

cutoff=cbind(CFI_e90, CFI_e92, CFI_e95, CFI_e99);

cutoff_3=round(cutoff,3);
print(cutoff);

cat('--poor--', cutoff_3[1], '--mediocre--', cutoff_3[2], '--fair--', cutoff_3[3], '--close--', cutoff_3[4], '--excellent--',"\n")

#------------------RMSEA Cut-Off------------------#;

#The code is to evaluate the cutoff values RMSEA_e in equivalence testing
#corresponding to the conventional cutoff values of RMSEA=.01, .05, .08, and .10, respectively;
#as described in the article
#"Confirm Structural Equation Models by Equivalence Testing with Adjusted Fit Indices"
#by Yuan, Chan, Marcoulides and Bentler;

#needed inputs are degrees of freedom (df) and sample size (N);

df=23; N=145; n=N-1;

RMSEA_e01=exp(
  1.34863-.51999*log(df)+.01925*log(df)*log(df)-.59811*log(n)+.00902*sqrt(n)+.01796*log(df)*log(n)
);
#corresponding to R-square=.9997;

RMSEA_e05=exp(
  2.06034-.62974*log(df)+.02512*log(df)*log(df)-.98388*log(n)
  +.05442*log(n)*log(n)-.00005188*n+.05260*log(df)*log(n)
);
#corresponding to R-square=.9996;

RMSEA_e08=exp(
  2.84129-.54809*log(df)+.02296*log(df)*log(df)-.76005*log(n)
  +.10229*log(n)*log(n)-1.11167*(n^.2)+.04845*log(df)*log(n)
);
#corresponding to R-square=.9977;

RMSEA_e10=exp(
  2.36352-.49440*log(df)+.02131*log(df)*log(df)-.64445*log(n)
  +.09043*log(n)*log(n)-1.01634*(n^.2)+.04422*log(df)*log(n)
);
#corresponding to R-square=.9955;

cutoff=cbind(RMSEA_e01, RMSEA_e05, RMSEA_e08, RMSEA_e10);
cutoff_3=round(cutoff,3);
print(cutoff);

cat('--excellent--', cutoff_3[1], '--close--', cutoff_3[2], '--fair--', cutoff_3[3], '--mediocre--', cutoff_3[4], '--poor--',"\n")


#----------Mögliche Funktion für CFI ---------------
calculate_cutoff <- function(df, N, p) {
  
  n <- N - 1
  df_i <- p * (p - 1) / 2
  
  CFI_e99 <- 1 - exp(
    4.67603 - .50827 * log(df) + .87087 * (df^(1/5)) - .59613 * ((df_i)^(1/5)) - 1.89602 * log(n)
    + .10190 * ((log(n))^2) + .03729 * log(df) * log(n)
  )
  
  CFI_e95 <- 1 - exp(
    4.12132 - .46285 * log(df) + .52478 * (df^(1/5)) - .31832 * ((df_i)^(1/5)) - 1.74422 * log(n)
    + .13042 * ((log(n))^2) - .02360 * (n^(1/2)) + .04215 * log(df) * log(n)
  )
  
  CFI_e92 <- 1 - exp(
    6.31234 - .41762 * log(df) + .01554 * ((log(df))^2) - .00563 * ((log(df_i))^2) - 1.30229 * log(n)
    + .19999 * ((log(n))^2) - 2.17429 * (n^(1/5)) + .05342 * log(df) * log(n) - .01520 * log(df_i) * log(n)
  )
  
  CFI_e90 <- 1 - exp(
    5.96633 - .40425 * log(df) + .01384 * ((log(df))^2) - .00411 * ((log(df_i))^2) - 1.20242 * log(n)
    + .18763 * ((log(n))^2) - 2.06704 * (n^(1/5)) + .05245 * log(df) * log(n) - .01533 * log(df_i) * log(n)
  )
  
  RMSEA_e01=exp(
    1.34863-.51999*log(df)+.01925*log(df)*log(df)-.59811*log(n)+.00902*sqrt(n)+.01796*log(df)*log(n)
  );
  #corresponding to R-square=.9997;
  
  RMSEA_e05=exp(
    2.06034-.62974*log(df)+.02512*log(df)*log(df)-.98388*log(n)
    +.05442*log(n)*log(n)-.00005188*n+.05260*log(df)*log(n)
  );
  #corresponding to R-square=.9996;
  
  RMSEA_e08=exp(
    2.84129-.54809*log(df)+.02296*log(df)*log(df)-.76005*log(n)
    +.10229*log(n)*log(n)-1.11167*(n^.2)+.04845*log(df)*log(n)
  );
  #corresponding to R-square=.9977;
  
  RMSEA_e10=exp(
    2.36352-.49440*log(df)+.02131*log(df)*log(df)-.64445*log(n)
    +.09043*log(n)*log(n)-1.01634*(n^.2)+.04422*log(df)*log(n)
  );
  #corresponding to R-square=.9955;
  
  
  cutoff_CFI <- as.vector(rbind(CFI_e90, CFI_e92, CFI_e95, CFI_e99))
  cutoff_RMSEA=as.vector(rbind(RMSEA_e10, RMSEA_e08, RMSEA_e05, RMSEA_e01))
  
  # Creating the data frame
  cutoff_df <- data.frame(CFI = cutoff_CFI, RMSEA = cutoff_RMSEA)
  rownames(cutoff_df) <- c("mediocre", "fair", "close", "excellent")
  
  cutoff_3 <- round(cutoff, 3)
  return(cutoff_df)
}
#------------------Funktion für die Test-Werte-------
equivalence_testing <- function(N, p, T_ml, df, T_mli, alpha) {
  
  # Calculate df_i
  df_i = p * (p + 1) / 2 - p
  
  # For T-size RMSEA
  delta_c = max(0, T_ml - df)
  RMSEA_c = sqrt(delta_c / ((N - 1) * df))
  
  delta_t = ncp_chi2(alpha, T_ml, df)
  RMSEA_t = sqrt(delta_t / (df * (N - 1)))
  
  # For T-size CFI
  delta_i = T_mli - df_i
  CFI_c = 1 - delta_c / max(delta_c, delta_i, 0)
  
  delta_t = ncp_chi2(alpha / 2, T_ml, df)
  delta_it = ncp_chi2(1 - alpha / 2, T_mli, df_i)
  CFI_t = 1 - max(delta_t, 0) / max(delta_t, delta_it, 0)
  
  # Creating the data frame with results
  result_df <- data.frame(
    Method = c("Conventional", "T-Size"),
    CFI = c(CFI_c, CFI_t),
    RMSEA = c(RMSEA_c, RMSEA_t)
  )
  
  return(result_df)
}

