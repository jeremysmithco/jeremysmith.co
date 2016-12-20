# Fix for "comparison of String with :current_path failed" error
Tilt::SYMBOL_ARRAY_SORTABLE = false

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :directory_indexes
activate :sprockets
activate :dotenv

set :relative_links, false
set :markdown_engine, :redcarpet
set :markdown, no_intra_emphasis: true, tables: true, autolink: true,
               gh_blockcode: true, fenced_code_blocks: true,
               with_toc_data: true, smartypants: true

configure :development do
  activate :livereload
end

set :css_dir, "assets/stylesheets"
set :js_dir, "assets/javascripts"
set :images_dir, "assets/images"
set :layout, "layouts/application"

activate :blog do |blog|
  blog.name = "posts"
  blog.prefix = "posts"
  blog.layout = "layouts/blog"
  blog.permalink = "{year}-{month}-{day}-{title}.html"
  blog.paginate = true
  blog.per_page = 10
end

page '/about.html', layout: false

redirect "rss", to: "feed.rss"
redirect "post/134874453155.html", to: "posts/2015-12-09-custom-currency-input-for-simple-form.html"
redirect "post/134874453155/custom-currency-input-for-simple-form.html", to: "posts/2015-12-09-custom-currency-input-for-simple-form.html"
redirect "post/134482821790.html", to: "posts/2015-12-03-how-to-mark-optional-form-fields-with-simple-form.html"
redirect "post/134482821790/how-to-mark-optional-form-fields-with-simple-form.html", to: "posts/2015-12-03-how-to-mark-optional-form-fields-with-simple-form.html"
redirect "post/119441704425.html", to: "posts/2015-05-20-auto-generate-navigation-from-page-headers-in-middleman.html"
redirect "post/119441704425/auto-generate-navigation-from-page-headers-in.html", to: "posts/2015-05-20-auto-generate-navigation-from-page-headers-in-middleman.html"
redirect "post/118145911285.html", to: "posts/2015-05-04-a-simple-interface-for-the-controller-context-in-your-rails-app.html"
redirect "post/118145911285/a-simple-interface-for-the-controller-context-in.html", to: "posts/2015-05-04-a-simple-interface-for-the-controller-context-in-your-rails-app.html"
redirect "post/116381909565.html", to: "posts/2015-04-14-ecosystem-diversity-and-the-internet.html"
redirect "post/116381909565/ecosystem-diversity-the-internet.html", to: "posts/2015-04-14-ecosystem-diversity-and-the-internet.html"
redirect "post/114592988390.html", to: "posts/2015-03-25-notes-from-the-shape-of-design.html"
redirect "post/114592988390/notes-from-the-shape-of-design.html", to: "posts/2015-03-25-notes-from-the-shape-of-design.html"
redirect "post/113371693535.html", to: "posts/2015-03-11-how-to-add-high-voltage-static-pages-to-your-sitemap-file.html"
redirect "post/113371693535/how-to-add-high-voltage-static-pages-to-your.html", to: "posts/2015-03-11-how-to-add-high-voltage-static-pages-to-your-sitemap-file.html"
redirect "post/111881596500.html", to: "posts/2015-02-23-losing-my-place.html"
redirect "post/111881596500/losing-my-place.html", to: "posts/2015-02-23-losing-my-place.html"
redirect "post/110825491990.html", to: "posts/2015-02-12-active-record-enum-form-select.html"
redirect "post/110825491990/active-record-enum-form-select.html", to: "posts/2015-02-12-active-record-enum-form-select.html"
redirect "post/103287123470.html", to: "posts/2014-11-22-the-future-of-the-web.html"
redirect "post/103287123470/its-clear-that-google-cares-deeply-about.html", to: "posts/2014-11-22-the-future-of-the-web.html"
redirect "post/103247135725.html", to: "posts/2014-11-21-how-to-reward-skilled-coders.html"
redirect "post/103247135725/innovation-happens-when-you-have-the-bandwidth-to.html", to: "posts/2014-11-21-how-to-reward-skilled-coders.html"
redirect "post/97757375360.html", to: "posts/2014-09-17-interview-of-kevin-kelly.html"
redirect "post/97757375360/interview-of-kevin-kelly.html", to: "posts/2014-09-17-interview-of-kevin-kelly.html"
redirect "post/97070350700.html", to: "posts/2014-09-09-get-a-word-count-from-your-rails-app-views.html"
redirect "post/97070350700/get-a-word-count-from-your-rails-app-views.html", to: "posts/2014-09-09-get-a-word-count-from-your-rails-app-views.html"
redirect "post/96678111370.html", to: "posts/2014-09-05-a-tumblr-theme-development-workflow.html"
redirect "post/96678111370/a-tumblr-theme-development-workflow.html", to: "posts/2014-09-05-a-tumblr-theme-development-workflow.html"
redirect "post/94743690345.html", to: "posts/2014-08-14-how-to-be-polite.html"
redirect "post/94743690345/how-to-be-polite.html", to: "posts/2014-08-14-how-to-be-polite.html"
redirect "post/92290764635.html", to: "posts/2014-07-19-simple-site-wide-announcements-in-rails.html"
redirect "post/92290764635/simple-site-wide-announcements-in-rails.html", to: "posts/2014-07-19-simple-site-wide-announcements-in-rails.html"
redirect "post/89090395845.html", to: "posts/2014-06-17-the-man-who-saves-you-from-yourself.html"
redirect "post/89090395845/the-man-who-saves-you-from-yourself.html", to: "posts/2014-06-17-the-man-who-saves-you-from-yourself.html"
redirect "post/74392403766.html", to: "posts/2014-01-24-devise-cas-using-devisecasauthenticatable-and-casino.html"
redirect "post/74392403766/devise-cas-using-devisecasauthenticatable-and.html", to: "posts/2014-01-24-devise-cas-using-devisecasauthenticatable-and-casino.html"
redirect "post/71844647062.html", to: "posts/2014-01-01-best-reads-of-2013.html"
redirect "post/71844647062/best-reads-of-2013.html", to: "posts/2014-01-01-best-reads-of-2013.html"
redirect "post/70603223519.html", to: "posts/2013-12-20-sending-a-weekly-email-newsletter.html"
redirect "post/70603223519/sending-a-weekly-email-newsletter.html", to: "posts/2013-12-20-sending-a-weekly-email-newsletter.html"
redirect "post/68993017533.html", to: "posts/2013-12-04-rails-ajax-forms-geocoding-with-google.html"
redirect "post/68993017533/rails-ajax-forms-geocoding-with-google.html", to: "posts/2013-12-04-rails-ajax-forms-geocoding-with-google.html"
redirect "post/62088969275.html", to: "posts/2013-09-23-what-dribbble-is-good-for.html"
redirect "post/62088969275/what-dribbble-is-good-for.html", to: "posts/2013-09-23-what-dribbble-is-good-for.html"
redirect "post/61758770787.html", to: "posts/2013-09-20-grading-our-art.html"
redirect "post/61758770787/grading-our-art.html", to: "posts/2013-09-20-grading-our-art.html"
redirect "post/61588872311.html", to: "posts/2013-09-18-give-your-best-a-timeframe.html"
redirect "post/61588872311/give-your-best-a-timeframe.html", to: "posts/2013-09-18-give-your-best-a-timeframe.html"
redirect "post/61411200697.html", to: "posts/2013-09-16-how-to-homeschool-your-kids-with-a-full-time-job.html"
redirect "post/61411200697/how-to-homeschool-your-kids-with-a-full-time-job.html", to: "posts/2013-09-16-how-to-homeschool-your-kids-with-a-full-time-job.html"
redirect "post/43280823889.html", to: "posts/2013-02-08-a-lack-of-participation.html"
redirect "post/43280823889/a-lack-of-participation.html", to: "posts/2013-02-08-a-lack-of-participation.html"
redirect "post/43280759335.html", to: "posts/2013-01-25-setting-up-multiple-instances-of-redis-on-a-mac.html"
redirect "post/43280759335/setting-up-multiple-instances-of-redis-on-a-mac.html", to: "posts/2013-01-25-setting-up-multiple-instances-of-redis-on-a-mac.html"
redirect "post/43280256454.html", to: "posts/2011-12-02-bent-on-creation-redesign.html"
redirect "post/43280256454/bent-on-creation-redesign.html", to: "posts/2011-12-02-bent-on-creation-redesign.html"
redirect "post/43279968599.html", to: "posts/2011-12-01-google-docs-gadget-fix.html"
redirect "post/43279968599/google-docs-gadget-fix.html", to: "posts/2011-12-01-google-docs-gadget-fix.html"
redirect "post/43279873217.html", to: "posts/2011-11-02-pow-awesomeness-for-php-static-sites.html"
redirect "post/43279873217/pow-awesomeness-for-php-static-sites.html", to: "posts/2011-11-02-pow-awesomeness-for-php-static-sites.html"

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :rsync
  deploy.clean = true
  deploy.user = ENV["DEPLOY_USER"]
  deploy.host = ENV["DEPLOY_HOST"]
  deploy.port = ENV["DEPLOY_PORT"]
  deploy.path = ENV["DEPLOY_PATH"]
end
