-- Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).
 
with transactions as (
	select 
		distinct pp.id as plan_id,
        pp.owner_id,
		case 
			when pp.is_fixed_investment = 1 then 'Investment'
			when pp.is_regular_savings = 1 then 'Savings'
			end as type,
        max(date(sa.transaction_date)) as last_transaction_date,
		datediff(curdate(), date(sa.transaction_date)) as inactivity_days
	from plans_plan pp
	join savings_savingsaccount sa
		on pp.id = sa.plan_id
	where 
		pp.is_regular_savings = 1
		AND sa.transaction_date IS NOT NULL
	group by 1,2,3,5)
    
    select 
		*
	from transactions t
    where inactivity_days <= 365
    order by 5;
    
    