select * from [dbo].[PMO_3410012]

select * from [dbo].[Client_Workorder]

SELECT * FROM [dbo].[AX_Asset_Metric_Facts]

SELECT * FROM [dbo].[AX_Segment_Metric_Facts]

select distinct statusid from [dbo].[PMO_3410012]

------------------------ASSET COUNT--------------
SELECT COUNT(DISTINCT AssetNum)AssetNum,SiteId FROM PMO_3410012 
GROUP  BY SiteId


SELECT COUNT(DISTINCT CMMS_Asset_ID)AssetNum,siteid FROM [dbo].[AX_Asset_Metric_Facts]
GROUP  BY siteid

-------------------------EQUIPMENT UNDER PM PROGRAM-----------------------------------------------

select count(distinct a.ASSETNUM)ASSETNUM from Client_PM a
left join Client_Workorder_HCM b on a.PMNUM=b.PMNUM and a.SITEID=b.SITEID
WHERE a.ASSETNUM IS NOT NULL and a.STATUS='ACTIVE' and a.WORKTYPE='PM' --and STORELOCSITE='HCM'
and a.SITEID='HCM' and b.SITEID='HCM'


select count(distinct b.assetnum) from PMO_3410012_HCM a left join client_pm b on a.assetnum=b.assetnum
 left join GLBL_1010009_Department_HCM gl on a.departmentid=gl.id
where a.siteid='HCM' and b.siteid='HCM' and a.StatusId='A-ACTIVE' --and a.WORKTYPE='PM'
and b.ASSETNUM IS NOT NULL and b.status='ACTIVE' and a.IsDeleted=0 
and gl.CompanyId=3




--a.WORKTYPE='PM'
select * from Client_PM


-------------------------LOCATION COUNT-----------------------------------------------

select COUNT(DISTINCT LOCATION)LOCATION,SiteId  from PMO_3410012_HCM
where statusid='A-ACTIVE'
GROUP BY SiteId 

select COUNT(DISTINCT a.LOCATION)LOCATION,a.SiteId  from PMO_3410012_HCM a
 left join [dbo].[Client_Workorder] w on a.AssetNum=w.ASSETNUMleft join Client_PM c on w.PMNUM=c.PMNUMleft join Segment_Objects s on s.ASSETNUM=a.AssetNum--LEFT JOIN GLBL_1010009_Department gl on a.departmentid=gl.idwhere a.statusid in ('A-ACTIVE','OPERATING') and A.SITEID='HCM' and w.Year='30-APR-2022'and a.IsDeleted=0 and W.SITEID='HCM'  --and gl.CompanyId=2 and  a.DepartmentId is not null --and a.Effective_Currentflag='Y' group by a.siteid--gl.departmentname,


---------------------------TOTAL PM WO COUNT----------------------------------

select   count (distinct WONUM)PM_WOCOUNT,A.SITEID from [dbo].[PMO_3410012_HCM] a left join Client_Workorder w
on a.ASSETNUM=w.ASSETNUM
where  DEV_WORKTYPE='pm' --and w.Year='30-APR-2022'and  
and a.statusid  in ('OPERATING','ACTIVE')
GROUP  BY A.SITEID


select sum(pmcount)PM_WOCOUNT,siteid from [dbo].[AX_Asset_Metric_Facts]
GROUP  BY siteid


-------------------------PM_COUNT

SELECT COUNT(DISTINCT P.PMNUM)PMNUM,A.SITEID FROM PMO_3410012 A 
LEFT JOIN Client_Workorder W ON A.AssetNum=W.ASSETNUM
LEFT JOIN Client_PM P ON P.PMNUM=W.PMNUM
GROUP BY A.SiteId

------------------------------%_PM_HOURS


SELECT SUM(CASE WHEN DEV_WORKTYPE='PM' THEN W.ACTLABHRS END )PM_ACTLABHRS,
SUM(CASE WHEN DEV_WORKTYPE IN ('CM','PM','RM') THEN W.ACTLABHRS END )TOTAL_LAB_HRS,
(SUM(CASE WHEN DEV_WORKTYPE='PM' THEN W.ACTLABHRS END )/
SUM(CASE WHEN DEV_WORKTYPE IN ('CM','PM','RM') THEN W.ACTLABHRS END ))*100 '%PM_HRS',A.SITEID
FROM PMO_3410012 A 
LEFT JOIN Client_Workorder W ON A.AssetNum=W.ASSETNUM
GROUP BY A.SITEID


