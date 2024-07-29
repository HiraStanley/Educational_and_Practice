USE [ODS]
GO

/****** Object:  StoredProcedure [reports].[refresh_FreePaid_DUNS]    Script Date: 9/1/2023 10:39:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROC [reports].[refresh_FreePaid_DUNS] AS


BEGIN

--Creating the Free and Paid DUNS tables

drop table if exists ods.reports.Free_DUNS;
drop table if exists ods.reports.Paid_DUNS;
drop table if exists #FREE_DUNS;
drop table if exists #PAID_DUNS;

SELECT
  CASE WHEN DATENAME(month,pfd.created_date)+' '+CAST(YEAR(pfd.created_date) AS CHAR(4)) = DATENAME(month,GETDATE())+' '+CAST(YEAR(GETDATE()) AS CHAR(4)) THEN 'MTD' ELSE DATENAME(month,pfd.created_date)+' '+CAST(YEAR(pfd.created_date) AS CHAR(4))  END AS Month
, DATEADD(month, DATEDIFF(month, 0, pfd.created_date), 0) AS Order_Month
, CAST(pfd.created_date AS Date) AS Order_Date
, pfd.order_item_identifier
, pc.product_name
, CASE WHEN pfd.fulfillment_request_status_code <> 'RQSTD' AND so.order_status_code = 'INIT' AND soi.item_status_code = 'PEND' THEN 'Cart Abandoned' ELSE soi.item_status_code END AS order_status
INTO #FREE_DUNS
FROM Intraday.AppUser.product_fulfillment_detail pfd
LEFT OUTER JOIN Intraday.EComm.sales_order_item soi (NOLOCK)
ON pfd.order_item_identifier = soi.order_item_identifier

LEFT OUTER JOIN Intraday.EComm.sales_order so (NOLOCK)
ON soi.order_identifier = so.order_identifier

LEFT OUTER JOIN Intraday.product.product_catalog pc (NOLOCK)
ON pfd.product_catalog_identifier = pc.product_catalog_identifier

WHERE pfd.product_catalog_identifier NOT IN (6089,14606)
AND (/* for requested, loaddate is last_modified_date */
		(pfd.fulfillment_request_status_code = 'RQSTD' AND CAST(pfd.last_modified_date AS DATE) > EOMONTH(DATEADD(mm,-7,CAST(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date))))
	/* for fulfilled from request, loaddate is closer to created_date since last_modified_date may be several days later */
	OR	(pfd.fulfillment_request_status_code = 'FFLED' AND pfd.dandb_disposition IS NOT NULL  AND CAST(pfd.created_date AS DATE) > EOMONTH(DATEADD(mm,-7,CAST(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date))))
	);

SELECT 	soi.order_item_identifier,
		CASE WHEN DATENAME(month,so.order_date)+' '+CAST(YEAR(so.order_date) AS CHAR(4)) = DATENAME(month,GETDATE())+' '+CAST(YEAR(GETDATE()) AS CHAR(4)) THEN 'MTD' ELSE DATENAME(month,so.order_date)+' '+CAST(YEAR(so.order_date) AS CHAR(4))  END AS Month, 
        DATEADD(month, DATEDIFF(month, 0, so.order_date), 0) AS Order_month,
		P.[product_name],
		soi.item_net_amount as net_amount
INTO #PAID_DUNS
from [IntraDay].[EComm].[sales_order] (NOLOCK) so	
join [IntraDay].[EComm].[sales_order_item] (NOLOCK) soi 
on so.order_identifier=soi.order_identifier	

left join  [IntraDay].product.product_catalog (NOLOCK) P 
on P.product_catalog_identifier=soi.product_catalog_identifier

WHERE cast(so.order_date as date) > EOMONTH(DATEADD(mm,-7,CAST(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date)))
	AND p.product_name IN  ('DUNS File Creator Basic' ,'Small Business Starter')
	AND so.order_status_code NOT IN ('INIT','CNCLED','SQL_ERR','SUSPND');


/* Delete prior orders */
DELETE FROM #FREE_DUNS 
WHERE Product_Name IN ('DUNS File Creator Basic','Small Business Starter') 
AND order_Date < cast(getdate()-1 as date);

/* Delete captured in fulfilment*/
DELETE FROM #PAID_DUNS 
WHERE order_item_identifier IN (SELECT order_item_identifier FROM #FREE_DUNS);


INSERT INTO  #FREE_DUNS
select
  CASE WHEN DATENAME(month,so.order_date)+' '+CAST(YEAR(so.order_date) AS CHAR(4)) = DATENAME(month,GETDATE())+' '+CAST(YEAR(GETDATE()) AS CHAR(4)) THEN 'MTD' ELSE DATENAME(month,so.order_date)+' '+CAST(YEAR(so.order_date) AS CHAR(4))  END AS Month
, DATEADD(month, DATEDIFF(month, 0,so.order_date), 0) AS Order_Month
, CAST(so.order_date AS Date) as order_date
, pfd.order_item_identifier
, pc.product_name 
, pfd.item_status_code
from Intraday.EComm.sales_order_item pfd	
left join Intraday.EComm.sales_order so 
on so.order_identifier = pfd.order_identifier
left join Intraday.product.product_catalog (NOLOCK) pc 
on pfd.product_catalog_identifier = pc.product_catalog_identifier
where pfd.order_item_identifier in (select a.order_item_identifier from #PAID_DUNS a);


DELETE FROM #FREE_DUNS
WHERE order_status='Cart Abandoned';



 SELECT Order_month,
        month,
        COUNT(DISTINCT Order_item_identifier) AS Requests
 INTO ods.reports.Free_DUNS
 FROM #FREE_DUNS
GROUP BY Order_month,
        month;


 SELECT Order_month,
        month,
        COUNT(DISTINCT Order_item_identifier) AS Requests,
		SUM(net_amount) AS Amount
 INTO ods.reports.Paid_DUNS
FROM #Paid_DUNS
GROUP BY Order_month,
        month;

END

GO


