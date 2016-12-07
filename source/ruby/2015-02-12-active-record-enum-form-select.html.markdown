---
title: Active Record enum form select
date: 2015-02-12 18:38 UTC
tags:
---

I’ve been enjoying the new <a href="http://guides.rubyonrails.org/4_1_release_notes.html#active-record-enums">Active Record enums</a> in Rails 4.1. But I haven’t found a nice way to represent the enum options in a form select. So, I wrote a couple small helper methods that I put in application_helper.rb:

```
def options_from_enum_for_select(instance, enum)
  options_for_select(enum_collection(instance, enum), instance.send(enum))
end

def enum_collection(instance, enum)
  instance.class.send(enum.to_s.pluralize).keys.to_a.map { |key| [key.humanize, key] }
end
```

Now, instead of hard-coding the enum options in the form select, I can do this:

```
<%= form.select :status, options_from_enum_for_select(@faq, :status) %>
```

Or, when I’m using <a href="https://github.com/plataformatec/simple_form">simple_form</a>, I can use this:

```
<%= form.input :status, collection: enum_collection(@faq, :status) %>
```