---------------%_MATERIAL_COST

SELECT sum(W.ACTMATCOST)Material_Cost,a.SiteId
FROM PMO_3410012 A 
LEFT JOIN Client_Workorder W ON A.AssetNum=W.ASSETNUM
where DEV_WORKTYPE in ('CM','PM','RM') 
group by a.SITEID

-----------------------JOBPLAN_COUNT

SELECT COUNT(DISTINCT J.JPNUM)JPNUM,J.SITEID FROM
Client_Workorder w
left join Client_JOBPLAN J ON J.JPNUM=W.JPNUM
GROUP BY J.SITEID


SELECT COUNT(DISTINCT JPNUM),SITEID FROM Client_JOBPLAN
GROUP BY SITEID


----------------ASSET_COUNT_BY_CRITICALITY -Under PM----

SELECT COUNT(distinct a.AssetNum)--,ECRRanking 
FROM PMO_3410012_HCM a
 left join [dbo].[Client_Workorder] w on a.AssetNum=w.ASSETNUMleft join Client_PM c on w.PMNUM=c.PMNUMleft join Segment_Objects s on s.ASSETNUM=a.AssetNum
WHERE a.SiteId='HCM' and w.siteid='HCM' and w.DEV_WORKTYPE='PM'
and OldECRRanking=5 and w.year='30-APR-2022' and 
a.statusid='A-ACTIVE' and IsDeleted=0 

select max(OldECRRanking) from PMO_3410012_HCM

------------------------ACTIVE _MASTER_PM--------------------
SELECT * FROM MASTERPM
-----------------------PM_WITHOUT_JOBPLAN

SELECT COUNT(DISTINCT PMNUM),SITEID FROM Client_PM 
WHERE PMNUM IS NOT NULL
GROUP BY SITEID

SELECT COUNT(DISTINCT A.PMNUM) FROM PMO_3410012_HCM C LEFT  JOIN 
Client_Workorder A ON C.AssetNum=A.ASSETNUM LEFT JOIN 
Client_PM B ON A.ASSETNUM=B.ASSETNUM WHERE A.DEV_WORKTYPE='PM' 
AND A.STATUS='CLOSE' AND B.STATUS='ACTIVE' AND A.SITEID='HCM' AND C.StatusId='A-ACTIVE'
AND C.SITEID='HCM' AND C.IsDeleted=0

SELECT count(distinct case when w.DEV_WORKTYPE='pm' then p.PMNUM end )
FROM PMO_3410012_HCM A
left join Client_Workorder W ON A.AssetNum=W.ASSETNUM
LEFT JOIN Client_PM P ON W.PMNUM=P.PMNUM
left join Segment_Objects s on a.AssetNum=s.assetnum
WHERE A.StatusId='A-Active' and --w.SiteId='HCM'
--and 
--a.SiteId='hcm' 
--and
  w.Year='30-apr-2022'

  --------------------PM HOURS--------

  
SELECT count(W.ACTLABHRS)
FROM PMO_3410012_HCM A
left join Client_Workorder W ON A.AssetNum=W.ASSETNUM
LEFT JOIN Client_PM P ON W.PMNUM=P.PMNUM
left join Segment_Objects s on a.AssetNum=s.assetnum
WHERE A.StatusId='A-Active' and --w.SiteId='HCM' 
 W.DEV_WORKTYPE='PM'
--and 
AND a.SiteId='hcm' 
and
  w.Year='30-apr-2022'

  SELECT (W.ACTLABHRS)
FROM PMO_3410012_HCM A left join Client_Workorder W ON A.AssetNum=W.ASSETNUM
WHERE W.DEV_WORKTYPE='PM' AND A.SITEID='HCM' AND A.StatusId='A-Active'
AND w.Year='30-apr-2022'

---------------------------TECHNICIAN COUNT------------------------------------

SELECT COUNT(DISTINCT LABORCODE),A.SITEID FROM Client_Workorder W LEFT JOIN Client_Labtrans CL
ON W.WONUM=CL.REFWO LEFT JOIN [dbo].[PMO_3410012] a ON W.ASSETNUM=A.AssetNum
WHERE  Year='31-MAR-2022'   AND a.STATUSID IN ('ACTIVE','OPERATING')
GROUP BY A.SITEID


--------------------------JOBPLAN_REQUIRED_SPARES


