create database Bank_Analytics;
select * from finance_1;
select * from finance_2;

# Creating tables with feilds to import table data
CREATE TABLE finance_1 (
    id INT PRIMARY KEY,
    member_id INT,
    loan_amnt int,
    funded_amnt int,
    funded_amnt_inv double,
    term text,
    int_rate text,
    installment double,
    grade text,
    sub_grade text,
    emp_length text,
    home_ownership text,
    annual_inc Double,
    verification_status text,
    issue_d date,
    loan_status text,
    purpose text,
    zip_code TEXT,
    addr_state text,
    dti decimal(10,4)
   );

CREATE TABLE finance_2(
    id INT PRIMARY KEY,
    delinq_2yrs INT,
    earliest_cr_line DATE,
    inq_last_6mths INT,
    mths_since_last_delinq text,
    mths_since_last_record text,
    open_acc INT,
    pub_rec INT,
    revol_bal DECIMAL(15, 2),
    revol_util DECIMAL(5, 2),
    total_acc INT,
    out_prncp DECIMAL(15, 2),
    out_prncp_inv DECIMAL(15, 2),
    total_pymnt DECIMAL(15, 2),
    total_pymnt_inv DECIMAL(15, 2),
    total_rec_prncp DECIMAL(15, 2),
    total_rec_int DECIMAL(15, 2),
    total_rec_late_fee DECIMAL(15, 2),
    recoveries DECIMAL(15, 2),
    collection_recovery_fee DECIMAL(15, 2),
    last_pymnt_d DATE,
    last_pymnt_amnt DECIMAL(15, 2),
    next_pymnt_d text,
    last_credit_pull_d DATE
);


# KPI - 1
#Year wise loan amount Stats
SELECT 
    YEAR(issue_d) AS Years,
    CONCAT(ROUND((SUM(loan_amnt) / 1000000), 2),
            ' ','M') AS Total_sales_in_M
FROM finance_1
GROUP BY YEAR(issue_d)
ORDER BY years;


# KPI -2
# Grade and Subgrade wise Revolving Balance
select grade as Grade, sub_grade as Sub_Grade, CONCAT(ROUND((SUM(revol_bal) / 1000000), 2),
            ' ','M') AS total_revol_bal
from finance_1 inner join finance_2
on(finance_1.id = finance_2.id)
group by grade, sub_grade
order by grade, sub_grade;

# KPI - 3
# Verified and Non verified Total payments
select verification_status as Verification_Status, concat("$",format(round(sum(total_pymnt)/1000000,2),2)," ","M") as Total_Payment 
from finance_1 inner join finance_2
on(finance_1.id = finance_2.id)
group by verification_status;

# KPI - 4
#State wise loan status 
select addr_state as State, loan_status as Loan_Status, count(finance_1.id) as No_of_Loans 
from finance_1 
group by addr_state, loan_status
Order by addr_state;

# KPI - 5 
# Month wise loan status 
select monthname(finance_2.last_pymnt_d) pay_month, count(finance_1.loan_status) as loan_status
from finance_1 join finance_2 
on(finance_1.id = finance_2.id)
group by pay_month
order by loan_status;


# KPI - 6 
# Home Ownership Vs last payment date stats
SELECT 
    finance_1.home_ownership,
    MONTHNAME(finance_2.last_pymnt_d) AS month_name,
    YEAR(finance_2.last_pymnt_d) AS year,
    COUNT(*) AS number_of_loans,
    AVG(finance_2.total_pymnt) AS average_total_payment,
    SUM(finance_2.total_pymnt) AS total_payment
FROM 
    finance_1 join finance_2 on finance_1.id=finance_2.id
GROUP BY 
    finance_1.home_ownership,
    YEAR(finance_2.last_pymnt_d),
    MONTHname(finance_2.last_pymnt_d)
ORDER BY 
    home_ownership,
    YEAR(finance_2.last_pymnt_d),
    MONTHNAME(finance_2.last_pymnt_d);

# KPI - 7
# Purpose vs Total loan amount
select purpose,
concat("$",format(round(sum(loan_amnt)/1000000,2),2)," ","M")
as Total_Loan_Amount from finance_1
group by purpose;
