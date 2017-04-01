---
title: Returning The Greater of Two Date Fields, Where Either Could Be NULL
date: 2017-04-01 14:05 UTC
tags: sql
---

In keeping with SQL tricks I [wrote about a few days ago](/posts/2017-03-28-handy-sql-functions-for-self-referencing-tables/), here's another technique that I've found useful recently.

Let's say you want to return the greater of two date fields in your result set. If you know that both fields will contain a date, then you can simply use the [GREATEST function](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#function_greatest). `GREATEST` will return the largest of your argument. However, if either field could be `NULL`, then `GREATEST` won't work -- it will return `NULL` if any of the arguments passed to it are `NULL`.

I recently needed a query to return the greater of two date fields, but either could be `NULL`. If one was `NULL`, I wanted to return the non-`NULL` field. And if both were `NULL`, that's the only time I wanted to return `NULL`. I was able to accomplish this by combining `GREATEST` with [COALESCE](https://dev.mysql.com/doc/refman/5.7/en/comparison-operators.html#function_coalesce) and [NULLIF](https://dev.mysql.com/doc/refman/5.7/en/control-flow-functions.html#function_nullif), and the idea of a zero date.

The `COALESCE` function returns the first non-`NULL` argument passed to it. I could use this to provide a default date if one of my fields was `NULL`, like this.

```
COALESCE(date, '0000-00-00')
```

The default date I passed as my second argument is the zero date. In MySQL, the zero date is defined as '0000-00-00'. And even though this date is not a valid date, it can be used in date comparisons, which is all I need it for in this case.

At this point, I can use `COALESCE` to default any `NULL` values to the zero date, and then use `GREATEST` to get the greater of my two date fields.

```
GREATEST(
  COALESCE(date1, '0000-00-00'),
  COALESCE(date2, '0000-00-00')
)
```

But if both fields are zero dates, then `GREATEST` will return the zero date, which is invalid and can't be saved. This is where I turn to `NULLIF`. The `NULLIF` function takes two arguments. If the first argument equals the second, it will return `NULL`. If `date` if `NULL` then following will return `NULL`:

```
NULLIF(COALESCE(date, '0000-00-00'), '0000-00-00')
```

Now, I can combine all these techniques into one evaluation. Working from the inside out, if either of my date fields is `NULL`, return the zero date. Then compare the two and return the greatest date. Then, if the returned date happens to be the zero date, then return `NULL`.

```
NULLIF(
  GREATEST(
    COALESCE(date1, '0000-00-00'),
    COALESCE(date2, '0000-00-00')
  ),
  '0000-00-00'
) AS date
```

