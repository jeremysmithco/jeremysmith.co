---
title: Handy SQL Functions For Self-Referencing Tables
date: 2017-03-28 04:26 UTC
tags: sql, netsuite
---

I have a client that uses [NetSuite](http://www.netsuite.com/), a cloud-based CRM/ERP system. NetSuite records customer information in a datbase table called (surprise!) `customers`. The table is self-referencing, so you can have `customers` with many `subcustomers` by setting the `parent_id` on the subcustomer records to the `customer_id` on the customer record. When we originally set up my client's usage of the system, we decided to make company accounts the top-level `customers` and all the individuals at each company the `subcustomers` under the customer record. Company records had certain attributes (like a company name, and details about products owned by the company) that were hidden and left blank on the individual records. And individual records had attributes (like first name, and role) that were hidden and left blank on the company record. But both would make use of other attributes (like email and whether or not the record was active). This solution wasn't ideal, but given other constraints at the time of implementation, it made the most sense.

Recently, I needed a way to extract that customer data from NetSuite with all company and individual records. But on the individual records, I needed to display the company-level attributes that were only available on their parent records. I also needed to know when any record was last modified, whether the change was on the individual or associated company record. (If I simply joined the child to the parent, I wouldn't know which last modified date would be the right one to use in my `SELECT` statement.)

Thankfully, there are two nice SQL functions that come in handy for this: [IFNULL](https://dev.mysql.com/doc/refman/5.7/en/control-flow-functions.html#function_ifnull) and [GREATEST](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#function_greatest).

`IFNULL` takes two arguments. If the first argument is not `NULL`, it will return it. Otherwise it will return the second argument. This is helpful because I can do a `LEFT OUTER JOIN` on the self-referencing table, and use `IFNULL` to join each record to it's parent record (if the parent exists) or back to itself (if it doesn't), like this:

```
SELECT * FROM customers AS c LEFT OUTER JOIN customers AS p
ON IFNULL(c.parent_id, c.customer_id) = p.customer_id;
```

That gives us all the company-level attributes on the individual records, but we still need a last modified date that accounts for changes on either the child or parent record. That's where `GREATEST` comes in. If you pass two or more arguments to the `GREATEST` function, it will return the largest argument. (Watch out, though: if any argument is `NULL` it will return `NULL`.) So, if I know that my last modified date should really be the greater of the child record's last modified and the parent record's last modified, I can use this in my `SELECT` statement:

```
SELECT GREATEST(c.last_modified_date, p.last_modified_date) ...
```

Altogether, that gives us a query that looks something like the following. We're grabbing all the individual-level attributes from the child (aliased `AS c`) and all the company-level attributes from the parent (aliased `AS p`), and getting the greatest available last modified date.

```
SELECT
c.customer_id,
c.firstname,
c.lastname,
c.email,
c.isinactive,
c.role,
p.companyname,
p.has_product,
c.create_date,
GREATEST(c.last_modified_date, p.last_modified_date)
FROM customers AS c LEFT OUTER JOIN customers AS p
ON IFNULL(c.parent_id, c.customer_id) = p.customer_id;
```
