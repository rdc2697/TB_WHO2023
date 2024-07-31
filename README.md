# WHO Global Tuberculosis Report 2023

This repository contains the code and data for the 2023 Global Tuberculosis Report by the World Health Organization (WHO). The main focus is on analyzing the trends in new TB cases and building a model to predict TB cases.

## Directory Structure

- `data/`: Contains the raw data files.
- `scripts/`: Contains the analysis scripts.
- `images/`: Contains the visualizations generated from the analysis.
- `README.md`: This file.
  
## Linear Regression Analysis

A linear regression model was built to predict new TB cases (`new.sp`) using various predictors in the dataset.

### Steps Performed

1. **Data Loading:**
   - The data was loaded from the `.rda` file provided in the repository.

2. **Data Cleaning:**
   - Missing values were imputed using the median for numeric columns and the mode for categorical columns.

3. **Feature Selection:**
   - Relevant columns were selected based on non-empty values and variance.

4. **Model Training:**
   - The data was split into training and testing sets.
   - A linear regression model was trained using the `caret` package.

5. **Model Evaluation:**
   - The model was evaluated using RMSE, R-squared, and MAE.
   - Visualizations were created to compare predictions with actual values and to analyze residuals.

### Code

The code for the linear regression analysis can be found in the Linear_Regression_Analysis.R file in the directory. 

## Analysis and Visualization

### Correlation Matrix

![Correlation Matrix](https://github.com/user-attachments/assets/95a1ed23-5cfa-40ee-acfe-0781d8c30d3b)

### New TB Cases per Year

![New TB Cases per Year](https://github.com/user-attachments/assets/bdd32c5d-8cc8-49c8-bc58-ab7086b2d60b)

### Model Evaluation Metrics

- **RMSE**: 6465.52
- **R-squared**: 0.9444
- **MAE**: 614.40

### Predictions vs Actual Values

![Predictions vs Actual Values](https://github.com/user-attachments/assets/8ebcf004-7b75-4eaf-ad8f-bd0a3ac1dae7)

### Residuals Plot

![Residuals Plot](https://github.com/user-attachments/assets/e6bf6a71-93a2-4dac-91f0-d1d98c19fce7)

### Running the Analysis

To run the analysis:

1. Clone the repository:
   ```bash
   git clone https://github.com/rdc2697/TB_WHO2023.git
   cd TB_WHO2023
