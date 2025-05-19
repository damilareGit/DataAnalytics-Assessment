# DataAnalytics-Assessment
CowryWise Data Analyst SQL Assessment

**Assessment _Q1** -  High-Value Customers with Multiple Products
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Approach: I used CTEs for query better performance considering I had to breakdown funded savings and investment plans, then a final query link the counts and total deposits to each user.
Challenges: 2 columns that allude to investments: is_a_fund and is_fixed_investment. I solved it by validating that is_fixed_investment had no users with a funded plan, while is_a_fund had users with funded plans.


**Assessment Q2** - Transaction Frequency Analysis
Task: Calculate the average number of transactions per customer per month and categorize them: "High Frequency" (≥10 transactions/month), "Medium Frequency" (3-9 transactions/month) and
      "Low Frequency" (≤2 transactions/month).
Approach: First step was to extract year & month from the transaction_date so we can account for the amount of transactions done every month across various years, before linking them to users. 
          Then each month's transaction was put in frequency bins/categories as specified.
