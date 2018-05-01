

steam <- read.csv(file="steamwithscore.csv")
steam <- steam[,-which(names(steam) == "X")]
steam <- steam[,-which(names(steam) == "ID")]
steam <- steam[,-which(names(steam) == "Relevant")]
steam <- steam[,-which(names(steam) == "Name")]

n = nrow(steam)

set.seed(600)

train = sample(nrow(steam), 0.7*n)

steamTrain = steam[train, ]
steamTest = steam[-train, ]

Xtrain <- steamTrain[,-which(names(steamTrain) == "Players")]
Ytrain <- steamTrain$Players
Xtest <- steamTest[,-which(names(steamTest) == "Players")]
Ytest <- steamTest$Players


###set up parameters
numTrees = 200
num_burn_in = 250


ourForest = bartMachine(Xtrain,Ytrain, Xy = NULL,
            numTrees, 
            num_burn_in,
            num_iterations_after_burn_in = 1000,
            alpha = 0.95, beta = 2, k = 2, q = 0.9, nu = 3,
            prob_rule_class = 0.5,
            mh_prob_steps = c(2.5, 2.5, 4)/9,
            debug_log = FALSE,
            run_in_sample = TRUE,
            s_sq_y = "mse",
            sig_sq_est = NULL,
            cov_prior_vec = NULL,
            use_missing_data = TRUE,
            covariates_to_permute = NULL,
            num_rand_samps_in_library = 10000,
            use_missing_data_dummies_as_covars = FALSE,
            replace_missing_data_with_x_j_bar = FALSE,
            impute_missingness_with_rf_impute = FALSE,
            impute_missingness_with_x_j_bar_for_lm = TRUE,
            mem_cache_for_speed = TRUE,
            serialize = FALSE,
            seed = NULL,
            verbose = TRUE)

testForest = bart_predict_for_test_data(ourForest,Xtest,Ytest)

ranX <- steam
ranX <- ranX[,-which(names(ranX) == "HWCPU")]
ranX <- ranX[,-which(names(ranX) == "HWGPU")]
ranX <- ranX[,-which(names(ranX) == "HWRAM")]
ranX <- ranX[,-which(names(ranX) == "HWHDD")]
ranX <- ranX[,-which(names(ranX) == "HWDx")]

devCount = count(steam$Developer)
ranX = merge(ranX,devCount,by.x="Developer",by.y="x")
names(ranX)[names(ranX) == 'freq'] <- 'devCount'

pubCount = count(steam$Publisher)
ranX = merge(ranX,pubCount,by.x="Publisher",by.y="x")
names(ranX)[names(ranX) == 'freq'] <- 'pubCount'

write.csv(ranX,file="steam_RF.csv")

X <- ranX[,-which(names(ranX) == "Players")]
X <- X[,-which(names(X) == "Publisher")]
X <- X[,-which(names(X) == "Developer")]
Y <- steam$Players

randomForest(X,Y,xtest = NULL,ytest=NULL,nTree = 1000,
             replace = TRUE, nodesize = 10)

            