SELECT  COUNT(DISTINCT JP.JPNUM),JP.SITEID
FROM Client_JOBPLAN JP 
LEFT JOIN Client_JOBMATERIAL JM
ON JP.JPNUM=JM.JPNUM
WHERE JM.ITEMNUM IS NOT NULL
GROUP BY JP.SITEID



---------------------REQUIRED DOWNTIME HRS-------------------------------------------------------


select sum (J.JPDURATION) ,W.SITEID
from [dbo].Client_Workorder W left join Client_JOBPLAN J
on W.JPNUM=J.JPNUM
where  W.DEV_WORKTYPE  in ('PM') and w.Year='31-MAR-2022'
and J.status  in ('ACTIVE','OPERATING') 
GROUP BY W.SITEID


---------------------PM_COMPLIANCE----------


SELECT COUNT(DISTINCT P.PMNUM),COUNT(W.WONUM)--)*100
FROM Client_Workorder W LEFT JOIN 
Client_PM P ON W.PMNUM=P.PMNUM
WHERE W.SITEID='PRD'



SELECT CAST((COUNT(CASE WHEN STATUS IN ('CLOSE','COMP') AND SITEID='PRD' THEN WONUM END )
/CAST((SELECT COUNT(DISTINCT PMNUM) FROM Client_PM WHERE SITEID='PRD') AS decimal(16,2)))*100 AS decimal(16,2))
,COUNT(CASE WHEN STATUS IN ('CLOSE','COMP') AND SITEID='PRD' THEN WONUM END )
FROM PMO_3410012 a left join Client_workorder
WHERE --DEV_WORKTYPE IN ('CM','PM','RM') AND 
YEAR='31-Mar-2022' and SITEID='PRD'




SELECT COUNT(DISTINCT PMNUM) FROM Client_PM WHERE SITEID='PRD'


----------------------PM_COUNT_BY_FREQUENCY




















--------------------SCHEDULED DOWNTIME-------------------------------------------------------------------------

select sum (Downtime) from [dbo].[PMO_3410012] a left join Client_Workorder w
on a.ASSETNUM=w.ASSETNUM
where  DEV_WORKTYPE in ('Pm') and w.Year='31-Jul-2021' and a.IsDeleted=0
and a.statusid  in ('A-ACTIVE') AND A.SiteId='AEP'


SELECT SUM(pmdowntime)FROM AX_Asset_Metric_Facts
WHERE YEAR='31-Jul-2021'

-------------------------MAINTENANCE COST DISTRIBUTION------------------------------------------------

select distinct DEV_WORKTYPE,CAST(sum(ACTLABCOST)AS DECIMAL(16,2)) Value,'Labor' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN Client_Workorder w  ON W.ASSETNUM=A.assetnum
where   W.SITEID='aep' AND a.StatusId='A-ACTIVE'
and W.Year='31-Jul-2021'and a.IsDeleted=0
group by W.DEV_WORKTYPE



select distinct DEV_WORKTYPE,CAST(sum(ACTMATCOST)AS DECIMAL(16,2)) Value,'MATERIAL' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN Client_Workorder w  ON W.ASSETNUM=A.assetnum
where   W.SITEID='aep'AND A.StatusId='A-ACTIVE'and a.IsDeleted=0
and W.Year='31-Jul-2021'
group by W.DEV_WORKTYPE

--------------------------FAMILY COUNT--------------------------------------------------------------
select  count(distinct concat(AssetClass,'-',MANUFACTURERID,'-',MakeModel))
from PMO_3410012 PMO 
left join [dbo].[Client_Workorder] w
ON W.ASSETNUM=PMO.ASSETNUM 
where IsDeleted = 0 and pmo.SITEID='AEP' 
and PMO.statusid='A-Active'

select count(SegmentMasterDescription) from AX_Segment_Metric_Facts

----------------------ASSET COUNT------------------------------------------


SELECT DISTINCT COUNT(ASSETNUM) FROM [dbo].[PMO_3410012]
WHERE StatusId='A-ACTIVE' AND SiteId='AEP'


select count(distinct CMMS_Asset_ID) from AX_Asset_Metric_Facts



---------------------------PM LABOR HRS BY CRAFT------------------------------------------------------
select CL.CRAFT ,SUM(CASE WHEN DEV_WORKTYPE='PM' THEN ACTLABHRS END)from  Client_Workorder w LEFT JOIN 
Client_Labtrans  CL ON W.WONUM=CL.REFWO 
LEFT JOIN [dbo].[PMO_3410012] a
on a.AssetNum =w.ASSETNUM 
WHERE A.StatusId in('A-ACTIVE')and  A.SiteId='aep' and Year='31-Jul-2021'  AND IsDeleted=0
GROUP BY CL.CRAFT


