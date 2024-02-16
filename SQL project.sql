create Database CovidData;

use CovidData;

show tables;

select * from c19;

-- -------------Top Deaths By Region-------------------------
create view  DeathByRegion as
select 
	Who_Region as "Region", 
    sum(Cumulative_deaths)  as "Cumulative Deaths"
from c19
group by Who_Region with rollup;


select * from DeathByRegion;
set sql_safe_updates = 0;

alter table c19 rename column ï»¿Date_reported to Date_reported;

-- -------------Top Deaths By Region With Country-------------------------
create view DeathByCountry as
select 
	Who_Region as "Region", 
    Country, 
    sum(Cumulative_deaths)  as "Cumulative Deaths"
from c19
group by Who_Region,Country with rollup
order by sum(Cumulative_deaths) desc ;

select * From DethByCountry;

-- Average New Cases and Death On Date-----------
create view AverageOnDate as
select 
	year(Date_reported) as "Year",
   avg(New_cases) as "Average New Cases",
   avg(New_deaths)  as "Average New Deaths"
from c19 
group by year(Date_reported) ;

select * from AverageOnDate;



-- ------------Death Rate Over Years-----------------------------
create view DeathRate as 
SELECT 
    YEAR(Date_reported) AS year,
    SUM(Cumulative_deaths) AS total_deaths,
   ((sum(Cumulative_deaths) - LAG(SUM(Cumulative_deaths)) OVER (ORDER BY YEAR(Date_reported))) / sum(Cumulative_deaths) )* 100 as "Deth Rate"

FROM 
    c19
GROUP BY 
    YEAR(Date_reported)
ORDER BY  
    YEAR(Date_reported);
    

-- ----All Date Over a Country----
DELIMITER //
CREATE PROCEDURE DataOnCountry(IN inputCountry VARCHAR(255))
BEGIN
    SELECT 
        Country,
        Who_region,
        YEAR(Date_reported) AS Year,
        SUM(Cumulative_deaths) AS Total_Deaths,
        AVG(Cumulative_deaths) AS Average_Deaths,
        SUM(new_cases) AS New_Cases,
        AVG(new_cases) AS Average_Cases
    FROM 
        c19
    WHERE 
        country = inputCountry
    GROUP BY 
        Country, Who_region, YEAR(Date_reported);
END //

DELIMITER ;




-- --------------------------------------------------------------
-- All Views & Functions:
select * From DeathByCountry;
select * from AverageOnDate;
select * from DeathRate;

-- All Data Of Bahrain
call DataOnCountry("Bahrain");





