---
title: Making Static Sites Dynamic...Somewhat
date: 2017-02-24 20:53 UTC
tags: middleman, ruby, javascript
---

I'm kind of in love with static site generators ([Middleman](https://middlemanapp.com/) in particular). For marketing and informational sites that don't change very often, I get many of the benefits of my normal Rails framework development and deployment toolset, with a simpler, faster, and more secure final product. (It's just hard to beat static HTML.)

But there some circumstances where a static Middleman site can be really annoying to manage, because one section needs to change frequently.

For example, let's say you want to let visitors to your company's website know what industry events your company will be attending in the coming year.

First, you create a data file to store those company events, under data/events.yml:

```
 - name: Conference I
   location: Orlando, FL
   start_date: February 7, 2017
   end_date: February 9, 2017
 - name: Summit II
   location: Washington, D.C.
   start_date: March 5, 2017
   end_date: March 6, 2017
 - name: Conference II
   location: San Diego, California
   start_date: April 24, 2016
   end_date: April 26, 2016
```

You then create an events page in that reads the event data and lists out each one:

```
<h1>Upcoming Events</h1>

<% data.events.each do |event| %>
  <h3><%= event.name %></h3>

  <p>
    <%= event.location %><br>
    <%= event.start_date %> - <%= event.end_date %>
  </p>
<% end %>
```

You would rather not remove old events from that data file, because they may come in handy later, so you add a helper method to your custom helpers module that will filter out old events for you:

```
module CustomHelpers
  def upcoming_events
    data.events.reject { |event| Date.parse(event.end_date) < Date.today }
  end
end
```

And now you can call `upcoming_events`, instead of `data.events`, on your events page, like this:

```
<% upcoming_events.each do |event| %>
  <!-- event details here -->
<% end %>
```

Now, when you build or deploy the site, your event page is only going to show upcoming events.

But if you stop here, you're still going to need to redeploy your site whenever one of those events is over. Can we do anything else to improve this? Yes, with some Javascript.

First, we want to wrap each event in a `div` with an `event` class and a data attribute for the event's end date.

```
<div class="event" data-event-end-date="<%= event.end_date %>">
  <!-- event details here -->
</div>
```

Then, on page load, we'll call some Javascript to hide events with an end date before today:

```
$('.event').filter(function(index) {
  return Date.parse($(this).attr('data-event-end-date')) < new Date();
}).hide();
```

So now, whenever you build and deploy the site, the upcoming events list will be current for that day. And if an old event happens to be left up because you haven't deployed recently, Javascript will take care of hiding it for you.
