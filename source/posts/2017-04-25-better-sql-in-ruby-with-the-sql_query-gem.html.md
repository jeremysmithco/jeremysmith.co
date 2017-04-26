---
title: Better SQL in Ruby with the sql_query gem
date: 2017-04-25 23:39 UTC
tags: sql, ruby
---

I've been writing a lot of SQL lately, as evidenced by my last [couple](/posts/2017-04-01-returning-the-greater-of-two-date-fields-where-either-could-be-null) [posts](/posts/2017-03-28-handy-sql-functions-for-self-referencing-tables). I was working on a particularly long query the other day when I thought, "it would be nice I could write SQL using partials to manage duplicated logic." One quick Google search confirmed I was not the only one with that idea. The [sql_query](https://github.com/sufleR/sql_query) Ruby gem lets you write and load SQL queries using ERB templates.

I had a large `SELECT` query which had identical `CASE` logic on multiple columns. Here's a simplified example:

```
SELECT
CUSTOMER_ID AS id,
CASE
  WHEN A_HEAD = 'T' THEN 1
  ELSE 0
END AS a_head,
CASE
  WHEN B_HEAD = 'T' THEN 1
  ELSE 0
END AS b_head,
CASE
  WHEN C_HEAD = 'T' THEN 1
  ELSE 0
END AS c_head,
CASE
  WHEN D_HEAD = 'T' THEN 1
  ELSE 0
END AS d_head
FROM CUSTOMERS;
```

By using sql_query, I could move that logic into a shared partial:

```
CASE
  WHEN <%= @source %> = 'T' THEN 1
  ELSE 0
END AS <%= @destination %>
```

And then just call the partial, passing in columns names from my main query like this:

```
SELECT
CUSTOMER_ID AS id,
<%= partial 'head', source: 'A_HEAD', destination: 'a_head' %>,
<%= partial 'head', source: 'B_HEAD', destination: 'b_head' %>,
<%= partial 'head', source: 'C_HEAD', destination: 'c_head' %>,
<%= partial 'head', source: 'D_HEAD', destination: 'd_head' %>
FROM CUSTOMERS;
```

Using partials and subfolders makes it much easier to keep large SQL statements clear and organized.

Another benefit of sql_query is that I can write nicely-formatted SQL and then, when I'm ready to execute it, all my line breaks and extra whitespace are removed automatically.

```
SqlQuery.new('select_customers').execute
```
