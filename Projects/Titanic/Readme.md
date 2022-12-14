## Titanic Machine Learning From Disaster
### Soledad Galli
#### 11 February 2016


This folder contains exploratory data analysis and machine learning algorithms that predict survival of passengers on the titanic.


Dataset is publicly available. In particular, this version was downloaded from the [Kaggle competition website](https://www.kaggle.com/c/titanic).


The jupyter notebooks contain the following:

- **Titanic_1_ExploratoryAnalysis:** general exploration about the passengers on the titanic.
- **Titanic_2_FactorsInfluencingSurvival:** exploration about the association of the different features of the dataset (age, gender, ticket price, etc) and the likelihood of the person surviving the tragedy.
- **Titanic_PreProcessing_2:** preprocessing of the dataset for model building, including feature extraction, elimination of NaN etc.
- **Titanic_PreProcessing_FullFeatExtraction:** extraction of additional features from existing ones. The idea behind is to try to capture trends and insights that could be helpful for the learning algorithms.
- **Titanic_predictions:** general model building without deep adjustment of the parameters to get an idea of which model would work best for this dataset
- **Titanic_LogisticRegression:** Logistic regression model building and optimisation.
- **Titanic_LogisticRegression_fullFeatures:** new regression models utilising more features extracted for fullFeatExtraction PreProcessing notebook.
- **Titanic_Regularised_LogisticRegression:** optimisation parameters and final model of a regularised logistic regression.
- **Titanic_RandomForest:** Random Forest trees and optimisation. At the moment is the model that scored higher for me in the Kaggle competition.
