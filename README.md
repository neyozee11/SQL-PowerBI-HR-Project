# Human Resources Employee Data Analysis

### Project Overview

This Human Resources Employee Data Analysis project aims to provide valuable insights and actionable information through the exploration and analysis of employee data within an organization, thereby empowering Human Resources professionals and decision makers within an organization with a comprehensive understanding of employee demographics, performance metrics and other key factors.

### Data Source

The main dataset employed in this data analysis project is 'Human Resources.csv,' which comprises detailed information about the organization's employees.

### Tools

- MySQL [Download here](https://dev.mysql.com/downloads/installer/) : MySQL was used to clean, prepare and analyse the data
- PowerBI [Download here](https://powerbi.microsoft.com/en-us/downloads/) : PowerBI was used to create a dashboard of reports based on the analysis

### Data Cleaning/Preparation

In the initial data preparation stage, I performed the following task;
1. Created a new database named 'project_hr' in MySQL
2. Imported the source data into the database that was created
3. Renamed the 'id' column to 'emp_id'
4. Changed the data types as appropriate as well as changing the date format of the columns with date
5. Created a new column 'age' which contains the calculated age of the employees
6. Analysed data by answering different exploratory data analysis questions as well as exporting the data acquired from the result of the analysis

### Data Visualization

Data visualization was done in PowerBI. All the exported data from MySQL were uploaded into the data model of the PowerBI and a dashboard consisting of barcharts, clustered barchats, map, table, donut chart and linechart were created.

### Exploratory Data Analysis

Some of the important questions asked during the analysis are as follows;

- What is the age distribution of employees in the company?
- What is the distribution of employees across location state?
- What is the tenure distribution in each department?

### Data Analysis

```MySQL
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

select location_state, count(*) as count
from hr
where termdate is null
group by location_state;

select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate is not null and termdate <= curdate()
group by department;
```

### Results & Recommendations

The analysis results are as summarized as follows:
- 803 people are 65 years old or older which means they are close to retiring and the company should plan to hire much more younger people to replace them.
- Ohio has the most employees which is over 25 times more than the second state in that ranking so the management should consider transfering some of the staff from ohio across other states.
- Product management department has the lowest average tenure in the company so the management might want to check why employee's tenure don't last long in the department.
    




