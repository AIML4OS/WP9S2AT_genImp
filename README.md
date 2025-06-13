## Imputation Methods for Missing Values

In this project we focus on generic imputation methods that can be used for a variety of use-cases.
The package VIM (https://github.com/statistikat/VIM), which is also on CRAN, already provides different, more traditional impuation methods, e.g. kNN, hotdeck, random forest.  

### XGboost and Transformer Imputation
We are currently working on extending the imputation function, implementing an XGBoost imputation as well as a transformer-based imputation. The xgboostImpute() function is already included in the master branch, but not yet included in the CRAN package version.
As we are still in the development phase of the transformer imputation, we created a separate branch: transformerImpute.
The idea of the transformer imputation is that the input data, which is tabular, is treated as strings. By transforming each row into one string, we train the model to predict the next token, which can be a category, in case of imputation of categorical variables, or a digit, in the case of the variable to impute being numeric.

### Function vimpute
Other features we are working on are contained in the pmm_it_all branch of the VIM repository. This branch introduces the vimpute function. With this function, any imputation method implemented in VIM can be selected. 
We switch the training of the imputation models to mlr3 (https://mlr3.mlr-org.com/). The methods included are: ranger (random forest), xgboost, regularized, and robust.
It is also possible to use predictive mean matching (pmm) for the imputation process. Further, there is a possibility to impute the variables sequentially. 
Another feature is the hyperparameter tuning: here the mlr3 framework is used to tune the models. Hyperparameter tuning can be turned off, in that case the default values will be used. 
