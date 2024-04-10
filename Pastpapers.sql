--List the name, address, and phone number of all mechanics, sorted in ascending order by their ages.


select m_name, address, phone
from carmechanic.m_mechanic
order by birth_date desc;


--List all the data of car owners whose name is longer than 10 characters and have an unknown address. Sort the query by their names

select *
from carmechanic.m_owner
where length(o_name) > 10 and address is null
order by o_name;

--List the identifiers of the cars (together with their repair time in days) that were repaired for more than 30 days. Sort in descending order by
--their repair time

select car.c_id,color, model_id, license_plate_number, trunc((end_date - start_date),2) as repair_days_taken
from carmechanic.m_repair reps
inner join 
    carmechanic.m_car  car 
    on reps.car_id = car.c_id
where (end_date - start_date) > 30
order by repair_days_taken desc;


--How many cars or each color are there in our database? Sort by descending number of colors

select color,count(*) as number_of_cars
from carmechanic.m_car
group by color
order by count(*) desc;

--Which cars were repaired more than 4 times? The cars should be represented by their identifiers, sorted.

select r.car_id, color, model_id, license_plate_number, count(c.c_id) occurrences
from carmechanic.m_car c
inner join carmechanic.m_repair r
            on c.c_id = r.car_id
group by r.car_id,color, model_id, license_plate_number
having count(c.c_id)> 4
order by r.car_id desc;


--What is the average cost of repairing the green cars?

select avg(repair_cost) average_cost
from carmechanic.m_car c
inner join carmechanic.m_repair r
            on c.c_id = r.car_id
where c.color = 'green';

--For each worshop where at least one mechanic from Debrecen has ever worked, determine the average salary of the mechanics from Debrecen.
--The address  of the mechanics who live in Debrecen starts with 'Debrecen'. Sort the result in descending order of average salary.


select wor.w_name workshop, trunc(avg(w.salary), 2) average_by_workshop
from carmechanic.m_works_for w
inner join carmechanic.m_mechanic m
on w.mechanic_id = m.m_id
inner join carmechanic.m_workshop wor 
on w.workshop_id = wor.w_id
where m.address like 'Debrecen%'
group by wor.w_name
order by average_by_workshop desc;



/*For each car purchased in 2006, list the name of the new owner and the license plate of the car. Sort the result in alphabetical order of the names.*/


select own.o_name owner, c.license_plate_number number_plate
from carmechanic.m_car c 
inner join carmechanic.m_owns o
on c.c_id = o.car_id
inner join carmechanic.m_owner own 
on o.owner_id = own.o_id
where to_char(date_of_buy, 'yyyy') = 2006
order by owner asc;


--List the license plate numbers of cars whose first sell price is less than average sell price of the blue cars

select c_id as car_id, license_plate_number, first_sell_price
from carmechanic.m_car
where first_sell_price < (select avg(first_sell_price) from carmechanic.m_car where color = 'blue');


--List all data of green cars having the lowest first sell price
select *
from carmechanic.m_car
where color = 'green'
order by first_sell_price
fetch first 1 row with ties;

select *
from carmechanic.m_car
where first_sell_price = 
                        (select min(first_sell_price) from carmechanic.m_car where color = 'green');


--What is the license plate number, color, and first sell price of the car with an identifier of 150?

select license_plate_number, color, first_sell_price
from carmechanic.m_car
where c_id = 150;

--List the identifier, color, and license number of the cars whose first sell price is unknown or whose license plate number ends with two zeros. Sort the list by color
--and then license number

select *
from carmechanic.m_car
where first_sell_price is null or license_plate_number like '%00'
order by color desc, license_plate_number desc;

/*List all the repairs that crossed a year boundary ie the start and end years are not the same. Sort the list by descending order of the 
repair duration*/

select *
from carmechanic.m_repair
where to_char(start_date, 'yyyy') not like to_char(end_date, 'yyyy')
order by (end_date - start_date) desc;

/*What is the difference between the highest and the lowest price to which each car was evaluated? The cars should be represented in the result by
their identifiers. Sort the list in descending order of price difference*/

select car_id, max(price)- min(price)as price_differences
from carmechanic.m_car_evaluation ev
inner join carmechanic.m_car c
on ev.car_id = c.c_id
group by car_id
order by max(price)- min(price) desc;

--Which cars were repaired for a total cost greater than 800000 and what is the total cost?

select car_id, repair_cost
from carmechanic.m_repair
where repair_cost > 80000
group by car_id, repair_cost;

--List all car evaluations with the following data:plate number, evaluation date and price by ascending order

select car_id, license_plate_number, evaluation_date, price
from carmechanic.m_car_evaluation ev
left outer join carmechanic.m_car c
on ev.car_id = c.c_id
group by car_id, license_plate_number, evaluation_date, price
order by evaluation_date asc;


--List car model names for which the average sell price of the cars of that model was greater than 5 million in 2006.

select cm_name, trunc(avg(first_sell_price), 2) as average_selling_price
from carmechanic.m_car_model mod 
inner join carmechanic.m_car c
on mod.cm_id = c.model_id and extract(year from first_sell_date) = 2006
group by cm_name
having avg(first_sell_price) > 5000000;


