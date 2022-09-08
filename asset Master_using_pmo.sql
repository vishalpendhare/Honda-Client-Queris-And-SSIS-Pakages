select * from [dbo].[AX_Asset_Master1] where StatusId='A-ACTIVE'

insert into [Honda_Repository].dbo.PMO_3410012
select --[Id]
      [IsDeleted]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[Name]
      ,[Description]
      ,[Manufacturer]
      ,[Serial]
      ,[Location]
      ,[Notes]
      ,[ECRRanking]
      ,[MakeModel]
      ,[SiteId]
      ,[OrgId]
      ,[AssetNum]
      ,[Vendor]
      ,[FailureCode]
      ,[PurchasePrice]
      ,[InstalledDate]
      ,[WarrantyExpDate]
      ,[TotalCost]
      ,[BudgetCost]
      ,[IsRunning]
      ,[AssetType]
      ,[StatusId]
      ,[AssetId]
      ,[SerialNum]
      ,[AssetTag]
      ,[CId]
      ,[SId]
      ,[Quantity]
      ,[DepartmentId]
      ,[IsPmOptimization]
      ,[OldECRRanking]
      ,[Ref_Asset_Number]
      ,[Ref_Parent_Number]
      ,[Ref_Parent_Asset_Number]
      ,[Ref_Id]
      ,[AssetClass]
      ,[CLASSSTRUCTUREID]
      ,[MANUFACTURERID]
      ,0 as [AddToCart]
      ,null as [FailureClass]
      ,0 as [IsCritical]
from [dbo].AX_Assetmaster_11_05 
--where StatusId='A-ACTIVE'


select  assetnum from [Honda_Repository].dbo.PMO_3410012 where StatusId='A-ACTIVE'


update b
set b.StatusId='IN-ACTIVE'
--select *
from [dbo].[AX_Asset_Master] a
join PMO_3410012 b
on a.AssetNum=b.AssetNum
where Effective_Enddate='2022-01-31 23:59:59.000'
--where Effective_Startdate='2022-03-03 00:00:00.000'
--where Effective_Currentflag='Y'


-----update same data columns---

update a
set 
a.[ModifiedOn]=b.[ModifiedOn],
a.[Name]=b.[Name],
a.[Description]=b.[Description],
a.[Manufacturer]=b.[Manufacturer],
a.[Serial]=b.[Serial],
a.[Location]=b.[Location],
a.[ECRRanking]=b.[ECRRanking],
a.[MakeModel]=b.[MakeModel],
a.[Vendor]=b.[Vendor],
a.[FailureCode]=b.[FailureCode],
a.[PurchasePrice]=b.[PurchasePrice],
a.[InstalledDate]=b.[InstalledDate],
a.[WarrantyExpDate]=b.[WarrantyExpDate],
a.[TotalCost]=b.[TotalCost],
a.[BudgetCost]=b.[BudgetCost],
a.[IsRunning]=b.[IsRunning],
a.[AssetType]=b.[AssetType],
--a.[AssetId]=b.[AssetId],
a.statusid=b.statusid,
a.assetid=b.assetid,
a.[SerialNum]=b.[SerialNum],
a.[AssetTag]=b.[AssetTag],
a.[Quantity]=b.[Quantity],
a.[DepartmentId]=b.[DepartmentId],
a.[IsPmOptimization]=b.[IsPmOptimization],
a.[OldECRRanking]=b.[OldECRRanking],
a.[AssetClass]=b.[AssetClass],
a.[CLASSSTRUCTUREID]=b.[CLASSSTRUCTUREID],
a.[MANUFACTURERID]=b.[MANUFACTURERID]
--a.[AddToCart]=0,
--a.[FailureClass]=NULL,
--a.[IsCritical]=0
--- select * 
from [Honda_Repository].[dbo].[PMO_3410012] a
join [dbo].[AX_Assetmaster_Mar22]  b
on a.AssetNum=b.AssetNum 
--where a.StatusId='A-active'

--where Effective_Enddate='2022-01-31 23:59:59.000'
--where Effective_Startdate='2022-03-03 00:00:00.000'
--where Effective_Currentflag='Y'

--select * into [Honda_Repository].[dbo].[PMO_3410012_1]
--from [Honda_Repository].[dbo].[PMO_3410012]

select * --from [AX_Assetmaster_Mar22]
from [Honda_Repository].[dbo].[PMO_3410012]  where StatusId='A-active'

