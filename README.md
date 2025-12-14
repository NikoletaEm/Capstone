# 🏠 Beyond the “Forgotten Borough”

## Forecasting Staten Island Housing Prices with Machine Learning

Welcome! This repository contains my master’s capstone project, where I use machine learning, spatial analysis, and economic data to forecast housing prices across Staten Island, 
NYC’s most overlooked borough (but not anymore 👀).

If Manhattan gets the headlines and Brooklyn gets the hype, this project asks:
**What’s actually happening in Staten Island’s housing market — and where is it heading next?**

##  What This Project Does

-  Builds and compares three predictive models:

  *  Linear Regression

  *  k-Nearest Neighbors (kNN)

  *  XGBoost (final model)

-  Forecasts housing prices from 2026–2030 under a historically grounded macroeconomic scenario

-  Analyzes how crime, school quality, housing structure and location shape future prices

-  Highlights spatial divergence across neighborhoods and NTAs

-  Turns forecasts into a fully interactive Shiny application

In short: this project goes beyond “prices go up” and shows where, why and how differently prices move across Staten Island.

## 📁 Repository Structure
```
Capstone/
├── DataUsed/
│   └── Cleaned and raw datasets used in the analysis
│
├── Paper & Code/
│   ├── capstone_data698.Rmd     # Fully reproducible analysis
│   ├── capstone_paper.pdf      # Final written paper
│   └── readme.md
│
├── ShinyApplication/
│   ├── app.R
│   ├── combined_nta.rds
│   ├── combined_neighborhood.rds
│   └── schools_mapped.rds
│
└── README.md
```

## 📊 Fully Reproducible Analysis

The Paper & Code folder contains the complete, end-to-end workflow:

-  Data cleaning & feature engineering

-  Exploratory data analysis

-  Model development & evaluation

-  Scenario-based forecasting

-  Figures and tables used in the paper

👉 You can also view the rendered code online (no setup required):

**🔗 RPubs:**
https://rpubs.com/NikoletaEm/1380820

## 🚀 Interactive Shiny App

Because forecasts shouldn’t live only in PDFs.The project includes an interactive R Shiny dashboard where users can:

-  Explore forecasted prices by NTA and neighborhood

-  Compare price trends over time

-  Use a personalized NTA preference quiz (budget, schools, transit, housing age, etc.)

**🔗 Live App:**
https://nicoleemanouilidi.shinyapps.io/finalcapstone/

📌 Note:
To run the app locally, the .rds files in the ShinyApplication/ folder must be downloaded alongside app.R.

## 🧠 Key Takeaways (No Spoilers… Just Enough)

-  Housing prices do not evolve uniformly across Staten Island

-  Structural factors (size, age, units) dominate price formation

-  Crime and school quality matter 

-  Macroeconomic forces act indirectly, but timing still matters

-  The borough shows signs of a two-speed housing market

## Author
  
  Nikoleta Emanouilidi
  
  Master’s Capstone Project – Data Science
  
  Staten Island, NY

**If you’re here as a:**

  📘 Professor → everything is reproducible

  🏡 Homebuyer → try the app

  📊 Data scientist → check out the modeling pipeline

  🏙️ Planner or policymaker → pay attention to the spatial patterns