---------------------------BDM LABOR HRS BY CRAFT------------------------------------------------------

select CL.CRAFT ,SUM(CASE WHEN DEV_WORKTYPE='RM' THEN ACTLABHRS END)from  Client_Workorder w LEFT JOIN 
Client_Labtrans  CL ON W.WONUM=CL.REFWO 
LEFT JOIN [dbo].[PMO_3410012] a
on a.AssetNum =w.ASSETNUM 
WHERE A.StatusId in('A-ACTIVE')and  A.SiteId='aep' and Year='31-Jul-2021'  AND IsDeleted=0
GROUP BY CL.CRAFT


---------------------------TECHNICIAN COUNT------------------------------------

SELECT COUNT(DISTINCT LABORCODE) FROM Client_Workorder W LEFT JOIN Client_Labtrans CL
ON W.WONUM=CL.REFWO LEFT JOIN [dbo].[PMO_3410012] a ON W.ASSETNUM=A.AssetNum
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE'


-----------------------------SEGMENT WITH NO CHILD WO---------------------------------------------

select count( distinct c.SegmentMasterID) from PMO_3410012 b left join Client_Workorder a  
on a.ASSETNUM=b.AssetNum left join Segment_Objects c on c.ASSETNUM=b.AssetNum 
where b.StatusId='A-ACTIVE'  and a.SITEID='AEP' and a.PARENT is null and a.Year='31-jul-2021' and b.IsDeleted=0



-----------------------------PM LABOR HRS VS BDM LABOR HRS-----------------------------------------------------


SELECT  DISTINCT COUNT(A.AssetNum),COUNT(CASE WHEN DEV_WORKTYPE='PM' THEN WONUM END) ,
COUNT(CASE WHEN DEV_WORKTYPE='RM' THEN WONUM END) 
FROM [dbo].[PMO_3410012] A LEFT JOIN Client_Workorder W 
ON A.AssetNum=W.ASSETNUM
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE'
GROUP BY A.AssetNum


select  distinct count(a.assetnum),name, count( case when dev_worktype='pm' then wonum end) pm_count,count( case when dev_worktype='RM' then wonum end) BDM_count,
sum( case when dev_worktype='pm' then actlabhrs end)pmlabhrs,sum( case when dev_worktype='rm' then actlabhrs end)rmlabhrs,
sum(case when dev_worktype='pm' then actlabcost end) + sum(case when dev_worktype='pm' then actmatcost end) pm_total,
sum(case when dev_worktype='rm' then actlabcost end) + sum(case when dev_worktype='rm' then actmatcost end) rm_total
from
[dbo].[PMO_3410012] a
left join
client_workorder w
on
a.assetnum=w.assetnum
where w.year='31-JUL-2021'  and 
a.statusid='A-ACTIVE' and w.siteid='AEP'  and isdeleted=0 
group by a.assetnum,name



------------------------PM COST DISTRIBUTION BY SEGMENT (LABOR HRS)--------------------------------------

select count(a.family) family, (case 
when actlabhrs>0 and actlabhrs<=10 then '0-10'
when actlabhrs>10 and actlabhrs<=20 then '10-20' 
when actlabhrs>20 and actlabhrs<=30 then '20-30'
when actlabhrs>30 and actlabhrs<=40 then '30-40'
when actlabhrs>40 and actlabhrs<=60 then '40-60'
when actlabhrs>60 and actlabhrs<=150 then '60-150'
when actlabhrs>150 and actlabhrs<=310 then '150-310'
when actlabhrs>310 and actlabhrs<=2220 then '310-2220'
end) bucket_cost
from(select 
 concat(assetclass,'-',MANUFACTURERID,'-',makemodel) family, 
SUM(CASE WHEN DEV_WORKTYPE in('PM' ) THEN ACTLABHRS END) actlabhrs
from
 [dbo].[PMO_3410012] a
left join
[dbo].[Client_Workorder]  b
on a.AssetNum=b.ASSETNUM
where dev_worktype='PM' and StatusId in ('A-active') and a.SiteId='AEP' and Year='31-jul-2021' 
group by concat(assetclass,'-',MANUFACTURERID,'-',makemodel)
) a
group by (case 
when actlabhrs>0 and actlabhrs<=10 then '0-10'
when actlabhrs>10 and actlabhrs<=20 then '10-20' 
when actlabhrs>20 and actlabhrs<=30 then '20-30'
when actlabhrs>30 and actlabhrs<=40 then '30-40'
when actlabhrs>40 and actlabhrs<=60 then '40-60'
when actlabhrs>60 and actlabhrs<=150 then '60-150'
when actlabhrs>150 and actlabhrs<=310 then '150-310'
when actlabhrs>310 and actlabhrs<=2220 then '310-2220'
end)



