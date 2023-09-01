USE [ODS]
GO

/****** Object:  StoredProcedure [reports].[refresh_SMB_DMEM_ROI_Sales_Data_ODS]    Script Date: 7/12/2023 12:02:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








  CREATE PROCEDURE [reports].[refresh_SMB_DMEM_ROI_Sales_Data_ODS]
  WITH RECOMPILE
  AS 
  BEGIN 

      SET NOCOUNT ON; 

		 DECLARE @CurrentDate DATE, 
		         @StartOfYear DATE 
         SET @CurrentDate = CAST(GETDATE () AS DATE) 
		 SET @StartofYear = '2020-01-01' 
/*
DROP TABLE IF EXISTS reports.SMB_DMEM_ROI_Sales_Data_ODS
CREATE TABLE reports.SMB_DMEM_ROI_Sales_Data_ODS
  (
   ID INT IDENTITY (1,1), 
   Contact_ID INT,
   DUNS VARCHAR(9), 
   Email VARCHAR(200),
   Campaign_Group VARCHAR(255), 
   Order_Identifier INT,
   Offer_Type VARCHAR(10), 
   Cell_Code VARCHAR(20), 
   Drop_Date DATE, 
   Audience_Type VARCHAR(50), 
   DNB_Phone VARCHAR(15), 
   Ticket_Number VARCHAR(50), 
   Channel CHAR(2), 
   Response_End_Date DATE, 
   order_item_identifier BIGINT,
   Product_Category VARCHAR(255),
   Product_Name VARCHAR(255),
   Product_Group VARCHAR(5), 
   Purchase_Date DATE, 
   Purchase_Amount FLOAT, 
   Drop_Date_Diff INT, 
   Considered_For_Attribution CHAR(1), --take out if needed
   Attribution_Ok CHAR(1)
   )
*/ 
   TRUNCATE TABLE reports.SMB_DMEM_ROI_Sales_Data_ODS

