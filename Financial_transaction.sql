--- Truy cập dữ liệu
select *
from [Data Exploration].dbo.financial_transactions

--- Data cleasing
alter table [Data Exploration].dbo.financial_transactions
add dateconvert date

update [Data Exploration].dbo.financial_transactions
set dateconvert = convert (date,date)

alter table [Data Exploration].dbo.financial_transactions
drop column date

--- Thêm cột quý và năm giao dịch
select YEAR(dbo.financial_transactions.date)
from [Data Exploration].dbo.financial_transactions
 
 alter table [Data Exploration].dbo.financial_transactions
 add Year int

 update [Data Exploration].dbo.financial_transactions
 set Year = YEAR(dbo.financial_transactions.date)

select datepart(q,date)
from [Data Exploration].dbo.financial_transactions

alter table [Data Exploration].dbo.financial_transactions
add Quarter int

update [Data Exploration].dbo.financial_transactions
set Quarter = datepart(q,date)


--- Số tiền giao dịch trong quý của từng năm
select Year, Quarter, SUM(amount) as sumquarter
from [Data Exploration].dbo.financial_transactions
group by Year, Quarter
---order by Year , Quarter 
order by sumquarter

--- Số tiền giao dịch trong năm
select Year, SUM(amount) as sumyear
from [Data Exploration].dbo.financial_transactions
group by Year
order by Year

--- Số giao dịch theo từng quý
select Year, Quarter, COUNT(transaction_id)
from [Data Exploration].dbo.financial_transactions
group by Year, Quarter
order by Year , Quarter 


--- Số giao dịch theo năm
select Year, COUNT(transaction_id)
from [Data Exploration].dbo.financial_transactions
group by Year
order by Year

--- Loại giao dịch được sử dụng nhiều nhất và thấp nhất
select type, count (transaction_id)
from [Data Exploration].dbo.financial_transactions
group by type
order by type

--- Số lần khách quay lại và số lần sử dụng từng loại dịch vụ
with comback as (
select customer_id, type, Count(type) as sumtype
from [Data Exploration].dbo.financial_transactions
group by customer_id, type
)
select *, SUM (sumtype) over (partition by customer_id order by customer_id) AS sumstrac
from comback

--- Số lượng description được sử dụng
select type, count(distinct([Data Exploration].dbo.financial_transactions.description))
from [Data Exploration].dbo.financial_transactions
group by type
