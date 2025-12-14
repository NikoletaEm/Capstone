# Staten Island Housing Price Forecast – Shiny Application

This folder contains the R Shiny application developed as part of the capstone project
“Beyond the ‘Forgotten Borough’: Forecasting Staten Island Housing Prices with Machine Learning.”

The application provides an interactive interface for exploring forecasted housing prices across Staten Island at both the Neighborhood Tabulation Area (NTA) and neighborhood levels. Users can view borough-wide forecasts, explore price trends, and interact with a personalized NTA preference quiz.

## File Descriptions

app.R
Main Shiny application file containing the UI and server logic.

combined_nta.rds
Preprocessed and forecasted housing price data at the NTA level.

combined_neighborhood.rds
Aggregated housing price data at the neighborhood level.

schools_mapped.rds
School quality indicators mapped to NTAs and used by the application filters.

## ▶️ How to Run the App Locally

To run the Shiny app locally, all .rds files must be downloaded and placed in the same directory as app.R.

Steps:

1.Download the entire ShinyApplication folder.

2.Ensure the following files are present in the same directory:

app.R

combined_nta.rds

combined_neighborhood.rds

schools_mapped.rds

3.Open app.R in RStudio.

4/Click Run App.

The application reads the .rds files directly from the local folder. If any file is missing or renamed, the app will not launch correctly.

## 🌐 Live Deployed Version

A working deployed version of the Shiny app is available here:

🔗 https://nicoleemanouilidi.shinyapps.io/finalcapstone/

This version is fully functional and does not require local setup.

## 🔁 Reproducibility Notes

The .rds files contain cleaned and feature-engineered datasets used by the final model.

Raw data preprocessing and model training steps are documented elsewhere in the repository.

Including .rds files ensures the Shiny app remains lightweight, fast, and fully reproducible.
