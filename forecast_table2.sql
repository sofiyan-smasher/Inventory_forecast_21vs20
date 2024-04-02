create temporary table fa_2020 as (
with  forecaste_accuracy as (
SELECT 
	a.customer_code, sum(a.sold_quantity) as total_sold_quantity,
    sum(a.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity-sold_quantity)) as net_err,
    sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
    sum(abs(forecast_quantity-sold_quantity)) as abs_err,
    sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
FROM fact_act_est a
WHERE fiscal_year = 2020 
GROUP BY a.customer_code
)

SELECT
	f.customer_code,
	c.customer as customer_name,
    c.market,
    f.total_sold_quantity,
    f.total_forecast_quantity,
    f.net_err,
    round(f.net_err_pct,2) as net_err_pct,
    f.abs_err,
    round(f.abs_err_pct,2) as abs_err_pct,
    IF (f.abs_err_pct > 100,0,round((100-f.abs_err_pct),2)) as forecast_accuracy_20
FROM forecaste_accuracy f
JOIN dim_customer c
USING (customer_code)
ORDER BY forecast_accuracy_20)