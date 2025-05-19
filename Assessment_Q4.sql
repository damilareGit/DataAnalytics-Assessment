with total_trx as -- Total Transactions
	(
	select 
		distinct sa.owner_id as user_id,
		count(*) as total_transactions
	from savings_savingsaccount sa
	group by 1
    order by 2 desc),

customer_value as (
	select
		savings_id as id, owner_id as user,
        confirmed_amount/100 as inflow,
        confirmed_amount/100 * 0.001 as profit_per_tx
	from savings_savingsaccount sa
    where transaction_status = 'success'),
    
full_table as (
select 
	u.id as user_id, 
	trim(concat(first_name,' ',last_name)) as name,
	round(datediff(curdate(), date(date_joined)) / 30) as tenure_months,
	t.total_transactions       
from users_customuser u
join total_trx t
	on u.id = t.user_id
join savings_savingsaccount sa
	on u.id = sa.owner_id
group by 1,2,3,4
order by 4 desc)

select 
	f.user_id as customer_id, f.name, 
	f.tenure_months, f.total_transactions,
	round((total_transactions/tenure_months) * 12 * avg(cv.profit_per_tx), 2) as estimated_clv
from full_table f
join customer_value cv
	on f.user_id = cv.user
group by 1,2,3,4
order by 5 desc;
        
