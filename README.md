# Health Insurance Pricing Engine (Gamma GLM)

An end-to-end actuarial pricing pipeline modeling medical claim severity and structuring commercial insurance tariffs.

## Project Overview
- **Data & Objective:** Modeled individual health claim costs using demographic and lifestyle rating factors.
- **Model Choice:** Built a **Gamma Generalized Linear Model (GLM)** with a **log-link** function to account for non-negative, right-skewed medical claims.
- **Interaction Effects:** Integrated a `bmi * smoker` interaction term, reducing model AIC by ~70 points and capturing non-linear risk compounding.
- **Diagnostics:** Analyzed deviance residuals to assess model stability across low-risk routine care vs. acute medical shock claims.
- **Commercial Pricing:** Converted pure risk predictions into market premiums using fixed operational overhead ($150), variable distribution expenses (15%), and target profit margin (5%).
- **Deployment:** Exported multiplicative rating relativities for Excel-based rating engine integration.

## Repository Structure
- `pricing_model.R` - Full R script for data cleaning, GLM fitting, AIC comparison, and diagnostics.
- `glm_rating_factors.csv` - Exported multiplicative tariff factors.
- `insurance.csv` - Medical claims dataset.
