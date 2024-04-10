--List the books whose title contains at least one 'n'

select book_id, title, topic, price
from book_library.books
where title like '%n%n%n%n%';

--List the books whose title has n as their second letter.

select book_id, title, topic, price
from book_library.books
where title like '_n%';

/*
% is a wildcard symbol used in the like operator
% represents 0, 1 or multiple characters in a specified position in a string
%n represents a string ending in 'n'
n% represents a string starting with 'n'
%n% represents a string with n anywhere within it
%n%n%n% represents a string with at least three n's.
*/

--List the books whose topic is thriller that have less than 400 pages. Sort the list by number of pages.

select book_id, title, topic, number_of_pages 
from book_library.books
where topic = 'Thriller' and 
number_of_pages < 400
order by number_of_pages;


--List the books whose title's third character is not an 'a'

select *
from book_library.books
where title not like '__a%';

--List the title of the books, add a second column which has the value 1 and a third one which has the value 'a'

select title, 1, 'a', to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss')
from book_library.books;

--Concatenate the words apple and banana to one string => apple banana

select concat(concat('apple', ' '), 'banana') as fruits
from dual;

--List the address of the customers. In the first column as it is in the database, in the second column in lowercase and in the third column in upper case

select address, lower(address), upper(address)
from book_library.customers;


--List the address of the customers, and a substring of the address starting from the third to the 7th character

select address, substr(address, 3,5)
from book_library.customers;


--Replace str with **** from the customers' table
--replace(string, string to replace, replacement)
select address, replace(address,'Str','******')
from book_library.customers;


--instr keyword is used to show the position of a certain string in the table
--instr(string, 'string whose position is being looked for')
select address, instr(address, 'Str')
from book_library.customers;

--List the address of the customers and in the second column, the city only

select address, substr(address, instr(address, ', ')+2) as city
from book_library.customers;


--List the topics of the books and in the second column, list the topics again but if the topic is null, list '*****' instead of null
--nvl stands for null value locator and used to handle cases where null may be encountered and provide an alternative.d

select topic, nvl(topic, '******')
from book_library.books;

--List the gender of the customers. In the second column, write male if man and female if woman.
select first_name|| ' ' ||last_name as name, gender, upper(decode(gender, 'm', 'male', 'f', 'female')) as gender_2
from book_library.customers;

--Print out the date two months from now

select to_char(add_months(sysdate,2), 'yyyy.mm.dd hh24:mi:ss') as two_months_from_now
from dual;


--How many years has it been since 1st January 2000?
--months_between(date1, date2) where date1-date2

select round(months_between(sysdate, to_date('2001.05.01', 'yyyy.mm.dd'))/12, 0) as years
from dual;

--What is gonna be the date three years from now?

select to_char(add_months(sysdate, 3*12), 'yyyy.mm.dd hh24:mi:ss') as three_years_from_now
from dual;

--What is gonna be the date three days from now?

select to_char(sysdate+3, 'yyyy.mm.dd hh24:mi:ss') as three_days_from_now
from dual;

--What is gonna be the time three hours from now?

select to_char(sysdate+3/24, 'yyyy.mm.dd hh24:mi:ss') as three_hours_from_now
from dual;

--List the name, birthdate, and age of customers who are less than 30 years old

select first_name||' ' ||last_name as customers, to_char(birth_date, 'yyyy.mm.dd hh24:mi:ss') as birthday, trunc(months_between(sysdate, birth_date)/12, 2) as age
from book_library.customers
where trunc(months_between(sysdate, birth_date)/12, 2) < 30
order by birthday;




--List the title, book_id, and publishing date of the books whose price is not given.

select book_id, title, to_char(publishing_date, 'yyyy.mm.dd') as published, price
from book_library.books
where price is null
order by publishing_date desc, title;

--List the author id,name, birthdate, and age of the authors who were born before 2nd January 1990. Sort the list by age in reverse order


select author_id, first_name||' ' ||last_name as authors, to_char(birth_date, 'yyyy.mm.dd') as birthday, trunc(months_between(sysdate, birth_date)/12, 2) as age
from book_library.authors
where birth_date < to_date('1990.01.02', 'yyyy.mm.dd')
order by age desc;

--What is the name of the author whose name contains punctually 2 e's

select first_name||' ' ||last_name as authors
from book_library.authors
where regexp_count(first_name||' ' ||last_name,'e', 1, 'i')=2;


select first_name||' ' ||last_name as authors
from book_library.authors
where lower(first_name||' ' ||last_name) like '%e%e%'
and lower(first_name||' ' ||last_name) like '%e%e%e';