---
title: Table of Contents Helper for Markdown in Middleman
date: 2017-02-08 15:31 UTC
tags: ruby, middleman
---

For pages on your site with a lot of content, it can be nice to have sidebar navigation with a Table of Contents for the page. If you're using Middleman with Markdown content, here's a way you can do that.

1\. Use the [redcarpet gem](https://github.com/vmg/redcarpet) to render Markdown for your project. Add the following to your `Gemfile` and then `bundle install`:

```
gem 'redcarpet'
```

Redcarpet provides a [special renderer](https://github.com/vmg/redcarpet#darling-i-packed-you-a-couple-renderers-for-lunch), `Redcarpet::Render::HTML_TOC`, that we'll be using for the Table of Contents.

2\. If you don't already have a custom helper for your Middleman site, now is a good time to create one.

Create the following module under `lib/custom_helpers.rb`:

```
module CustomHelpers
  def table_of_contents
    content = ::File.read(current_page.source_file)

    # remove YAML frontmatter
    content = content.gsub(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m,'')

    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    )
    markdown.render(content)
  end
end
```

Then add the following to the top of your `config.rb`:

```
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require "custom_helpers"
helpers CustomHelpers
```

You are now ready to call the `table_of_contents` method in your site layout, something like this:

```
<div class="sidebar">
  <%= table_of_contents %>
</div>
```

I realized as I was writing this that I've written about something similar over a year ago. [Auto-generate navigation from page headers in Middleman](/posts/2015-05-20-auto-generate-navigation-from-page-headers-in-middleman) explains how to build a Table of Contents, but instead of reading from Markdown, it's parsing HTML with nokogiri.