--update a
set a.ecrranking=b.hnarisk
-- select a.assetnum,b.hnarisk 
from [AX_Assetmaster_Mar22] a
 join [dbo].[ASSET_MAR22] b
on a.assetnum=b.assetnum

--select distinct AssetNum from [AX_Asset_Master]
--where --assetnum not in (select distinct assetnum from PMO_3410012 ) and 
--Effective_Currentflag='Y' --StatusId='A-active'

--select * into [Honda_Repository].[dbo].[PMO_3410012_BK]
--from [Honda_Repository].[dbo].[PMO_3410012]

-----------------Insert New row Data----------------------

insert into [Honda_Repository].[dbo].[PMO_3410012]
select --[Id]
      [IsDeleted]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[Name]
      ,[Description]
      ,[Manufacturer]
      ,[Serial]
      ,[Location]
      ,[Notes]
      ,[ECRRanking]
      ,[MakeModel]
      ,[SiteId]
      ,[OrgId]
      ,[AssetNum]
      ,[Vendor]
      ,[FailureCode]
      ,[PurchasePrice]
      ,[InstalledDate]
      ,[WarrantyExpDate]
      ,[TotalCost]
      ,[BudgetCost]
      ,[IsRunning]
      ,[AssetType]
      ,[StatusId]
      ,[AssetId]
      ,[SerialNum]
      ,[AssetTag]
      ,[CId]
      ,[SId]
      ,[Quantity]
      ,[DepartmentId]
      ,[IsPmOptimization]
      ,[OldECRRanking]
      ,[Ref_Asset_Number]
      ,[Ref_Parent_Number]
      ,[Ref_Parent_Asset_Number]
      ,[Ref_Id]
      ,[AssetClass]
      ,[CLASSSTRUCTUREID]
      ,[MANUFACTURERID]
      ,0 as [AddToCart]
      ,null [FailureClass]
      ,0 as [IsCritical]
 --select * --distinct assetnum  
 from [dbo].[AX_Assetmaster_Mar22]
where assetnum not in (select distinct assetnum from [Honda_Repository].[dbo].[PMO_3410012] ) --where statusid='A-active') 
--and Effective_Currentflag='Y'
--where Effective_Startdate='2022-03-03 00:00:00.000'



select distinct assetnum ,statusid 
 from [Honda_Repository].[dbo].[PMO_3410012] 
where --assetnum  not  in (select distinct assetnum from [dbo].[AX_Assetmaster_Mar22] ) 
--and 
statusid in ('IN-active','A-active')

select distinct assetnum from [dbo].[AX_Assetmaster_Mar22]  
where assetnum='A109521'



-------------
	--insert into [Honda_Repository].[dbo].[PMO_3410012]
	select * FROM [AX_Assetmaster_Mar22]  a
	where assetnum  not in (select distinct assetnum from  [Honda_Repository].[dbo].[PMO_3410012] )

update a
set a.StatusId='IN-ACTIVE'
-- select distinct assetnum  
 from [Honda_Repository].[dbo].[PMO_3410012] a
where assetnum   not in (select distinct assetnum from [dbo].[AX_Assetmaster_Mar22] ) 
and statusid='A-active' 

select * from [Honda_Repository].[dbo].[PMO_3410012] where --sid=2 
StatusId  in('A-active')

select distinct AssetNum from  [Honda_Repository].[dbo].[AX_Asset_Master] a
where assetnum in ('A238961','A239017')

select * --distinct assetnum  
 from [Honda_Repository].[dbo].[AX_Asset_Master] a
