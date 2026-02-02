use Bank_Loan_DB
select * from bank_financial_loan
/* total loan application */

select
	count(id) total_application 
from bank_financial_loan

/* MTD LOAN APPLICATION */

select
	count(id) MTD_total_application 
from bank_financial_loan
where month(issue_date)= 12

/* MOM LOAN APPLICATION */

WITH monthly_applications AS (
    SELECT
        DATEFROMPARTS(YEAR(issue_date), MONTH(issue_date), 1) AS order_month,
        COUNT(id) AS total_applications
    FROM bank_financial_loan
    WHERE issue_date IS NOT NULL
    GROUP BY DATEFROMPARTS(YEAR(issue_date), MONTH(issue_date), 1)
)
SELECT
    order_month,
    total_applications,
    total_applications 
        - LAG(total_applications) OVER (ORDER BY order_month) AS mom_change
FROM monthly_applications
ORDER BY order_month;

/* total amount funded & receved */

select 
    sum(loan_amount) total_amount_funded
from bank_financial_loan;

select 
    sum(total_payment) total_amount_receved
from bank_financial_loan;

select * from bank_financial_loan;

 /* avg int rate */ 
 
select 
    concat(
        round(
            avg(int_rate)*100,2),'%')avg_int_rate
from bank_financial_loan;

/* DTI caculation */

SELECT
    member_id,
    ROUND(
        (SUM(installment) / SUM(annual_income)) * 100
    , 2) AS DTI
FROM bank_financial_loan
GROUP BY member_id;

/* good & bad loan percentage */

select 
(count(
        case 
            when loan_status = 'fully paid' or loan_status = 'current' then id end )*100)
/
count(id) Good_loan_percentage ,

(count(
        case 
            when loan_status = 'charged off'  then id end )*100)
/
count(id) bad_loan_percentage
from bank_financial_loan;

/* with cte */

WITH loan_flags AS (
    SELECT
        CASE WHEN loan_status IN ('fully paid', 'current') THEN 1 ELSE 0 END AS is_good,
        CASE WHEN loan_status = 'charged off' THEN 1 ELSE 0 END AS is_bad
    FROM bank_financial_loan
)
SELECT
    100.0 * SUM(is_good) / COUNT(*) AS good_loan_percentage,
    100.0 * SUM(is_bad)  / COUNT(*) AS bad_loan_percentage
FROM loan_flags;

/* num of good application */

select 
count(*) good_loan_application 
from bank_financial_loan 
where loan_status = 'fully paid' or loan_status = 'current';

/* amount of good application */

select 
sum(loan_amount) good_loan_recieved
from bank_financial_loan
where loan_status in ('fully paid' , 'current');

/* num of bad application */

select 
count(*) num_of_bad_application 
from bank_financial_loan
where loan_status = 'charged off'

/* amount of bad application */

select 
sum(loan_amount)
from bank_financial_loan
where 
loan_status = 'charged off';

/* laon status summary  */

select 
    LOAN_STATUS,
    count(*) as total_application ,
    sum(total_payment) total_amount_recieved,
    sum(loan_amount) total_funded_amount,
    round(avg(int_rate * 100),2) avg_interest_rate,
    round(avg(dti*100),2) avg_DIT
FROM bank_financial_loan
GROUP BY LOAN_STATUS; 

/* summary for each month */

select 
    month(issue_date) month_num,
    datename(month,issue_date) month_name,
    count(*) total_application,
    sum(loan_amount) total_funded_amount,
    sum(total_payment) total_recived_amount
from bank_financial_loan
group by
    datename(month,issue_date),
    month(issue_date)
order by 
    month(issue_date)

/* summary for emp_lenght */

select 
    emp_length,
    count(*) total_application,
    sum(loan_amount) total_funded_amount,
    sum(total_payment) total_recived_amount
from bank_financial_loan
group by
    emp_length
order by 
    count(*)

/* summary for purpose */

select 
    purpose,
    count(*) total_application,
    sum(loan_amount) total_funded_amount,
    sum(total_payment) total_recived_amount
from bank_financial_loan
group by
    purpose
order by 
    count(*)

/* summary for homeownership */

select 
    home_ownership,
    count(*) total_application,
    sum(loan_amount) total_funded_amount,
    sum(total_payment) total_recived_amount
from bank_financial_loan
group by
    home_ownership
order by 
    count(*)













