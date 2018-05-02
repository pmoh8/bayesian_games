

steam <- read.csv(file="steam.csv")
steam <- steam[,-which(names(steam) == "X")]
steam <- steam[,-which(names(steam) == "ID")]
steam <- steam[,-which(names(steam) == "Relevant")]
steam <- steam[,-which(names(steam) == "Name")]
steam <- steam[,-which(names(steam) == "Developer")]
steam <- steam[,-which(names(steam) == "Publisher")]

n = nrow(steam)

set.seed(600)

train = sample(nrow(steam), 0.7*n)

steamTrain = steam[train, ]
steamTest = steam[-train, ]

Xtrain <- steamTrain[,-which(names(steamTrain) == "Players")]
Ytrain <- steamTrain$Players
Xtest <- steamTest[,-which(names(steamTest) == "Players")]
Ytest <- steamTest$Players

xTrain <- dataset.train[,-which(names(steam) == "Players")]
yTrain <- dataset.train$Players
xTest <- dataset.test[,-which(names(steam) == "Players")]
yTest <- dataset.test$Players

###set up parameters
numTrees = 300
num_burn_in = 20



ourForest = bartMachine(xTrain,yTrain, Xy = NULL,
            numTrees, 
            num_burn_in,
            num_iterations_after_burn_in = 1500,
            alpha = 0.95, beta = 3, k = 2, q = 0.9, nu = (nrow(xTrain)-1)*(ncol(xTrain)-1),
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

testForest = bart_predict_for_test_data(ourForest,xTest,yTest)

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

Xtest$HWCPU[is.na(Xtest$HWCPU)] <- median(Xtrain$HWCPU, na.rm=TRUE)
Xtest$HWGPU[is.na(Xtest$HWGPU)] <- median(Xtrain$HWGPU, na.rm=TRUE)
Xtest$HWRAM[is.na(Xtest$HWRAM)] <- median(Xtrain$HWRAM, na.rm=TRUE)
Xtest$HWHDD[is.na(Xtest$HWHDD)] <- median(Xtrain$HWHDD, na.rm=TRUE)
Xtest$HWDx[is.na(Xtest$HWDx)] <- median(Xtrain$HWDx, na.rm=TRUE)

Xtrain$HWCPU[is.na(Xtrain$HWCPU)] <- median(Xtrain$HWCPU, na.rm=TRUE)
Xtrain$HWGPU[is.na(Xtrain$HWGPU)] <- median(Xtrain$HWGPU, na.rm=TRUE)
Xtrain$HWRAM[is.na(Xtrain$HWRAM)] <- median(Xtrain$HWRAM, na.rm=TRUE)
Xtrain$HWHDD[is.na(Xtrain$HWHDD)] <- median(Xtrain$HWHDD, na.rm=TRUE)
Xtrain$HWDx[is.na(Xtrain$HWDx)] <- median(Xtrain$HWDx, na.rm=TRUE)

Xtrain = na.roughfix(Xtrain)
Xtest = na.roughfix(Xtest)

randomForest(xTrain,yTrain,xtest = xTest,ytest=yTest,ntree = 250,
             replace = TRUE, nodesize = 10)