--List all the workshops where at least one mechanic from Eger has ever worked. Mechanics from Eger have an address beginning with Eger.
--The column name in the result should be workshop and each workshop should appear only once.

select sh.w_name workshop 
from carmechanic.m_works_for wor
inner join carmechanic.m_mechanic mec 
on mec.m_id = wor.mechanic_id
inner join carmechanic.m_workshop sh
on wor.workshop_id=sh.w_id
where mec.address like 'Eger%'
group by sh.w_name;

--List data of all car evaluations where the price is at least one million greater than the average
select car_id, to_char(evaluation_date, 'yyyy.mm.dd hh24:mi:ss') as evaluation_date, price
from carmechanic.m_car_evaluation
where price > (select avg(price)+ 1000000 from carmechanic.m_car_evaluation);

--List the licence plate number and color of cars having the highest evaluation price;

select license_plate_number, color
from carmechanic.m_car_evaluation ev 
inner join carmechanic.m_car c 
on ev.car_id=c.c_id
order by price desc
fetch first 1 row with ties;

--List all data of car evaluations where the price was less than 500 000 Sort the result in ascending order of evaluation dates

select car_id, to_char(evaluation_date, 'yyyy.mm.dd hh24:mi:ss') as evaluation_date, price
from carmechanic.m_car_evaluation
where price < 500000
order by evaluation_date asc;

--List car brands whose names consist of least one space or hyphen in alphabetic order 

select * 
from carmechanic.m_car_make
where regexp_count(brand, '-', 1) >= 1 or regexp_count(brand, ' ', 1) >=1
order by brand asc;

select * 
from carmechanic.m_car_make
where regexp_count(brand, 'a', 1, 'i') = 2
order by brand asc;

--List the start dates of employments as well as the salary of employees who have been employed for 5 years and their contracts have not ended

select m_name,to_char(start_of_employment, 'yyyy.mm.dd hh24:mi:ss') as start_date, salary, round(months_between(sysdate, start_of_employment)/12, 2) as experience
from carmechanic.m_works_for wor
inner join carmechanic.m_mechanic mec
on wor.mechanic_id=mec.m_id
where months_between(sysdate, start_of_employment)/12 >= 5 and end_of_employment is null;


--What is the total repair cost for each car?

select car_id, sum(repair_cost) as repair_cost
from carmechanic.m_repair
group by car_id
order by repair_cost asc nulls last;

--Which mechanic's highest salary was no more than 200000?
select m_name as mechanic, mechanic_id, sum(salary) as total_salary
from carmechanic.m_works_for w
inner join carmechanic.m_mechanic m
on w.mechanic_id = m.m_id
group by mechanic_id, m_name
having sum(salary) <= 200000;

--What is the total repair cost of the car plate number ABC201

select c_id as car_id, sum(repair_cost) as total_cost
from carmechanic.m_car c
inner join carmechanic.m_repair r
on c.c_id = r.car_id
where license_plate_number = 'ABC201'
group by c_id;

--List the average repair cost of cars of each model where this average repair cost exceeds 100000.

select model_id, trunc(avg(repair_cost), 2) as average_cost
from carmechanic.m_car c
inner join carmechanic.m_repair r
on c.c_id = r.car_id
group by model_id
having avg(repair_cost) > 100000
order by average_cost asc nulls last;

--Which cars were repaired in the shop called 'Kobela Bt' the cars should be represented in the result by their license plate each only once, alphabetically

select distinct(license_plate_number)
from carmechanic.m_car 
where c_id in (select car_id 
                    from carmechanic.m_repair r
                    where workshop_id in (select w_id 
                    from carmechanic.m_workshop w
                    where w_name = 'Kobela Bt.'
                    ))
order by license_plate_number;

--List the license plate numbers of the cars whose first sell price is greater than the average first sell price of the blue cars
select c_id as car_id, license_plate_number
from carmechanic.m_car
where first_sell_price > (select avg(first_sell_price) from carmechanic.m_car
                            group by color
                            having color = 'blue')
order by license_plate_number;

--List the plate number and colors of cars that had the earliest evaluation.

select car_id, license_plate_number, color
from carmechanic.m_car_evaluation e
inner join carmechanic.m_car c
on e.car_id=c.c_id
order by evaluation_date asc
fetch first 1 row with ties;

--List data for all the cars that have never been evaluated

select c_id, color, to_char(first_sell_date, 'yyyy.mm.dd hh24:mi:ss') as first_sell_date, model_id, license_plate_number
from carmechanic.m_car 
where c_id not in (select car_id from carmechanic.m_car_evaluation)
order by c_id;


--List the identifiers of the cars (together with their repair time in days) that were repaired for more than 30 days. Sort in descending order by
--their repair time

select car.c_id,color, model_id, license_plate_number, trunc((end_date - start_date),2) as repair_days_taken
from carmechanic.m_repair reps
inner join 
    carmechanic.m_car  car 
    on reps.car_id = car.c_id
where (end_date - start_date) > 30
order by repair_days_taken desc;


--List the name of car owners whose name has at exactly 2 e's
select *
from carmechanic.m_owner 
where regexp_count(o_name, 'e', 1, 'i') = 2;