------------------------PM COST DISTRIBUTION BY SEGMENT (COST)--------------------------------------

select count(a.family) family, (case 
when PM_TOTAL>0 and PM_TOTAL<=60 then '0-60'
when PM_TOTAL>60 and PM_TOTAL<=80 then '60-80' 
when PM_TOTAL>80 and PM_TOTAL<=190 then '80-190'
when PM_TOTAL>190 and PM_TOTAL<=310 then '190-310'
when PM_TOTAL>310 and PM_TOTAL<=510 then '310-510'
when PM_TOTAL>510 and PM_TOTAL<=810 then '510-810'
when PM_TOTAL>810 and PM_TOTAL<=1330 then '810-1330'
when PM_TOTAL>1330 and PM_TOTAL<=2080 then '1330-2080'
when PM_TOTAL>2080 and PM_TOTAL<=3800 then '2080-3800'
when PM_TOTAL>3800 and PM_TOTAL<=8540 then '3800-8540'
when PM_TOTAL>8540 and PM_TOTAL<=17270 then '8540-17270'
when PM_TOTAL>17270 and PM_TOTAL<=360040 then '17270-360040'
end) bucket_cost
from(select 
 concat(assetclass,'-',MANUFACTURERID,'-',makemodel) family, 
SUM(CASE WHEN DEV_WORKTYPE in('PM' ) THEN ACTLABCOST+SPARECOST END) PM_TOTAL
from
 [dbo].[PMO_3410012] a
left join
[dbo].[Client_Workorder]  b
on a.AssetNum=b.ASSETNUM
where dev_worktype='PM' and StatusId in ('A-active') and a.SiteId='AEP' and Year='31-jul-2021' 
group by concat(assetclass,'-',MANUFACTURERID,'-',makemodel)
) a
group by  (case 
when PM_TOTAL>0 and PM_TOTAL<=60 then '0-60'
when PM_TOTAL>60 and PM_TOTAL<=80 then '60-80' 
when PM_TOTAL>80 and PM_TOTAL<=190 then '80-190'
when PM_TOTAL>190 and PM_TOTAL<=310 then '190-310'
when PM_TOTAL>310 and PM_TOTAL<=510 then '310-510'
when PM_TOTAL>510 and PM_TOTAL<=810 then '510-810'
when PM_TOTAL>810 and PM_TOTAL<=1330 then '810-1330'
when PM_TOTAL>1330 and PM_TOTAL<=2080 then '1330-2080'
when PM_TOTAL>2080 and PM_TOTAL<=3800 then '2080-3800'
when PM_TOTAL>3800 and PM_TOTAL<=8540 then '3800-8540'
when PM_TOTAL>8540 and PM_TOTAL<=17270 then '8540-17270'
when PM_TOTAL>17270 and PM_TOTAL<=360040 then '17270-360040'
end)


--------------------CM_RM WOCNT,LABORHRS AND TOTAL COST BY SEGMENT---------------------------------------------------------------------


select distinct  count (WONUM)AS CM_RM_WOCNT,SUM(ACTLABHRS)AS CM_RM_LABORHRS ,SUM(ACTLABCOST+SPARECOST) AS CM_RM_TOTALCOST
from [dbo].[PMO_3410012]  a left join Client_Workorder w
on a.ASSETNUM=w.ASSETNUM
where  DEV_WORKTYPE IN ('Cm','RM') and w.Year='31-Jul-2021'and  
a.statusid  in ('A-ACTIVE') and a.IsDeleted=0 AND 
CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Forming\Mold-UBE MACHINERY INC-9999'



----------------------------LABOR ACCURACY BY SEGMENT--------------------------------------------------

 SELECT (sum(w.ACTLABHRS)-sum(w.ESTLABHRS))/(NULLIF(sum(w.ESTLABHRS),0)) AS 'Labor_Accuracy'
 FROM  [dbo].[PMO_3410012] A LEFT JOIN Client_Workorder W
 ON A.ASSETNUM=W.ASSETNUM
 WHERE W.Year='31-JUL-2021' AND A.StatusId='A-ACTIVE' AND A.SiteId='AEP' AND IsDeleted=0
 AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Mechanical\Not In List-Dummy Company Record USA-9999'






