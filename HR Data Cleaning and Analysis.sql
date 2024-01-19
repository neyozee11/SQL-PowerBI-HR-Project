create database project_hr;
use project_hr;

select * from hr;

-- date cleaning and preprocessing--
-- change of id column name, change of data format and data type of birthdate column-- 

alter table hr
change column ï»¿id emp_id varchar(20) null;

describe hr;

update hr
set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;
    
alter table hr
modify column birthdate date;

-- change the data format and data type of hire_date column--

update hr
set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
    end;
    
alter table hr
modify column hire_date date;

-- change the data format and data type of termdate column--

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate != '';

update hr
set termdate = null
where termdate = '';

-- create age column--

alter table hr
add column age int;

update hr
set age = timestampdiff(year, birthdate, curdate());

select min(age), max(age) from hr;

-- 1. what is the gender breakdown of employees in the company--

select * from hr;

select gender, count(*) as count
from hr
where termdate is null
group by gender;

-- 2. what is the race breakdown of employees in the company--

select race, count(*) as count
from hr
where termdate is null
group by race;

-- 3. what is the age distribution of employees in the company--

select
	case
		when age >= 18 and age <= 24 then '18-24'
        when age >= 25 and age <= 34 then '25-34'
		when age >= 35 and age <= 44 then '35-44'
		when age >= 45 and age <= 54 then '45-54'
		when age >= 55 and age <= 64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
    from hr
    where termdate is null
    group by age_group
    order by age_group;
    
    -- 4. how many employees work at hq vs remote--
    
select location, count(*) as count
from hr
where termdate is null
group by location;

-- 5. what is the average length of employment who have been terminated--

select round(avg(year(termdate) - year(hire_date)), 0) as length_of_emp
from hr
where termdate is not null and termdate <= curdate();

-- 6. how does the gender distribution vary across dept. job titles and age group--

select * from hr;

select department, jobtitle, gender, count(*)  as count
from hr
where termdate is null
group by department, jobtitle, gender
order by department, jobtitle, gender;

select department, gender, count(*)  as count
from hr
where termdate is null
group by department, gender
order by department, gender;

select gender,
	case
		when age >= 18 and age <= 24 then '18-24'
        when age >= 25 and age <= 34 then '25-34'
		when age >= 35 and age <= 44 then '35-44'
		when age >= 45 and age <= 54 then '45-54'
		when age >= 55 and age <= 64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
    from hr
    where termdate is null
    group by gender, age_group
    order by age_group;

-- 7. what is the distribution of job titles across the company--

select jobtitle, count(*) as count
from hr
where termdate is null
group by jobtitle;

-- 8. which department has the highest turnover rate--

select * from hr;

select department,
	count(*) as total_count,
    count(case
		when termdate is not null and termdate <= curdate() then 1
        end) as terminated_count,
	round((count(case
				when termdate is not null and termdate <= curdate() then 1
                end)/count(*)),2) as termination_rate
	from hr
    group by department
    order by termination_rate desc;

-- 9. What is the distribution of employees across location state--

select location_state, count(*) as count
from hr
where termdate is null
group by location_state;

select location_city, count(*) as count
from hr
where termdate is null
group by location_city;

-- 10. how has the company's employee count over time based on hire and termination date--

select year,
	hires,
    terminations,
    hires-terminations as net_change,
    (terminations/hires)*100 as change_percent
from(
		select year(hire_date) as year,
        count(*) as hires,
        sum(case
				when termdate is not null and termdate <= curdate() then 1
			end) as terminations
		from hr
        group by year(hire_date)) as subquery
group by year
order by year;

-- 11. what is the tenure distribution in each department--

select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate is not null and termdate <= curdate()
group by department;