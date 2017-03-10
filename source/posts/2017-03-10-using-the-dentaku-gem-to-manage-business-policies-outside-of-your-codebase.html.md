---
title: Using the Dentaku Gem to Manage Business Policies Outside of Your Codebase
date: 2017-03-10 22:10 UTC
tags: ruby, rails
---

I was reading [The Pragmatic Programmer](https://pragprog.com/book/tpp/the-pragmatic-programmer) recently, and was struck by something I hadn't considered before.

> Be sure not to confuse requirements that are fixed, inviolate laws with those that are merely policies that might change with a new management regime. That's why we use the term semantic invariants—it must be central to the very meaning of a thing, and not subject to the whims of policy (which is what more dynamic business rules are for).

Business requirements and business policies are not the same thing. *Requirements* shouldn't change, and they are best implemented in code (the business logic). But *policies* are more flexible, they may need to change over time, and they are better implemented as configuration.

> Because business policy and rules are more likely to change than any other aspect of the project, it makes sense to maintain them in a very flexible format… Maybe you are writing a system with horrendous workflow requirements. Actions start and stop according to complex (and changing) business rules. Consider encoding them in some kind of rule-based (or expert) system, embedded within your application. That way, you'll configure it by writing rules, not cutting code.

This was fresh in my mind when I started a new Rails project to integrate a client's backend customer management system with an email sending service. The application needed to determine what email lists a customer should be on, based on attributes found on their customer record (e.g. "add customer to announcements list about product X if their customer record shows they have purchased product X"). These subscription rules are current policy decisions that may change over time. Rather than implementing these rules in the codebase, I decided I would look for a way to store the rules in the database, connected to the list for which the rules applied. This way, the rules could be changed without having to update and redeploy the application. And the rules could be versioned, to provide documentation to users on how the rules may have changed over time.

I wasn't sure how to go about this, but I stumbled onto a very interesting gem, called [dentaku](https://github.com/rubysolo/dentaku) that seemed perfect for this use case:

> Dentaku is a parser and evaluator for a mathematical and logical formula language that allows run-time binding of values to variables referenced in the formulas. It is intended to safely evaluate untrusted expressions without opening security holes.

Here's a pared-down example of how I ended up using it.

First, I created List, Contact and Subscription models.

Lists have subscriptions and hold the subscription rules.

```
class List < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true, uniqueness: true
end
```

Contacts represent individual customer emails and various attributes associated with that customer, stored in `:fields` as a hash.

```
class Contact < ApplicationRecord
  serialize :fields, Hash

  has_many :subscriptions

  validates :email, presence: true, uniqueness: true
end
```

Subscriptions associate a contact with a list.

```
class Subscription < ApplicationRecord
  belongs_to :list
  belongs_to :contact

  validates :list, presence: true
  validates :contact, presence: true, uniqueness: { scope: :list_id }
end
```

Then, I created a service object to subscribe a contact to a list if it passes the list's subscription rules.

```
class SubscribeContact
  def initialize(list, contact)
    @list = list
    @contact = contact
  end

  def subscribe
    return false unless passes_subscription_rules?
    Subscription.create(list: list, contact: contact)
  end

  private

  attr_reader :list, :contact

  def passes_subscription_rules?
    calculator.store(contact.fields)
    calculator.evaluate(list.subscription_rules)
  end

  def calculator
    @calculator ||= Dentaku::Calculator.new
  end
end
```

Now, I can create a list with subscription rules (in this case, where a customer must have `status` set to `'active'` and `product_x` set to `1` to be subscribed).

```
List.create(name: "Product X Announcements", subscription_rules: "status = 'active' AND product_x = 1")
```

I can then create a test contact that meets those criteria.

```
Contact.create(email: "test@domain.com", fields: { status: "active", product_x: 1 })
```

And when I call the `SubscribeContact` service, it will evaluate the rules for that contact and create a subscription when it passes.

```
SubscribeContact.new(list, contact).subscribe
```

