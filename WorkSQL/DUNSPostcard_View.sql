USE [ODS]
GO

/****** Object:  View [reports].[DUNSPostcard]    Script Date: 9/1/2023 10:44:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [reports].[DUNSPostcard] AS

select
'2022-06-27' as Campaign_Drop_Date,
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-06-27', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-06-27' --change this
       and campaign_name like 'Free DUNS Postcard%'
)
and order_date >= '2022-06-27' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-08-26' as Campaign_Drop_Date,
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-08-26', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-08-26' --change this
       and campaign_name like 'Free DUNS Postcard%'
)
and order_date >= '2022-08-26' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-09-23' as Campaign_Drop_Date,
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-09-23', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-09-23' --change this
       and campaign_name like 'Free DUNS Postcard%'
)
and order_date >= '2022-09-23' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-10-03' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-10-03', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-10-03' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-10-03' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-10-13' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-10-13', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-10-13' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-10-13' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-10-26' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-10-26', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-10-26' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-10-26' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-11-09' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-11-09', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-11-09' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-11-09' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-11-28' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-11-28', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-11-28' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-11-28' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2022-12-12' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-12-12', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-12-12' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-12-12' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

--upcoming campaigns

UNION

select
'2022-12-27' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2022-12-27', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2022-12-27' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2022-12-27' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

UNION

select
'2023-01-09' as Campaign_Drop_Date, --change this
duns_number,
event_date,
row_number() over (partition by duns_number order by event_date ASC) as SaleNumber,
dense_rank() over (partition by duns_number, case when net_amount = 0 then 'Free' else 'Pay' end order by event_date ASC) as RankedSaleNumber,
case when net_amount = 0 then 'Free' else 'Pay' end as product_type,
product_name,
channel,
datediff(day, '2023-01-09', cast(order_date as date)) as days_to_conversion, --change this
case when renewal_interval = 'MONTHLY' AND Product_Name LIKE ('%6 Months%') then sum(net_amount)
	 when renewal_interval = 'MONTHLY' then sum(net_amount) * 12
	 else sum(net_amount) end as net_amount,
count(distinct customer_identifier) customers,
count(distinct duns_number) as duns_count
from ods.event.operational_sales
where duns_number in 
(
       select duns_number
       from bi_campaign_prod.directmail.tracking
       where date_sent = '2023-01-09' --change this
       and campaign_name like '%DUNS Postcard%'
)
and order_date >= '2023-01-09' --change this
and event_type = 'New Sales'
AND same_day_cancel=0
group by
duns_number,
event_date,
case when net_amount = 0 then 'Free' else 'Pay' end,
product_name,
channel,
cast(order_date as date),
renewal_interval

;

GO


