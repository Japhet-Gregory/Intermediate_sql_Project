# Intermediate SQL - Contoso Customer Analysis

## Overview

> Analysis of customer value, retention and buying behavior for Contoso, a consumer electronics retailer, to help the marketing manager decide where to focus customer campaigns.

## Business Questions

1. **Customer Segmentation:** Who are our most valuable customers, and how concentrated is revenue?
2. **Cohort Analysis:** Do customers keep buying after their first purchase, and does it depend on when they joined?
3. **Product Preferences:** What do our best customers buy that other customers don't?

## Analysis Approach

### 1. Customer Segmentation Analysis

- Categorized customers by total lifetime spend (`SUM(quantity * netprice)`)
- Assigned customers to High (top 25%), Mid (middle 50%) and Low (bottom 25%) segments using percentiles
- Calculated key metrics: customers, revenue and share of revenue per segment and per quintile

🖥 **Query:** [`1_Who matters most.sql`](Scripts/1_Who%20matters%20most.sql)

📈 **Visualization:** horizontal bar chart of revenue share by customer quintile ([`1_Who matters most.png`](images/1_Who%20matters%20most.png))

![Who Matters Most?](images/1_Who%20matters%20most.png)

📊 **Key Findings:**

*Shown in the chart (quintiles, each 20% of customers):*
- Top 20% of customers: 57.9% of revenue
- 20-40%: 23.3%, 40-60%: 12.1%, 60-80%: 5.5%
- Bottom 20%: 1.3%
- The top 40% together bring 81.1% of revenue

*From the query results (High / Mid / Low segments, not shown in the chart):*
- High (top 25%, 12,372 customers): 65% of revenue (132.8M)
- Mid (middle 50%, 24,743 customers): 33% of revenue (66.5M)
- Low (bottom 25%, 12,372 customers): 2% of revenue (4.4M)

💡 **Business Insights:**
- Revenue follows a "40/80" pattern (top 40% of customers, 81.1% of revenue), more concentrated than the classic 80/20 rule
- Each step down the chart roughly halves the revenue share (57.9% → 23.3% → 12.1% → 5.5% → 1.3%), so value drops fast as you move down the ranking
- Since each quintile has the same number of customers, a top-20% customer is worth about 45 times a bottom-20% customer (57.9% vs 1.3%), so losing one top customer costs far more than losing many small ones

### 2. Cohort Analysis

- Grouped customers into cohorts by the year of their first purchase
- Tracked the share of each cohort that bought again in each later calendar year (retention %, shown as "% of cohort active")
- Compared all cohorts over the same calendar years, to remove timing effects

🖥 **Query:** [`2_Do customers keep buying.sql`](Scripts/2_Do%20customers%20keep%20buying.sql)

📈 **Visualization:** cohort heatmap, cohort by calendar year ([`2_Do customers keep buying.png`](images/2_Do%20customers%20keep%20buying.png))

![Do Customers Stay?](images/2_Do%20customers%20keep%20buying.png)

📊 **Key Findings:**
- Read down any column and the cohorts look alike. In 2022 every cohort sits between 21.2% and 23.2%, and in 2023 between 16.9% and 19.6%
- Read across any row and the percentage changes with the calendar year. The all-cohort average by year is 4.5% (2016), 5.2% (2017), 11.7% (2018), 13.9% (2019), 6.3% (2020), 10.8% (2021), 22.3% (2022) and 18.4% (2023)
- Retention in the year right after the first purchase follows the same pattern: 4.5% for the 2015 cohort (in 2016), 11.6% for 2017 (in 2018), 22.5% for 2021 (in 2022) and 19.6% for 2022 (in 2023)
- Older cohorts do not fade: the 2015 cohort is 21.2% active in 2022, close to the 2021 cohort at 22.5%
- At no point does more than about 23% of any cohort buy in a given year

💡 **Business Insights:**
- Calendar year drives retention, not join year, so targeting by join year adds little
- Only about 1 in 5 customers at best (and about 1 in 20 in the weakest years) buys in any given year, so most customers are inactive in most years
- A new customer is no more or less likely to return than an older one in the same year, so the problem is not specific to the first year, it affects every cohort
- Something business-wide made 2016-2017 and 2020 weak and 2022 strong (22.3%), with 2023 easing back to 18.4%, and the data cannot say what

### 3. Product Preference Analysis

- Built a CASE pivot of revenue by product category and customer segment
- Converted revenue to each category's share of its segment's spend, so segments of different sizes compare fairly
- Calculated the gap between High and Low shares, in percentage points

🖥 **Query:** [`3_What do the best customer buy.sql`](Scripts/3_What%20do%20the%20best%20customer%20buy.sql)

📈 **Visualization:** horizontal bar chart of the High minus Low gap by category ([`3_What do the best customer buy.png`](images/3_What%20do%20the%20best%20customer%20buy.png))

![What Do the Best Customers Buy?](images/3_What%20do%20the%20best%20customer%20buy.png)

📊 **Key Findings:**
- High customers lean toward four categories: Computers (+30.0 points; 49.6% of High spend vs 19.6% of Low), Home Appliances (+4.6), TV and Video (+2.2) and Cameras and camcorders (+2.1)
- Low customers lean toward four categories: Music, Movies and Audio Books (-13.7), Audio (-10.1), Cell phones (-10.1) and Games and Toys (-5.1)
- The gaps balance out: the four positive gaps add up to about +39 points and the four negative ones to about -39

💡 **Business Insights:**
- Computers is the category that best separates the most valuable customers from the rest, by a wide margin (+30.0 vs +4.6 for the next category)
- Home Appliances, TV and Video, and Cameras are only mild High-customer preferences (+2 to +5 points)
- Cell phones are a bigger share of Low customers' spend, but High customers still spend about 15.6M there. It is a smaller slice of a bigger budget
- Segments are defined by total spend, so expensive categories naturally dominate High

## Strategic Recommendations

1. **Customer Value Optimization** (Customer Segmentation)
   - Put retention effort first on the top two quintiles, which bring 81.1% of revenue
   - Build upgrade paths from the Mid segment toward High
   - Use cheaper categories as entry points that lead Low customers toward higher-value ones

2. **Cohort and Retention Strategy** (Cohort Analysis)
   - Run a repeat-purchase campaign for all customers, not only new ones, since every cohort returns at a similar low rate (at most about 23% per year)
   - Investigate what made 2022 strong and 2016-2017 and 2020 weak, and repeat what worked
   - Don't segment retention campaigns by join year

3. **Product Strategy** (Product Preferences)
   - Build High-customer campaigns around Computers first, as it is the clear differentiator (+30.0 points)
   - Treat Home Appliances (+4.6) as a secondary option, and TV and Video and Cameras (about +2) as minor ones
   - Test small before scaling any campaign

## Technical Details

- **Database:** PostgreSQL 
- **Analysis Tools:** DBeaver, SQL (views, CTEs, CASE pivots, window functions)
- **Visualization:** Excel and Claude


## Limitations

- Spend is lifetime spend, not current activity
- 2024 is a partial year (data ends 2024-04-20) and is excluded from comparisons
- Retention means buying in a given calendar year, so a customer who skips a year counts as inactive, not lost
- The data shows what happened, not why


