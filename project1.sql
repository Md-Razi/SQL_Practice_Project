
select * from project_1.dbo.Dataset1
select * from project_1.dbo.Dataset2
use project_1


-- Number of rows in Dataset

select COUNT(*) from project_1..Dataset1
select COUNT(*) from project_1..Dataset2;

--Dataset for jharkhand and bihar

select * from Project_1..Dataset1 where state in ('Jharkhand', 'Bihar');

select * from project_1..Dataset1 where state in  ('Jharkhand','Bihar');

--population of india

select sum(population) from Dataset2

--avg growth

select avg(Growth)*100 from Dataset1

-- state avg growth
select state, avg(growth)*100 from Dataset1 group by state

-- avg sex ratio
select avg(sex_ratio) from Dataset1
select state, round(avg(sex_ratio), 0) AS STATE_SEX_RATIO from  Dataset1 group by state order by STATE_SEX_RATIO desc

-- avg literacy rate

select ROUND(avg(Literacy),2) AS INDIA_LITERACY from Dataset1
select state, ROUND(avg(literacy), 0) AS STATE_LITERACY from Dataset1 
group by state HAVING ROUND(avg(literacy), 0)> 90 order by avg(literacy) desc

-- top 3 state showing highest growth ratio
select top 3 state, AVG(growth)*100 AS 'GROWTH_RATE%' from Dataset1 group by state order by AVG(growth) desc

--bottom 3 state showing lowest sex ratio
select top 3 state, round(avg(sex_ratio),0) from Dataset1 group by state order by avg(sex_ratio) asc
---------------------------------------------------------------------------------------------------------

-- top and bottom 3 states in literacy state


drop TABLE if exists #topstates
CREATE TABLE #topstates 
(state nvarchar(225),
topstate float 
)

insert into #topstates 
select state, round(avg(literacy),0) AS AVG_LITERACY from Dataset1 group by state order by AVG_LITERACY desc

select TOP 3 state, TOPSTATE from #topstates order by topstate desc;

drop table if exists #BOTTOMSTATES
create table #bottomstates
( state nvarchar(225),
bottomstate float)

insert into #bottomstates
select state, round(avg(literacy),0) from Dataset1 group by state order by avg(literacy) asc

select top 3 state, bottomstate from #bottomstates order by bottomstate asc


select * from (select TOP 3 state, TOPSTATE from #topstates order by topstate desc) a
union 
select * from (select top 3 state, bottomstate from #bottomstates order by bottomstate asc) b
-----------------------------------------------------------------------------------------------


-- states starting with letter a or b
select distinct(state) from Dataset1 where state like 'a%' or lower(state) like 'b%';

select distinct(state) from Dataset1 where state like 'a%' or lower(state) like '%d';

select distinct(state) from Dataset1 where state like 'a%' AND lower(state) like '%S';

--total males and females

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project_1..dataset1 a inner join project_1..dataset2 b on a.district=b.district ) c) d
group by d.state;

-- joining both table
select * from Dataset1 a LEFT JOIN Dataset2 b ON a.District=b.District;

-- total literacy rate
select sum(literacy) from Dataset1

-- population in previous census
-- population vs area
select Area_km2, Population from Dataset1

--output top 3 districts from each state with highest literacy rate
select District, state, sum(literacy) As total_literacy from Dataset1 group by District, state order by sum(literacy) desc




