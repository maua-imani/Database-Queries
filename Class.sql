--List the book item ids of the books that were borrowed by a customer. List should contain customer name and borrowing date, sort by desc borrowing date

select cu.last_name|| ' ' || cu.first_name, to_char(bor.borrowing_date, 'yyy.mm.dd hh24:mi:ss')
from book_library.borrowing bor inner join
book_library.book_items it on bor.book_item_id = it.book_item_id
inner join book_library.customers cu on cu.library_card_number = bor.customer_id
order by borrowing_date desc;

--List all books (id, title) published by Pocket Books and the names and ids of the authors if they exist


select bo.book_id, bo.title, au.author_id, au.first_name || ' ' || au.last_name
from book_library.books bo left outer join
book_library.writing w on bo.book_id = w.book_id 
left outer join book_library.authors au on au.author_id = w.author_id
where publisher like 'Pocket Books%'; --where publisher = 'Pocket Books'

--How many books belong to each topic?
select count(book_id), topic
from book_library.books
group by topic
order by count(book_id) desc;

--which publisher has more than 2 books? sort the list by the publisher name.

select count(book_id), publisher 
from book_library.books
group by publisher
having count(book_id) > 2
order by publisher;



-- which author wrote more than 2 books? Sort the list by number of books

select count(bo.book_id), au.last_name || ' ' || au.last_name
from book_library.books bo left outer join
book_library.writing w on w.book_id=bo.book_id
left outer join book_library.authors au on au.author_id=w.author_id
group by au.author_id, first_name, last_name
having count(bo.book_id) > 2
order by count(bo.book_id);

-- which author wrote less than 2 books? Sort the list by number of books

select count(bo.book_id), au.last_name || ' ' || au.last_name
from book_library.books bo left outer join
book_library.writing w on w.book_id=bo.book_id
left outer join book_library.authors au on au.author_id=w.author_id
group by au.author_id, first_name, last_name
having count(bo.book_id) < 2
order by count(bo.book_id);

--How many book_items belong to each book

select bo.book_id, title, count(it.book_item_id)
from book_library.books bo left outer join
book_library.book_items it on bo.book_id = it.book_id
group by bo.book_id, title
order by title;


--List the authors who did not write any books. Sort the list by names

select *
from book_library.authors 
where author_id not in (select author_id from book_library.writing)
order by first_name, last_name;

--List the books whose number of pages is more than 80% of the average of the number of pages of all books

select *
from book_library.books
where number_of_pages > (select 0.8 * avg(number_of_pages)
                                        from book_library.books)
order by number_of_pages;


--select the names of the authors whose names contain punctually two 'e' (lower or upper case), sort the list by name;

select first_name, last_name
from book_library.authors
where lower(first_name || '  '|| last_name) like '%e%e%'
and lower(first_name || '  '|| last_name) not like '%e%e%e%'
order by first_name, last_name;


--List the books that were published in the last ten years. Sort by publishing date, descending.

select book_id, title, to_char(publishing_date, 'yyyy.mm.dd hh24:mi:ss')
from book_library.books
where months_between(sysdate, publishing_date)/12 <10
order by publishing_date desc;


--List the books whose price is not given or which topic is not 'Science', 'Thriller', and 'History' 
--or the having between 100 and 1000 pages. The list should be sorted by publisher, title.

select book_id, publisher, price, topic, number_of_pages, title
from book_library. books
where price is null or
topic not in ('Science', 'Thriller', 'History')
or number_of_pages between 100 and 1000
order by publisher, title;


--List the days of the week on which more than 3  books were published. The list should be sorted by days of the week.

select  to_char(publishing_date, 'day') as day_of_week, count(*)
from book_library.books
group by to_char(publishing_date, 'day'), to_char(publishing_date, 'd')
having count(*) > 3
order by to_char(publishing_date, 'd');




--List the books which the title contains at least one n

select *
from book_library.books;


