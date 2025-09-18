use manufacturing;

-- 
select * from downtime_factors;
select * from line_downtime1;
select * from line_productivity;
select * from products;


-- Summary downtime statistics per operator
With temp as(
select 
lp.operator, 
count(distinct lp.batch) as batches, 
SUM(timestampdiff(minute, str_to_date(start_time, '%H:%i:%s'), case when str_to_date(end_time, '%H:%i:%s') < str_to_date(start_time, '%H:%i:%s')
then date_add(str_to_date(end_time, '%H:%i:%s'), interval 1 day) else str_to_date(end_time, '%H:%i:%s') end)) as prod_time_mins,
sum(ld.downtime_mins) as downtime_mins,
round(sum(ld.downtime_mins) * 500/ 60) as downtime_cost,
round((sum(ld.downtime_mins) * 100.0) / (select sum(downtime_mins) from line_downtime1), 2) as percentage_contribution_to_downtime
from line_productivity lp
join line_downtime ld using (batch)
group by lp.operator)

select *, round(downtime_mins/batches) as avg_downtime_mins, round(downtime_cost/batches) as avg_downtime_cost from temp;


-- machine downtime factor statistics
select 
df.description, 
sum(downtime_mins) as downtime_mins, 
round(sum(ld.downtime_mins) * 500/ 60) as downtime_cost,
round((sum(ld.downtime_mins) * 100.0) / (select sum(downtime_mins) from line_downtime1 join downtine_factors using (factor) where operator_error ="No"), 2) as percentage_contribution_to_downtime
from downtime_factors df
join line_downtime ld using (factor)
where operator_error ="No"
group by df.description
order by downtime_mins desc;


-- products and their downtime factor statistics
select 
lp.product, 
df.description, 
sum(downtime_mins) as downtime_mins, 
round(sum(ld.downtime_mins) * 500/ 60) as downtime_cost,
count(distinct batch) as batches,
round(sum(downtime_mins)/count(distinct batch),1) as avg_downtime_mins_per_batch_per_product,
round((sum(ld.downtime_mins) * 100.0) / (select sum(downtime_mins) from line_downtime1 join downtine_factors using (factor) where operator_error ="No"), 2) as percentage_contribution_to_downtime
from line_productivity lp
join line_downtime ld using (batch)
join downtime_factors df using (factor)
where df.operator_error ="No"
group by lp.product, df.description
order by avg_downtime_mins_per_batch_per_product desc;



-- operators and their downtime factor statistics
select 
lp.operator,
df.description, 
sum(downtime_mins) as downtime_mins, 
round(sum(ld.downtime_mins) * 500/ 60) as downtime_cost,
round((sum(ld.downtime_mins) * 100.0) / SUM(SUM(ld.downtime_mins)) OVER (PARTITION BY lp.operator), 2) as percentage_contribution_to_downtime_per_operator
from downtime_factors df
join line_downtime ld using (factor)
join line_productivity lp using (batch)
where operator_error ="Yes"
group by lp.operator, df.description
order by lp.operator asc, percentage_contribution_to_downtime_per_operator desc;