--------------------------------------------------------------------------------------
---------------------------DRILL DOWN QURIES--------------------------------------



---------------------TOTAL PM WO COUNT BY USING SEGMENT----------------------------
select count(w.WONUM) from [dbo].[PMO_3410012] a left join Client_Workorder w
on a.AssetNum =w.ASSETNUM
left join Segment_Objects so on a.AssetNum=so.assetnum
left join AX_Segment_Metric_Facts sm on so.SegmentMasterID=sm.SegmentMasterID
where a.StatusId in('A-ACTIVE')and  W.SITEID='aep' and W.Year='31-Jul-2021'  and DEV_WORKTYPE='pm'
and SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'
group by DEV_WORKTYPE  




------------------------ASSET COUNT FOR SEGMENT--------------------------------------

select DISTINCT count(ASSETNUM) from [dbo].[PMO_3410012] 
where StatusId in('A-ACTIVE')and  SITEID='aep'  and
concat(assetclass,'-',manufacturerid,'-',makemodel)='Forming\Mold-UBE MACHINERY INC-9999'



select sum(assetcount) from AX_Segment_Metric_Facts
where SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'


--------------------- PM LABOR HRS BY USING SEGMENT----------------------------

select SUM(w.ACTLABHRS) from [dbo].[PMO_3410012] a left join Client_Workorder w
on a.AssetNum =w.ASSETNUM 
left join Segment_Objects so on a.AssetNum=so.assetnum
left join AX_Segment_Metric_Facts sm on so.SegmentMasterID=sm.SegmentMasterID
where a.StatusId in('A-ACTIVE')and  W.SITEID='aep' and W.Year='31-Jul-2021'  and DEV_WORKTYPE='pm'
and SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'
group by DEV_WORKTYPE

SELECT SUM(pmactlabhrs) FROM AX_Segment_Metric_Facts
WHERE SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'




----------------------------SCEDULED DOWNTIME BY USING SEGMENT------------------------------------------
select SUM(CASE WHEN DEV_WORKTYPE='PM' THEN  w.DOWNTIME END) from [dbo].[PMO_3410012] a left join Client_Workorder w
on a.AssetNum =w.ASSETNUM
left join Segment_Objects so on a.AssetNum=so.assetnum
left join AX_Segment_Metric_Facts sm on so.SegmentMasterID=sm.SegmentMasterID
where a.StatusId in('A-ACTIVE')and  W.SITEID='aep' and W.Year='31-Jul-2021'  
and SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'
group by DEV_WORKTYPE

SELECT SUM(DOWNTIME) FROM [dbo].[PMO_3410012] a left join Client_Workorder w
on a.AssetNum =w.ASSETNUM
WHERE DEV_WORKTYPE='PM' AND a.StatusId in('A-ACTIVE')and  W.SITEID='aep' and W.Year='31-Jul-2021'  
AND IsDeleted=0
AND  CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Forming\Mold-UBE MACHINERY INC-9999'


SELECT SUM(pmdowntime) FROM AX_Segment_Metric_Facts
WHERE SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'

SELECT * FROM AX_Segment_Metric_Facts

-------------------------PM TECHNICIAN COUNT----------------------------------

SELECT COUNT(DISTINCT LABORCODE) FROM Client_Workorder W LEFT JOIN Client_Labtrans CL
ON W.WONUM=CL.REFWO LEFT JOIN [dbo].[PMO_3410012] a ON W.ASSETNUM=A.AssetNum
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE'
AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Forming\Mold-UBE MACHINERY INC-9999'



-------------------------TOTAL PM COST BY SEGMENT-----------------------------------

