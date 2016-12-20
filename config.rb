page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :directory_indexes
activate :sprockets

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
  blog.name = "ruby"
  blog.prefix = "ruby"
  blog.layout = "layouts/blog"
  blog.permalink = "{year}-{month}-{day}-{title}.html"
end

activate :blog do |blog|
  blog.name = "web"
  blog.prefix = "web"
  blog.layout = "layouts/blog"
  blog.permalink = "{year}-{month}-{day}-{title}.html"
end

activate :blog do |blog|
  blog.name = "personal"
  blog.prefix = "personal"
  blog.layout = "layouts/blog"
  blog.permalink = "{year}-{month}-{day}-{title}.html"
end

page '/about.html', layout: false

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :rsync
  deploy.clean = true
  deploy.user = "deploy"
  deploy.host = ""
  deploy.path = ""
end