where assetnum not in (select  distinct assetnum from [Honda_Repository].[dbo].[PMO_3410012] where StatusId='A-active') 
and statusid not in('In-active' 


select * from [Honda_Repository].[dbo].[AX_Asset_Master]
where StatusId='A-active' and Effective_Currentflag='Y'  


select * from [Honda_Repository].[dbo].[AX_Segment_Metric_Facts]
--update [Honda_Repository].[dbo].[AX_Asset_Master]
--set Effective_Currentflag='N'
--where StatusId!='A-active' and Effective_Currentflag='Y'



---------Ax asset master addd

-----update same data columns---

update a
set 
a.[ModifiedOn]=b.[ModifiedOn],
a.[Name]=b.[Name],
a.[Description]=b.[Description],
a.[Manufacturer]=b.[Manufacturer],
a.[Serial]=b.[Serial],
a.[Location]=b.[Location],
a.[ECRRanking]=b.[ECRRanking],
a.[MakeModel]=b.[MakeModel],
a.[Vendor]=b.[Vendor],
a.[FailureCode]=b.[FailureCode],
a.[PurchasePrice]=b.[PurchasePrice],
a.[InstalledDate]=b.[InstalledDate],
a.[WarrantyExpDate]=b.[WarrantyExpDate],
a.[TotalCost]=b.[TotalCost],
a.[BudgetCost]=b.[BudgetCost],
a.[IsRunning]=b.[IsRunning],
a.[AssetType]=b.[AssetType],
--a.[AssetId]=b.[AssetId],
a.statusid=b.statusid,
a.assetid=b.assetid,
a.[SerialNum]=b.[SerialNum],
a.[AssetTag]=b.[AssetTag],
a.[Quantity]=b.[Quantity],
a.[DepartmentId]=b.[DepartmentId],
a.[IsPmOptimization]=b.[IsPmOptimization],
a.[OldECRRanking]=b.[OldECRRanking],
a.[AssetClass]=b.[AssetClass],
a.[CLASSSTRUCTUREID]=b.[CLASSSTRUCTUREID],
a.[MANUFACTURERID]=b.[MANUFACTURERID]
--a.[AddToCart]=0,
--a.[FailureClass]=NULL,
--a.[IsCritical]=0
--- select distinct a.assetnum
from [Honda_Repository].[dbo].[AX_Asset_Master] a
join [Honda_Repository].[dbo].[PMO_3410012] b
on a.AssetNum=b.AssetNum 
where a.StatusId in('A-active', 'In-active')  



------Update Records----

update a
set a.StatusId='IN-ACTIVE'
-- select distinct assetnum  
 from [Honda_Repository].[dbo].[AX_Asset_Master] a
where assetnum not in (select distinct assetnum from [Honda_Repository].[dbo].[PMO_3410012] where StatusId='A-active') 
and statusid not in('A-active','IN-ACTIVE')



------insert record------

insert into [Honda_Repository].[dbo].[AX_Asset_master]
select --[Id]
      [IsDeleted]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[Name]
      ,[Description]
      ,[Manufacturer]
      ,[Serial]
      ,[Location]
      ,[Notes]
      ,[ECRRanking]
      ,[MakeModel]
      ,[SiteId]
      ,[OrgId]
      ,[AssetNum]
      ,[Vendor]
      ,[FailureCode]
      ,[PurchasePrice]
      ,[InstalledDate]
      ,[WarrantyExpDate]
      ,[TotalCost]
      ,[BudgetCost]
      ,[IsRunning]
      ,[AssetType]
      ,[StatusId]
      ,[AssetId]
      ,[SerialNum]
      ,[AssetTag]
      ,[CId]
      ,[SId]
      ,[Quantity]
      ,[DepartmentId]
      ,[IsPmOptimization]
      ,[OldECRRanking]
      ,[Ref_Asset_Number]
      ,[Ref_Parent_Number]
      ,[Ref_Parent_Asset_Number]
      ,[Ref_Id]
      ,[AssetClass]
      ,[CLASSSTRUCTUREID]
      ,[MANUFACTURERID]
      ,null as [LOCDESCRIPTION]
      ,'2022-03-01 00:00:00.000' [Effective_Startdate]
      ,'9999-12-31 23:59:59.000' [Effective_Enddate]
      ,'Y' [Effective_Currentflag]
      ,'BI Team' [Updated_BY]
      ,getdate() [Updated_On]
      ,'BI Team' [Inserted_By]
      ,getdate() [Inserted_On] 
 from [Honda_Repository].[dbo].[PMO_3410012] 
where assetnum  not in (select distinct assetnum from [Honda_Repository].[dbo].[AX_Asset_master] )    --
--where statusid='A-active') 


select * from [Honda_Repository].[dbo].[AX_Asset_master]
where Effective_Currentflag='Y'


----Retired asset---------

update a
set --a.StatusId='IN-ACTIVE'
--Effective_Enddate='2022-02-28 23:59:59.000',
Effective_Currentflag='Y'
-- select *--distinct assetnum  
 from [Honda_Repository].[dbo].[AX_Asset_master] a
where assetnum    in (select distinct assetnum from [Honda_Repository].[dbo].[PMO_3410012] where  statusid='A-active'  ) 
and  
statusid='A-ACTIVE'  and Effective_Currentflag='N'


select * from [Honda_Repository].[dbo].[Client_WorkorderBKFeb] 
where year='31-Mar-2022'