select sum(w.LABORCOST+w.SPARECOST) from  PMO_3410012 PMO 
left join [dbo].[Client_Workorder] w
ON W.ASSETNUM=PMO.ASSETNUM 
where concat(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Forming\Mold-UBE MACHINERY INC-9999'
 and W.SITEID='AEP' and w.Year='31-Jul-2021' 
 and pmo.IsDeleted=0 and DEV_WORKTYPE='pm'


SELECT SUM(pmtotal) FROM AX_Segment_Metric_Facts
WHERE SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'


------------------LABOR HRS DISTRIBUTION BY ASSET (LABOR HRS)-------------------------------------------------------------

select * from [dbo].[Heatmap_Table] h
left join [dbo].[Segment_Objects] g
on h.AssetNum = g.assetnum
where g.SegmentMasterID = '1658' and 
concat(totallabhrs_level , age_criti_downtime_level) = '55'

SELECT * FROM AX_Segment_Metric_Facts
where  SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'


------------------LABOR HRS DISTRIBUTION BY ASSET (COST)---------------------------------------------

select * from [dbo].[Heatmap_Table] h
left join [dbo].[Segment_Objects] g
on h.AssetNum = g.assetnum
where g.SegmentMasterID = '1658' and 
concat(totalCost_level , age_criti_downtime_level) = '55'

SELECT SegmentMasterID FROM AX_Segment_Metric_Facts
where  SegmentMasterDescription='Mechanical\Filtration-TRANSOR FILTER USA-9999'


-------------------------- LABOR HRS BY CRAFT------------------------------------------------------
select CL.CRAFT ,SUM(CASE WHEN DEV_WORKTYPE='PM' THEN ACTLABHRS END)from  Client_Workorder w LEFT JOIN 
Client_Labtrans  CL ON W.WONUM=CL.REFWO 
LEFT JOIN [dbo].[PMO_3410012] a
on a.AssetNum =w.ASSETNUM 
WHERE A.StatusId in('A-ACTIVE')and  A.SiteId='aep' and Year='31-Jul-2021'  AND IsDeleted=0
AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Mechanical\Fan-Dummy Company Record USA-9999'
GROUP BY CL.CRAFT


select CL.CRAFT ,SUM(CASE WHEN DEV_WORKTYPE='CM' THEN ACTLABHRS END)from  Client_Workorder w LEFT JOIN 
Client_Labtrans  CL ON W.WONUM=CL.REFWO 
LEFT JOIN [dbo].[PMO_3410012] a
on a.AssetNum =w.ASSETNUM 
WHERE A.StatusId in('A-ACTIVE')and  A.SiteId='aep' and Year='31-Jul-2021'  AND IsDeleted=0
AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Mechanical\Fan-Dummy Company Record USA-9999'
GROUP BY CL.CRAFT


select CL.CRAFT ,SUM(CASE WHEN DEV_WORKTYPE='RM' THEN ACTLABHRS END)from  Client_Workorder w LEFT JOIN 
Client_Labtrans  CL ON W.WONUM=CL.REFWO 
LEFT JOIN [dbo].[PMO_3410012] a
on a.AssetNum =w.ASSETNUM 
WHERE A.StatusId in('A-ACTIVE')and  A.SiteId='aep' and Year='31-Jul-2021'  AND IsDeleted=0
AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Mechanical\Fan-Dummy Company Record USA-9999'
GROUP BY CL.CRAFT



-------------------------MAINTENANCE COST DISTRIBUTION BY SEGMENT------------------------------------------------

select distinct DEV_WORKTYPE,CAST(sum(ACTLABCOST)AS DECIMAL(16,2)) Value,'Labor' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN Client_Workorder w  ON W.ASSETNUM=A.assetnum
where   W.SITEID='aep' AND a.StatusId='A-ACTIVE'
and W.Year='31-Jul-2021'and a.IsDeleted=0
AND CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Machining\Drill-NTC AMERICA CORP-9999'
group by W.DEV_WORKTYPE



select distinct DEV_WORKTYPE,CAST(sum(ACTMATCOST)AS DECIMAL(16,2)) Value,'MATERIAL' as Name 
from [dbo].[PMO_3410012] a
LEFT JOIN Client_Workorder w  ON W.ASSETNUM=A.assetnum
where   W.SITEID='aep'AND A.StatusId='A-ACTIVE'and a.IsDeleted=0
and W.Year='31-Jul-2021'AND
CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Machining\Drill-NTC AMERICA CORP-9999'
group by W.DEV_WORKTYPE



-----------------------PM LABOR HRS VS BDM LABOR HRS by SEGMENT (WOCOUNT)-----------------------------------------------------


SELECT  CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.Name,A.AssetNum,
COUNT(CASE WHEN DEV_WORKTYPE='PM' THEN WONUM END)AS PM_WOCNT ,
COUNT(CASE WHEN DEV_WORKTYPE='RM' THEN WONUM END) AS BDM_WOCNT
FROM [dbo].[PMO_3410012] A LEFT JOIN Client_Workorder W 
ON A.AssetNum=W.ASSETNUM 
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE' AND 
CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Machining\Drill-NTC AMERICA CORP-9999'
GROUP BY A.AssetNum,CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.NAME,A.AssetNum



-----------------------PM LABOR HRS VS BDM LABOR HRS by SEGMENT (LABOR HRS)-----------------------------------------------------


SELECT  CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.Name,A.AssetNum,
SUM(CASE WHEN DEV_WORKTYPE='PM' THEN ACTLABHRS END)AS PM_WOCNT ,
SUM(CASE WHEN DEV_WORKTYPE IN('RM','CM') THEN ACTLABHRS END) AS BDM_WOCNT
FROM [dbo].[PMO_3410012] A LEFT JOIN Client_Workorder W 
ON A.AssetNum=W.ASSETNUM 
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE' AND 
CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Machining\Drill-NTC AMERICA CORP-9999'
GROUP BY A.AssetNum,CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.NAME,A.AssetNum



-----------------------PM LABOR HRS VS BDM LABOR HRS by SEGMENT (COST)-------------------------------

SELECT  CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.Name,A.AssetNum,
SUM(CASE WHEN DEV_WORKTYPE='PM' THEN ACTLABCOST END)AS PM_WOCNT ,
SUM(CASE WHEN DEV_WORKTYPE IN('RM','CM') THEN ACTLABCOST END) AS BDM_WOCNT
FROM [dbo].[PMO_3410012] A LEFT JOIN Client_Workorder W 
ON A.AssetNum=W.ASSETNUM 
WHERE  Year='31-Jul-2021'  AND IsDeleted=0 AND a.STATUSID='A-ACTIVE'  and
CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel)='Machining\Drill-NTC AMERICA CORP-9999'
GROUP BY A.AssetNum,CONCAT(AssetClass,'-',MANUFACTURERID,'-',MakeModel),A.NAME,A.AssetNum





