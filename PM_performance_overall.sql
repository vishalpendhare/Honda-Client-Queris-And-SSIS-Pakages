


------------------------ASSET COUNT--------------
SELECT COUNT(DISTINCT AssetNum)AssetNum,SiteId FROM PMO_3410012 
WHERE StatusId IN ('ACTIVE','OPERATING') AND IsDeleted=0
GROUP  BY SiteId


SELECT COUNT(DISTINCT CMMS_Asset_ID)AssetNum,siteid FROM [dbo].[AX_Asset_Metric_Facts]
GROUP  BY siteid


------------------SEGMENT COUNT

SELECT count(distinct concat(AssetClass,'-',MANUFACTURER,'-',MakeModel))family,SiteId
FROM PMO_3410012 
WHERE --SiteId='DAF'AND 
StatusId IN ('ACTIVE','OPERATING') AND IsDeleted=0
-- and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%ANAL%')--and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%INST0018%')
GROUP BY SiteId




-------------------------EQUIPMENT UNDER PM PROGRAM-----------------------------------------------

select count(distinct ASSETNUM)ASSETNUM,SITEID from Client_PM
--WHERE ASSETNUM IS NOT NULL
GROUP BY SITEID


select distinct AssetNum from PMO_3410012
where SiteId='daf'


---------------------------TOTAL PM WO COUNT----------------------------------

select   count ( WONUM)PM_WOCOUNT--,A.SITEID 
from [dbo].[PMO_3410012]  a 
left join Client_Workorder w
on a.ASSETNUM=w.ASSETNUM
--left join Client_PM c on w.PMNUM=c.PMNUM
--left join Segment_Objects s on s.ASSETNUM=a.AssetNum
where  DEV_WORKTYPE='pm' and w.Year='31-MAR-2022'
and  a.statusid  in ('OPERATING','ACTIVE') and a.IsDeleted=0 and a.SiteId='prd'and w.SITEID='prd' 
--GROUP  BY A.SITEID


select sum(pmcount)PM_WOCOUNT,siteid from [dbo].[AX_Asset_Metric_Facts]
GROUP  BY siteid


---------------------UNSCHEDULED DOWNTIME HRS-------------------------------------------------------


select sum (W.DOWNTIME) 
from PMO_3410012 a 
left join  [dbo].Client_Workorder W 
on a.AssetNum=w.ASSETNUM
where  W.DEV_WORKTYPE  in ('RM') and w.Year='31-MAR-2022' 
and a.siteid='prd' and w.SITEID='prd'



SELECT MIN(ACTFINISH),MAX(ACTFINISH) from [dbo].Client_Workorder


---------------------SCHEDULED DOWNTIME HRS-------------------------------------------------------


select sum (w.DOWNTIME)DOWNTIME 
from PMO_3410012 a left join 
[dbo].Client_Workorder W on a.AssetNum=w.ASSETNUM
left join Client_PM c on w.PMNUM=c.PMNUM
left join Segment_Objects s on s.ASSETNUM=a.AssetNum
where   w.Year='31-MAR-2022'
and a.statusid  in ('ACTIVE','OPERATING')  and a.siteid='prd' and w.SITEID='prd'



---------------------------TECHNICIAN COUNT------------------------------------

SELECT COUNT(DISTINCT LABORCODE),A.SITEID 
FROM [dbo].[PMO_3410012] a LEFT JOIN 
Client_Workorder W  ON A.ASSETNUM=W.AssetNum
LEFT JOIN Client_Labtrans CL ON W.WONUM=CL.REFWO
left join Client_PM c on w.PMNUM=c.PMNUM
left join Segment_Objects s on s.ASSETNUM=a.AssetNum
WHERE  Year='31-MAR-2022'   AND a.STATUSID IN ('ACTIVE','OPERATING') and w.DEV_WORKTYPE ='pm'
GROUP BY A.SITEID

----------------SEGMENT WITH NO CHILD WO
SELECT 
count(distinct case when W.PARENT is null then s.SegmentMasterID end)SegmentwithNoChildWO
from  [dbo].PMO_3410012 a
left join [dbo].[Client_Workorder] w on a.AssetNum=w.ASSETNUM
left join Client_PM c on w.PMNUM=c.PMNUM
left join Segment_Objects s on s.ASSETNUM=a.AssetNum
where a.statusid in ('ACTIVE','OPERATING') and A.SITEID='DAF' and w.Year='31-Mar-2022' and a.IsDeleted=0 and W.SITEID='DAF'  





---------------------MAINTENANCE COST DISTRIBUTION--------------------------

