
treeNums = c(100,50,25,10,5,1)

# Page 24 in the BARTmachine manual
# get_var_props_over_chain : Computes the variable inclusion proportions for a BART model.
# Usage : get_var_props_over_chain(bart_machine, type = "splits")

# Arguments
###  bart_machine: An object of class "bartMachine".
###  type: If "splits", then the proportion of times each variable is chosen for a splitting 
####      rule versus all splitting rules is computed. If "trees", then the proportion of
####      times each variable appears in a tree versus all appearances of variables in trees
####      is computed.

# Page 27 in the BARTmachine manual
# investigate_var_importance : Explore Variable Inclusion Proportions in BART Model
# Usage : investigate_var_importance(bart_machine, type = "splits", plot = TRUE, num_replicates_for_avg = 5, num_trees_bottleneck = 20, num_var_plot = Inf, bottom_margin = 10)
# Arguments
###  bart_machine An object of class "bartMachine".
###  type 
####       If "splits", then the proportion of times each variable is chosen for a splitting
####       rule is computed. If "trees", then the proportion of times each variable appears
####       in a tree is computed.
###  plot 
####       If TRUE, a plot of the variable inclusion proportions is generated.
###  num_replicates_for_avg
####       The number of replicates of BART to be used to generate variable inclusion
####       proportions. Averaging across multiple BART models improves stability of the
####       estimates. See Bleich et al. (2013) for more details.
###  num_trees_bottleneck
####       Number of trees to be used in the sum-of-trees for computing the variable inclusion
####       proportions. A small number of trees should be used to force the variables
####       to compete for entry into the model. Chipman et al. (2010) recommend 20. See
####       this reference for more details.
###  num_var_plot Number of variables to be shown on the plot. If "Inf", all variables are plotted.
###  bottom_margin A display parameter that adjusts the bottom margin of the graph if labels are
####       clipped. The scale of this parameter is the same as set with par(mar = c(....))
####       in R. Higher values allow for more space if the covariate names are long. Note
####       that making this parameter too large will prevent plotting and the plot function
####       in R will throw an error.

for (i in treeNums){
  print(i)
}