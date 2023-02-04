##Create table to join retail and tickets data 
create table rockets_insights as
select 
t.transaction_id,
t.account_no,
t.email,
t.zip, 
t.phone_no,
t.section,
t.row,
t.qty as ticket_qty,
t.total_price,
t.event_id,
t.channel,
r.product_type,
r.quantity as retail_qty,
r.unit_price,
r.shipping_cost
from tickets t
inner join retail r on t.transaction_id = r.transaction_id
;
##Join survey data to create insights database table
create table rockets_faninsights as
select 
h.transaction_id,
h.account_no,
h.email,
h.zip, 
h.phone_no,
h.section,
h.row as ticket_row,
h.ticket_qty,
h.total_price,
h.event_id,
h.channel,
h.product_type,
h.retail_qty,
h.unit_price,
h.shipping_cost,
s.question,
s.response
from survey s
inner join rockets_insights h on h.transaction_id = s.transaction_id
;

##Create Calc field variables 
##Number of Survey Responses
select count(response) as "Total Survey Responses" from rockets_fansinsights
;
##Average ticket price per fan 
select avg(total_price) as "average ticket price" from rockets_fansinsights
;
##Fan total spend
select distinct account_no, sum(total_price) + sum(unit_price) as "total_spend" from rockets_fansinsights
group by account_no
;
#Number of Ticket transactions
select count(ticket_qty) as "Total Tickets" from rockets_fansinsights
;

#Number of retail transactions
select count(retail_qty) as "Total Retail items" from rockets_fansinsights
;


#Create table to include added calculated fields for each account number
create table hrkts_insights as
select 
transaction_id,
account_no,
email,
zip, 
phone_no,
section,
ticket_row,
ticket_qty,
total_price,
event_id,
channel,
product_type,
retail_qty,
unit_price,
shipping_cost,
question,
response,
count(response) as total_survey_responses,
count(ticket_qty) as total_tickets,
count(retail_qty) as total_retail_items,
sum(ticket_qty) + sum(retail_qty) as total_pos_qty,
avg(total_price) as avg_ticket_price,
sum(total_price) + sum(unit_price) as total_spend,
avg(shipping_cost) as avg_shipping_cost
from rockets_faninsights
group by transaction_id,
account_no,
email,
zip, 
phone_no,
section,
ticket_row,
ticket_qty,
total_price,
event_id,
channel,
product_type,
retail_qty,
unit_price,
shipping_cost,
question,
response
;
 