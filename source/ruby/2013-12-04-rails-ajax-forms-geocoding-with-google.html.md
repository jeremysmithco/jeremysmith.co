---
title: Rails AJAX Forms & Geocoding with Google
date: 2013-12-04 13:32 UTC
tags:
---

If you’ve done geocoding using Google’s APIs lately, you know that the best practice nowadays is to geocode on the client side and pass your latitude/longitude coordinates to the server, rather than having the server make the geocode request. Google caps the number of geocode requests based on IP to (I think) 1500 per day. This is fine on the client side for many use cases, but would quickly become an issue on the server side.

I was recently working on a location search using the Google Geocoder Javascript API for geocoding and ran into an issue with making the geocoder request on submission of the form. The form was a Rails AJAX form, so I couldn’t use on the form.submit() Javascript event handler. Instead, after some trial and error and reading through the jquery-ujs source (https://github.com/rails/jquery-ujs), I found I could bind to the "ajax:before" event and then trigger "submit.rails" after successfully capturing geocoordinates from Google. Here’s what that ended up looking like:

I have a `_search_form.html.erb` partial for the search form loaded on the groups#index:

```
<%= form_tag search_groups_path, :id => "search_form", :remote => true do -%>
  <%= hidden_field_tag :coordinates, params[:coordinates] %>
  <%= text_field_tag :search, params[:search], :placeholder => "City, State or Postal Code" %>
  <%= submit_tag "Search" %>
<% end -%>
```

I have a groups.js.coffee file that gets loaded for the Groups controller and executes for whatever action is rendered:

```
class GroupsController
  index: ->
    @form()
  search: ->
    @form()
  show: ->
    mapCanvas = $("#mapCanvas")[0]
    MappingModule.init(mapCanvas)
  form: ->
    searchForm = $("form#search_form")
    searchField = $("input#search")
    coordinatesField = $("input#coordinates")
    GeocodingModule.init(searchForm, searchField, coordinatesField)

this.Controller.groups = new GroupsController
```

I also have a geocoding.js.coffee file with the Geocoding Module and a function that handles the form and geocode logic:

```
@GeocodingModule =
  init: (searchForm, searchField, coordinatesField) ->
    # clear coordinates on query change
    searchField.change () ->
      coordinatesField.val("")

    geocoder = new google.maps.Geocoder()
    searchForm.bind "ajax:before", (event) ->
      if coordinatesField.val() == "" &amp;&amp; geocoder
        geocoder.geocode({'address':searchField.val()}, (results, status) =>
          if status == google.maps.GeocoderStatus.OK
            coordinatesField.val(results[0].geometry.location)
            #alert "coordinates: #{coordinatesField.val()}"
            searchForm.trigger("submit.rails")
        )
        false
      else
        true
```

When the index action loads, the GeocodingModule init function is called, passing in the search form, search text field and coordinates hidden field. If the search text field changes, the coordinates hidden field is cleared. If the form is submitted as an AJAX form, the ajax:before event is triggered. If the coordinates hidden field is empty, a Google geocode request is made. If the geocode request is successful, the coordinates from the first result are inserted into the coordinates hidden field and the submit.rails event is triggered again. The "false" after the geocode request stops the initial AJAX form submission from continuing. The trigger "submit.rails" starts a new AJAX form submission.
