---
title: Get a word count from your Rails app views
date: 2014-09-09 14:17 UTC
tags: ruby
---

I needed a way to calculate the number of words in a Rails application’s views, to estimate the cost of translating the content to another language.

Pass this script the path to your views directory (or a subdirectory) to get a word count.

```
#!/usr/bin/env ruby
require "action_view"
require "fileutils"

class WordCounter
  include ActionView::Helpers::SanitizeHelper

  def initialize(initial_directory)
    @initial_directory = initial_directory
    puts count_directory(@initial_directory)
  end

  def count_directory(directory)
    return 0 if !File.directory?(directory)
    word_count_total = 0

    FileUtils.cd(directory) do
      files = Dir.glob("**/*")
      files.each do |file_name|
        full_path = "#{directory}/#{file_name}"
        if File.directory?(full_path)
          word_count_total += count_directory(full_path)
        elsif File.exists?(full_path)
          word_count_total += word_count(strip_html(strip_comments(strip_erb(File.read(full_path)))))
        end
      end

    end

    return word_count_total
  end

  private

  def strip_erb(text)
    text.gsub(/<%(?:(?!%>).)+%>/, "")
  end

  def strip_comments(text)
    text.gsub(//, "")
  end

  def strip_html(text)
    sanitize(text, :tags => [], :attributes => [])
  end

  def word_count(text)
    text.split.length rescue 0
  end

end

WordCounter.new(ARGV[0])
```

Here’s the [gist on Github](https://gist.github.com/jeremysmithco/9cf106e591e78de282fb).
