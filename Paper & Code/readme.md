# Paper & Reproducible Code

This folder contains the core reproducible analysis code and written paper  for the capstone project:

“Beyond the ‘Forgotten Borough’: Forecasting Staten Island Housing Prices with Machine Learning.”

The materials here support the analytical results, figures and conclusions presented in the final paper and the accompanying Shiny application.

## 📑 Capstone Paper

This PDF contains the final written capstone paper, including:

-  Research motivation and background

-  Methodological framework

-  Model comparison and results

-  Forecast interpretation

-  References and appendices

All figures and tables in the paper are generated directly from the code contained in capstone_data698.Rmd.

## 📘 capstone_data698.Rmd

This RMarkdown file contains the full end-to-end analytical workflow, including:

-  Data ingestion from publicly available and GitHub-hosted datasets

-  Data cleaning and feature engineering

-  Exploratory data analysis (EDA)

-  Model development and comparison (Linear Regression,k-Nearest Neighbors (kNN),
XGBoost)

-  Model evaluation using normalized error metrics

  -   cenario-based forecasting for the 2026–2030 period

-  Generation of tables and figures used in the paper

Running this file from top to bottom reproduces the analytical results discussed in the paper.

## 🌐 RPubs 

A fully rendered, public version of the code is also available on RPubs:

🔗 RPubs Link:
https://rpubs.com/NikoletaEm/1380820

This version allows reviewers to view the analysis, figures and narrative without running the code locally.

## 🔁 Reproducibility Notes

All data sources used in the analysis are either:

-  Read directly from GitHub via raw URLs, or

-  Fully documented within the RMarkdown file

-  Cleaning steps for large datasets (e.g., permits data) are included as commented code for transparency

The workflow is designed to be reproducible without manual intervention