INSERT INTO reports.SMB_DMEM_ROI_Sales_Data_ODS
   (   
       Contact_ID,
       DUNS,
	   Email,
       Campaign_Group,
	   Order_Identifier,
       Offer_Type,
       Cell_Code,
       Drop_Date,
       Audience_Type,
       DNB_Phone,
       Ticket_Number,
       Channel,
       Response_End_Date,
	   order_item_identifier,
	   Product_Category,
	   Product_Name,
	   Product_Group, 
       Purchase_Date , 
       Purchase_Amount,
	   Considered_For_Attribution
    )

	SELECT A.Contact_Id,
	       A.DUNS ,
	       A.Email, 
		   A.Campaign_Group, 
		   B.Order_Identifier,
		   A.Offer_Type, 
		   A.Cell_Code, 
		   A.Date_Sent, 
           A.Audience_Type,
           A.DNIS,
           A.Ticket_Number,
           A.Channel,
		   A.Response_End_Date, 
		   B.order_item_identifier,
		   B.product_category,
		   B.Product_Name,
		   B.Product_Group,
		   B.Order_Date,
		   case when B.renewal_interval = 'MONTHLY' AND B.Product_Name LIKE ('%6 Months%') then B.net_amount
					when B.renewal_interval = 'MONTHLY' then B.net_amount * 12 --may change to 7
					else B.net_amount end,
		   case when Audience_Type IN ('Win-Back', 'Former-Customer', 'Former Customer', 'Non-Customer', 'Prospect') then 'Y' 
				   when Campaign_Group LIKE ('%NCA%') then 'Y' 
				   when Campaign_Group LIKE ('%SER%')  then 'Y'
				   when Campaign_Group LIKE ('%INQ%') then 'Y'
				   when Campaign_Group LIKE ('%x-sell%') then 'Y'
				   when Campaign_Group = 'CS cross-sell' then 'Y'
				   when Campaign_Group = 'Various' then 'Y'
				   when Campaign_Group = ('Credit Monitor') AND Product_Category IN ('CreditMonitor') then 'Y'
				   when Campaign_Group = ('Credit Signal') AND Product_Category IN ('CreditSignal') then 'Y'
				   when Campaign_Group = ('CreditBuilder') AND Product_Category IN ('CreditBuilder') then 'Y'
				   when Campaign_Group IN ('Upsell to CreditSignal Customers', 'CreditSignal EM') then 'Y'
				   when Campaign_Group IN ('Concierge', 'Concierge Winback', 'Concierge Upgrade') AND Product_Category LIKE ('%Concierge%') then 'Y'
				   when Campaign_Group IN ('CreditBuilder Winback', 'CreditBuilder Upgrade', 'Upsell to CreditMonitor Customers') AND Product_Category IN ('CreditBuilder', 'Credit Essentials', 'Concierge') then 'Y'
				   when Campaign_Group IN ('CreditMonitor Upgrade', 'Upsell to CreditSignalPlus Customers') AND Product_Category IN ('CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group = ('Upsell to CreditSignal Customers') AND Product_Category IN ('CreditSignal Plus', 'CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group IN ('DPS Drop', 'Paydex Drop') AND Product_Category IN ('CreditBuilder', 'Concierge') then 'Y'
				   when Campaign_Group = 'Lead Concierge' AND Product_Category = 'Lead Concierge' then 'Y'
				   when Campaign_Group = 'Rev.Up Now Test' AND Product_Category = 'RevUp Now' then 'Y'
				   when Campaign_Group = 'DUNS Development' then 'Y'
				   when Campaign_Group = 'DRS Upsell Campaign EM' then 'Y'
				   when Campaign_Group LIKE ('%Anniversary%') then 'N'
				   when Campaign_Group = 'Concierge Bi-Annual' then 'N'
				   when Campaign_Group LIKE ('%Survey%') then 'N'
				   when Product_Name LIKE ('%Renewal%') then 'N'
				   else NULL end
	FROM ods.reports.SMB_DMEM_ROI_Gross_Universe A 
	INNER JOIN ods.event.operational_sales B ON A.DUNS = B.duns_number 
	AND B.Order_Date >= @StartOfYear 
	AND B.billing_type <> 'Free' 
	AND B.net_amount > 1
	AND B.event_source = 'Phoenix'
	AND B.event_type = 'New Sales'
	AND B.order_date > A.Date_Sent 

	--343k matches in Datamart vs 322k matches in OpsSales

	UNION

	SELECT A.Contact_Id,
	       A.DUNS ,
	       A.Email, 
		   A.Campaign_Group, 
		   B.Order_Identifier,
		   A.Offer_Type, 
		   A.Cell_Code, 
		   A.Date_Sent, 
           A.Audience_Type,
           A.DNIS,
           A.Ticket_Number,
           A.Channel,
		   A.Response_End_Date, 
		   B.order_item_identifier,
		   B.product_category,
		   B.Product_Name,
		   B.Product_Group,
		   B.Order_Date,
		   case when B.renewal_interval = 'MONTHLY' AND B.Product_Name LIKE ('%6 Months%') then B.net_amount
					when B.renewal_interval = 'MONTHLY' then B.net_amount * 12 --may change to 7
					else B.net_amount end,
		   case when Audience_Type IN ('Win-Back', 'Former-Customer', 'Former Customer', 'Non-Customer', 'Prospect') then 'Y' 
				   when Campaign_Group LIKE ('%NCA%') then 'Y' 
				   when Campaign_Group LIKE ('%SER%')  then 'Y'
				   when Campaign_Group LIKE ('%INQ%') then 'Y'
				   when Campaign_Group LIKE ('%x-sell%') then 'Y'
				   when Campaign_Group = 'CS cross-sell' then 'Y'
				   when Campaign_Group = 'Various' then 'Y'
				   when Campaign_Group = ('Credit Monitor') AND Product_Category IN ('CreditMonitor') then 'Y'
				   when Campaign_Group = ('Credit Signal') AND Product_Category IN ('CreditSignal') then 'Y'
				   when Campaign_Group = ('CreditBuilder') AND Product_Category IN ('CreditBuilder') then 'Y'
				   when Campaign_Group IN ('Upsell to CreditSignal Customers', 'CreditSignal EM') then 'Y'
				   when Campaign_Group IN ('Concierge', 'Concierge Winback', 'Concierge Upgrade') AND Product_Category LIKE ('%Concierge%') then 'Y'
				   when Campaign_Group IN ('CreditBuilder Winback', 'CreditBuilder Upgrade', 'Upsell to CreditMonitor Customers') AND Product_Category IN ('CreditBuilder', 'Credit Essentials', 'Concierge') then 'Y'
				   when Campaign_Group IN ('CreditMonitor Upgrade', 'Upsell to CreditSignalPlus Customers') AND Product_Category IN ('CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group = ('Upsell to CreditSignal Customers') AND Product_Category IN ('CreditSignal Plus', 'CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group IN ('DPS Drop', 'Paydex Drop') AND Product_Category IN ('CreditBuilder', 'Concierge') then 'Y'
				   when Campaign_Group = 'Lead Concierge' AND Product_Category = 'Lead Concierge' then 'Y'
				   when Campaign_Group = 'Rev.Up Now Test' AND Product_Category = 'RevUp Now' then 'Y'
				   when Campaign_Group = 'DUNS Development' then 'Y'
				   when Campaign_Group = 'DRS Upsell Campaign EM' then 'Y'
				   when Campaign_Group LIKE ('%Anniversary%') then 'N'
				   when Campaign_Group = 'Concierge Bi-Annual' then 'N'
				   when Campaign_Group LIKE ('%Survey%') then 'N'
				   when Product_Name LIKE ('%Renewal%') then 'N'
				   else NULL end
	FROM ods.reports.SMB_DMEM_ROI_Gross_Universe A 
	INNER JOIN ods.event.operational_sales B ON A.DUNS = B.duns_number_reg
	AND B.Order_Date >= @StartOfYear 
	AND B.billing_type <> 'Free' 
	AND B.net_amount > 1
	AND B.event_source = 'Phoenix'
	AND B.event_type = 'New Sales'
	AND B.order_date > A.Date_Sent 

	--343k matches in Datamart vs 322k matches in OpsSales

	UNION

		SELECT A.Contact_Id,
	       A.DUNS ,
	       A.Email, 
		   A.Campaign_Group, 
		   B.Order_Identifier,
		   A.Offer_Type, 
		   A.Cell_Code, 
		   A.Date_Sent, 
           A.Audience_Type,
           A.DNIS,
           A.Ticket_Number,
           A.Channel,
		   A.Response_End_Date, 
		   B.order_item_identifier,
		   B.product_category,
		   B.Product_Name,
		   B.Product_Group,
		   B.Order_Date,
		   case when B.renewal_interval = 'MONTHLY' AND B.Product_Name LIKE ('%6 Months%') then B.net_amount
					when B.renewal_interval = 'MONTHLY' then B.net_amount * 12 --may change to 7
					else B.net_amount end,
		   case when Audience_Type IN ('Win-Back', 'Former-Customer', 'Former Customer', 'Non-Customer', 'Prospect') then 'Y' 
				   when Campaign_Group LIKE ('%NCA%') then 'Y' 
				   when Campaign_Group LIKE ('%SER%')  then 'Y'
				   when Campaign_Group LIKE ('%INQ%') then 'Y'
				   when Campaign_Group LIKE ('%x-sell%') then 'Y'
				   when Campaign_Group = 'CS cross-sell' then 'Y'
				   when Campaign_Group = 'Various' then 'Y'
				   when Campaign_Group = ('Credit Monitor') AND Product_Category IN ('CreditMonitor') then 'Y'
				   when Campaign_Group = ('Credit Signal') AND Product_Category IN ('CreditSignal') then 'Y'
				   when Campaign_Group = ('CreditBuilder') AND Product_Category IN ('CreditBuilder') then 'Y'
				   when Campaign_Group IN ('Upsell to CreditSignal Customers', 'CreditSignal EM') then 'Y'
				   when Campaign_Group IN ('Concierge', 'Concierge Winback', 'Concierge Upgrade') AND Product_Category LIKE ('%Concierge%') then 'Y'
				   when Campaign_Group IN ('CreditBuilder Winback', 'CreditBuilder Upgrade', 'Upsell to CreditMonitor Customers') AND Product_Category IN ('CreditBuilder', 'Credit Essentials', 'Concierge') then 'Y'
				   when Campaign_Group IN ('CreditMonitor Upgrade', 'Upsell to CreditSignalPlus Customers') AND Product_Category IN ('CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group = ('Upsell to CreditSignal Customers') AND Product_Category IN ('CreditSignal Plus', 'CreditMonitor', 'CreditBuilder', 'Credit Essentials','Concierge') then 'Y'
				   when Campaign_Group IN ('DPS Drop', 'Paydex Drop') AND Product_Category IN ('CreditBuilder', 'Concierge') then 'Y'
				   when Campaign_Group = 'Lead Concierge' AND Product_Category = 'Lead Concierge' then 'Y'
				   when Campaign_Group = 'Rev.Up Now Test' AND Product_Category = 'RevUp Now' then 'Y'
				   when Campaign_Group = 'DUNS Development' then 'Y'
				   when Campaign_Group = 'DRS Upsell Campaign EM' then 'Y'
				   when Campaign_Group LIKE ('%Anniversary%') then 'N'
				   when Campaign_Group = 'Concierge Bi-Annual' then 'N'
				   when Campaign_Group LIKE ('%Survey%') then 'N'
				   when Product_Name LIKE ('%Renewal%') then 'N'
				   else NULL end
	FROM ods.reports.SMB_DMEM_ROI_Gross_Universe A 
	INNER JOIN ods.event.operational_sales B ON A.EMail = B.customer_email
	AND B.Order_Date >= @StartOfYear 
	AND B.billing_type <> 'Free' 
	AND B.net_amount > 1
	AND B.event_source = 'Phoenix'
	AND B.event_type = 'New Sales'
	AND B.order_date > A.Date_Sent 

	--343k matches in Datamart vs 144k matches in OpsSales

	GROUP BY A.Contact_Id,
	         A.DUNS ,
	         A.Email, 
		     A.Campaign_Group, 
			 B.Order_Identifier,
		     A.Offer_Type, 
		     A.Cell_Code, 
		     A.Date_Sent, 
             A.Audience_Type,
             A.DNIS,
             A.Ticket_Number,
             A.Channel,
		     A.Response_End_Date, 
		     B.order_item_identifier,
		     B.product_category,
		     B.Product_Name,
		     B.Product_Group,
		     B.Order_Date,
			 case when B.renewal_interval = 'MONTHLY' AND B.Product_Name LIKE ('%6 Months%') then B.net_amount
				when B.renewal_interval = 'MONTHLY' then B.net_amount * 12
				else B.net_amount end

	ORDER BY B.Order_Date ASC


	UPDATE A 
	  SET Drop_Date_Diff = DATEDIFF(DAY, Drop_Date, Purchase_Date)
	  FROM reports.SMB_DMEM_ROI_Sales_Data_ODS A 
	  WHERE Purchase_Date BETWEEN Drop_Date AND Response_End_Date

	  UPDATE A 
	    SET Attribution_Ok = 'Y' 
		FROM reports.SMB_DMEM_ROI_Sales_Data_ODS A 
		INNER JOIN (SELECT ID , 
		                   ROW_NUMBER() OVER (PARTITION BY order_item_identifier ORDER BY Drop_Date_Diff ASC) AS ROWNUMBER
		            FROM reports.SMB_DMEM_ROI_Sales_Data_ODS
					WHERE Drop_Date_Diff IS NOT NULL AND Purchase_Amount >= 1
					) tbl 
        ON A.ID = tbl.ID 
		WHERE tbl.ROWNUMBER = 1
		AND Considered_For_Attribution = 'Y'

END
GO


