---
title: A Reusable SJR Approach in Rails
date: 2017-02-22 02:29 UTC
tags: ruby, rails
---

I was recently working on a Rails client project where certain pages needed to display various record types and each collection of records needed to be listed on the page, and needed to be editable in-place. So for example, let's say a company had associated contacts, products, and locations. On the company page, each set of associated records needed to be listed on the page and needed to be editable in list view, without leaving the page.

![contacts](/assets/images/blog/sjr_approach_contacts.gif)

I was using SJR ([Server-generated Javascript Responses](https://signalvnoise.com/posts/3697-server-generated-javascript-responses)) to create, edit and delete the associated records, and realized that I could DRY my code and simplify my application by creating a common approach to displaying records on the page and rendering the same JS responses for all standard controller actions.

Wherever I had a collection of records, I wrapped the collection in a div with a class named after the plural form of the model. In my case, the list views were table-like, so I would render a partial with a "header" with the column labels. Then I would render the collection using a standard instance partial. (For contacts, it would be located at `contacts/_contact.html.erb`.)

```
<div class="contacts">
  <%= render partial: "contacts/header" %>
  <%= render collection: @contacts, partial: "contacts/contact" %>
</div>
```

This `contacts/_header.html.erb` partial is not necessary, but it useful if you need column labels, as I did.

```
<div class="header">
  <div class="row">
    <div class="col-md-4">
      Name
    </div>

    <div class="col-md-3">
      Phone
    </div>

    <div class="col-md-3">
      Email
    </div>
  </div>
</div>
```

The individual contact partial, `contacts/_contact.html.erb`, is a `div_for` block. The last column holds an Edit link (with `remote: true`, which will request the JS response).

```
<%= div_for(contact) do %>
  <div class="row">
    <div class="col-md-4">
      <%= contact.name %>
    </div>

    <div class="col-md-3">
      <%= contact.email %>
    </div>

    <div class="col-md-3">
      <%= contact.phone %>
    </div>

    <div class="col-md-2">
      <%= link_to "Edit", [:edit, contact], remote: true, class: "btn btn-link btn-sm" %>
    </div>
  </div>
<% end %>
```

The form partial, `contacts/_form.html.erb`, for the contact is also inside a `div_for` block, and it's layout mirrors the contact partial. The last column holds the submit, cancel and delete buttons. The form, as well as the cancel and delete buttons, are all set to `remote: true`. The cancel button will either call the show action if it already exists, or will render the index action if it doesn't.

```
<%= div_for(contact) do %>
  <%= simple_form_for(contact, remote: true) do |f| %>
    <%= f.error_notification %>

    <div class="row">
      <div class="col-md-4">
        <%= f.input :name, placeholder: "Name" %>
      </div>

      <div class="col-md-3">
        <%= f.input :email, placeholder: "Email" %>
      </div>

      <div class="col-md-3">
        <%= f.input :phone, placeholder: "Phone" %>
      </div>

      <div class="col-md-2">
        <%= f.button :submit, class: "btn-sm" %>

        <% if contact.persisted? %>
          <%= link_to "Cancel", [contact], remote: true, class: "btn btn-link-muted btn-sm" %>
        <% else %>
          <%= link_to "Cancel", [:contacts], remote: true, class: "btn btn-link-muted btn-sm" %>
        <% end %>

        <% if contact.persisted? %>
          <%= link_to [contact],
                      method: :delete,
                      remote: true,
                      data: { confirm: "Are you sure you want to delete this contact?" },
                      class: "btn btn-link-danger btn-sm pull-right" do %>
            <i class="fa fa-trash" aria-hidden="true"></i>
          <% end %>
        <% end %>
      </div>
    </div>
  <% end %>
<% end %>
```

The `ContactsController` is mostly standard, but instead of using the normal `render` method, we'll call a `shared_render` method, pass in the action to render, and the contact object.

```
class ContactsController < ApplicationController
  def index
    @contact = Contact.new
    respond_to do |format|
      format.js { shared_render :index, @contact }
    end
  end

  def show
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js { shared_render :show, @contact }
    end
  end

  def new
    @contact = Contact.new
    respond_to do |format|
      format.js { shared_render :new, @contact }
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js { shared_render :edit, @contact }
    end
  end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.js { shared_render :create, @contact }
      else
        format.js { shared_render :new, @contact }
      end
    end
  end

  def update
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update(contact_params)
        format.js { shared_render :show, @contact }
      else
        format.js { shared_render :edit, @contact }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      format.js { shared_render :destroy, @contact }
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone)
  end
end
```

In the `ApplicationController`, we'll define the `shared_render` method, which takes the action and object, and renders the appropriate view under the `views/shared` directory.

```
class ApplicationController < ActionController::Base
  # ...

  protected

  def shared_render(action, object)
    render "shared/#{action}", locals: { object: object }
  end
end
```

Under `views/shared`, we'll have a Javascript file for `:index`, `:show`, `:new`, `:edit`, `:create` and `:destroy`.

In `shared/index.js`, we'll the remove the new object form (which is how we cancel creation of a new record).

```
$("#<%= dom_id(object) %>").remove();
```

In `shared/show.js`, we'll replace the object with a re-rendered version of the partial.

```
$("#<%= dom_id(object) %>").replaceWith("<%= j object_render(object) %>");
```

In `shared/new.js`, we'll check for the object. If it's not found, we'll append it to the collection, otherwise we'll replace it with a re-rendered version of the partial.

```
if ($("#<%= dom_id(object) %>").length == 0) {
  $(".<%= object.model_name.collection %>").append("<%= j object_form_render(object) %>");
} else {
  $("#<%= dom_id(object) %>").replaceWith("<%= j object_form_render(object) %>");
}
```

In `shared/edit.js`, we'll replace the object with the form partial.

```
$("#<%= dom_id(object) %>").replaceWith("<%= j object_form_render(object) %>");
```

In `shared/create.js`, we'll remove the new form object and append the newly created object to the collection.

```
$("#<%= dom_id(object.class.new) %>").remove();
$(".<%= object.model_name.collection %>").append("<%= j object_render(object) %>");
```

In `shared/destroy.js`, we'll remove the object.

```
$("#<%= dom_id(object) %>").remove();
```

You'll notice above that `object_render` and `object_form_render` are custom methods for rendering an object partial and an object form partial. Since they are called from the JS views, these methods need to be placed in the `ApplicationHelper`:

```
module ApplicationHelper
  def object_render(object)
    render "#{object.model_name.collection}/#{object.model_name.element}",
           object.model_name.element.to_sym => object
  end

  def object_form_render(object)
    render "#{object.model_name.collection}/form",
           object.model_name.element.to_sym => object
  end
end
```

Once we have this set up for one model, like contacts, it's pretty easy to add another model, like products.

You'll need to create a products section like the following:

```
<div class="products">
  <%= render partial: "products/header" %>
  <%= render collection: @products, partial: "products/product" %>
</div>
```

Then you'll need to create a header, instance, and form partial similar to those we created for contacts. And then you'll need to create a standard ProductsController that uses the shared_render method to render our shared JS views.