with test as
(
select  a.SITEID,DEV_WORKTYPE,CAST(sum(ACTLABCOST)AS DECIMAL(16,2)) Value,'Labor' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN [dbo].[Client_Workorder] CW ON CW.ASSETNUM=A.assetnum
left join [dbo].[Segment_Objects] s on s.assetnum=cw.assetnum
where a.StatusId in('OPERATING','Active') 
--and  CW.SITEID='prd'and a.SiteId='PRD'
and CW.Year='31-Mar-2022' AND DEV_WORKTYPE IN ('CM','PM','RM')
AND A.IsDeleted=0 AND A.SiteId=CW.SITEID
group by a.SITEID,CW.DEV_WORKTYPE
union all
select  a.SITEID,DEV_WORKTYPE,CAST(sum(ACTMATCOST)AS DECIMAL(16,2)) Value,'Material' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN [dbo].[Client_Workorder] CW ON CW.ASSETNUM=A.assetnum
left join [dbo].[Segment_Objects] s on s.assetnum=cw.assetnum
where a.StatusId in('OPERATING','Active') 
--and  CW.SITEID='prd'and a.SiteId='PRD'
and CW.Year='31-Mar-2022' AND DEV_WORKTYPE IN ('CM','PM','RM')
AND A.IsDeleted=0 AND A.SiteId=CW.SITEID
group by a.SITEID,CW.DEV_WORKTYPE
union all
select  a.SITEID,DEV_WORKTYPE,CAST(sum(ACTLABHRS)AS DECIMAL(16,2)) Value,'contract' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN [dbo].[Client_Workorder] CW ON CW.ASSETNUM=A.assetnum
left join [dbo].[Segment_Objects] s on s.assetnum=cw.assetnum
where a.StatusId in('OPERATING','Active') 
--and  CW.SITEID='prd'and a.SiteId='PRD'
and CW.Year='31-Mar-2022' AND DEV_WORKTYPE IN ('CM','PM','RM')
AND A.IsDeleted=0 AND A.SiteId=CW.SITEID
group by a.SITEID,CW.DEV_WORKTYPE

)
select SiteId,DEV_WORKTYPE,Name,sum(Value) value ,(sum(Value)/cast(
(select sum(value)  from test t1 where t1.SiteId=t.SiteId and t1.DEV_WORKTYPE=t.DEV_WORKTYPE) as decimal(16,2)))*100 per,
(select sum(value)  from test t2 where t2.SiteId=t.SiteId and t2.DEV_WORKTYPE=t.DEV_WORKTYPE)  total
from test t
group by  SiteId,DEV_WORKTYPE,Name
order by siteid





select distinct DEV_WORKTYPE,CAST(sum(ACTMATCOST)AS DECIMAL(16,2))  Value,'Material' as Name 
,100*(CAST(sum(ACTMATCOST)AS DECIMAL(16,2))/1505187.06)
from [dbo].[PMO_3410012] a
LEFT JOIN [dbo].[Client_Workorder] CW ON CW.ASSETNUM=A.assetnum
left join [dbo].[Segment_Objects] s on s.assetnum=cw.assetnum
where a.StatusId in('OPERATING','Active')
and CW.SITEID='prd'AND A.SiteId='PRD'AND DEV_WORKTYPE IN ('CM','PM','RM')
and CW.Year='31-Mar-2022'
group by CW.DEV_WORKTYPE


----------------assetcount

select p.family,p.assetcount,sf.assetcount,case when p.assetcount=sf.assetcount then 1 else 0 end
from (
select  concat(assetclass,'-',MANUFACTURER,'-',MakeModel)family,count(distinct AssetNum)assetcount
from PMO_3410012
where StatusId in ('operating','active')  --and concat(assetclass,'-',MANUFACTURERID,'-',MakeModel)='HEAT0008-M000000000-H-2150-AC'
and SiteId='prd'
 and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%ANAL%') and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%INST0018%')
group by  concat(assetclass,'-',MANUFACTURER,'-',MakeModel)
)p inner join 
 AX_Segment_Metric_Facts_All sf 
 on p.family=sf.SegmentMasterDescription
 where siteid='prd'




---------------------


select concat(AssetClass,'-',MANUFACTURER,'-',MakeModel)Family,
count( case when DEV_WORKTYPE='pm' then W.WONUM end)PM_WOCnt,
isnull(sum(case when DEV_WORKTYPE='pm' then w.ACTLABHRS end),0)PM_ACTLABHRS,
isnull(sum(case when DEV_WORKTYPE='pm' then w.actmatcost end),0)+isnull(sum(case when DEV_WORKTYPE='pm' then w.ACTLABCOST end),0)PM_TOtal
,count(case when DEV_WORKTYPE in ('cm','rm') then w.WONUM end)NONPM_WOCnt,
isnull(sum(case when DEV_WORKTYPE in ('cm','rm') then w.ACTLABHRS end),0)NONPM_ACTLABHRS,
isnull(sum(case when DEV_WORKTYPE in ('cm','rm')then w.actmatcost end),0)+isnull(sum(case when DEV_WORKTYPE in ('cm','rm') then w.ACTLABCOST end),0)NONPM_TOtal
from PMO_3410012 a 
left join Client_Workorder w 
on a.AssetNum=w.ASSETNUM
LEFT JOIN Client_PM P ON P.PMNUM=W.PMNUM
LEFT JOIN Segment_Objects SO ON SO.assetnum=A.ASSETNUM
where year='31-Mar-2022' and a.IsDeleted=0
and a.StatusId in('OPERATING','Active') AND IsDeleted=0
and W.SITEID='prd'AND A.SiteId='PRD'--AND DEV_WORKTYPE IN ('CM','PM','RM')
 and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%ANAL%') and concat(assetclass,'-',Manufacturer,'-',MakeModel) not  like ('%INST0018%')
 AND concat(assetclass,'-',Manufacturer,'-',MakeModel)='UNCL-NUAIRE-NU-S425-600'
group by concat(AssetClass,'-',MANUFACTURER,'-',MakeModel)


--------------------


select c.SkillsName,sum(REGULARHRS) from Client_CRAFT_1 c left join Client_Labtrans m
on c.SkillsName=m.CRAFT
group by c.SkillsName

----------------------------

select c.SkillsName ,isnull(sum(w.ACTLABHRS),0),w.DEV_WORKTYPE
from Client_Workorder w 
left join Client_Labtrans l on w.WONUM=l.REFWO
left join Client_CRAFT_1 c on c.SkillsName=l.CRAFT
where year='31-Mar-2022' and w.SITEID='prd'and l.SITEID='prd' --and DEV_WORKTYPE='pm'
and w.STATUS='close'
group by c.SkillsName ,w.DEV_WORKTYPE



