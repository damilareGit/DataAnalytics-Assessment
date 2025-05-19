with transactions_info as (
      select 
		case 
			when avg(monthly_tx_count) >= 10 then 'High Frequency'
			when avg(monthly_tx_count) between 3 and 9 then 'Medium Frequency'
			else 'Low Frequency'
		end as frequency_category,     
		u.id as customer_id,
		concat(u.first_name,' ', u.last_name) as username,
		round(avg(monthly_tx_count),2) as avg_tx_per_month        
	from ( 
		select 
			sa.owner_id as user_id,
			extract(year from transaction_date) as year,
			monthname(transaction_date) as mnth,
			count(*) as monthly_tx_count
		from savings_savingsaccount sa
		group by 1,2,3) as monthly_counts
		join users_customuser as u
			on u.id = monthly_counts.user_id
		group by 2,3
		order by 4 desc)
    
    select 
	frequency_category,
        count(distinct customer_id) as customer_count,
        round(AVG(avg_tx_per_month), 2) as avg_transactions_per_month                
    from transactions_info
    group by 1
    order by 
	CASE frequency_category
		WHEN 'High Frequency'   THEN 1
		WHEN 'Medium Frequency' THEN 2
		WHEN 'Low Frequency'    THEN 3
	END;
        
