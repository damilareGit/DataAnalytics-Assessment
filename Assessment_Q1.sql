-- High-Value Customers with Multiple Products
-- Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
-- Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

with Funded_savings as -- This CTE is to find and count users with a 'funded' savings account. This is vital because from the dataset 1 user can have multiple savings accounts.
	(
    SELECT
      sa.owner_id as owner_id,
      count(distinct savings_id) as savings_count,
      sum(new_balance)/100 as total_savings
    FROM savings_savingsaccount sa
    join plans_plan pp
		on sa.owner_id = pp.owner_id
    WHERE new_balance > 0 -- assuming positive balance means "funded account"
		AND pp.is_regular_savings = 1
    GROUP BY 1),
    
funded_investment as -- This CTE is to find and count users with a 'funded' investment account. This was dicey because we have 2 columns that allude to investments: is_a_fund and is_fixed_investment.
	(
    SELECT
      owner_id,
      count(distinct id) as investment_count,
      sum(amount)/100 as total_investment
    FROM plans_plan
    WHERE is_a_fund = 1
		AND amount > 0
    GROUP BY 1)

SELECT -- This query sums the total users with at least 1 funded savings or investment account and the total deposits.
  u.id as customer_id,
  trim(concat(first_name,' ',last_name)) as customer_name,
  fs.savings_count as savings_count,
  fi.investment_count as investment_count,
  round(fs.total_savings + fi.total_investment,2) as total_deposits
FROM users_customuser u 
JOIN funded_savings fs
	ON u.id = fs.owner_id
JOIN funded_investment fi
	ON u.id = fi.owner_id
ORDER BY total_deposits DESC
limit 100;

	