--------------------ASSET PM COST  DISTRIBUTION (LABOR HRS)-----------------------------------
select range_bucket RangeBucket,total Total,flag Flag
FROM  TestTable2 
where SITEID='aep' and Year='31-jul-2021' and Flag='1'



select range_bucket RangeBucket,total Total,flag Flag
FROM  TestTable2 
where SITEID='aep' and Year='31-jul-2021' and Flag='2'


-----------------------ASSET SCHEDULED DOWNTIME DISTRIBUTION  (COST)----------------------------

select range_bucket RangeBucket,total Total,flag Flag
FROM  TestTable2 
where SITEID='aep' and Year='31-jul-2021' and Flag='3'





--------------------------------------------------------------------------------------------------------

 select CLT.CRAFT,cast(sum(cw.ACTLABHRS)as decimal(16,2))LbrHrs 
 from PMO_3410012 PM12 
 left join Client_Workorder CW on PM12.AssetNum=CW.ASSETNUM
 left join Client_Labtrans CLT on CLT.REFWO=CW.WONUM
 where PM12.SITEID='AEP' and PM12.StatusId='A-ACTIVE' and CW.Year='31-JUL-2021' and 
 CW.SITEID='AEP' and CW.DEV_WORKTYPE='PM' and CLT.CRAFT is not null and PM12.IsDeleted=0
 AND  CONCAT(ASSETCLASS,'-',MANUFACTURERID,'-',MakeModel)='Forming\Mold-UBE MACHINERY INC-9999'
 group by CLT.CRAFT 


 	select CRAFT,cast(sum(CW.ACTLABHRS)as decimal(16,2))LbrHrs  
					from Segment_Objects SO  
					left join AX_Segment_Metric_Facts SMF on SMF.SegmentMasterID=so.SegmentMasterID 
					left join PMO_3410012 PM12 on PM12.AssetNum=so.assetnum
					left join Client_Workorder CW on PM12.AssetNum=CW.ASSETNUM
					left join Client_Labtrans CLT on CLT.REFWO=CW.WONUM 
					where  SMF.Year='31-JUL-2021'  and  SMF.SegmentMasterID='2774' and 
					PM12.StatusId='A-ACTIVE' and  CW.DEV_WORKTYPE='PM' and SMF.siteid='AEP' and 
					CLT.CRAFT is not null and PM12.IsDeleted=0 and PM12.SiteId='AEP'
 					group by CRAFT 


 SELECT * FROM AX_Segment_Metric_Facts
 WHERE SegmentMasterDescription='Forming\Mold-UBE MACHINERY INC-9999'




