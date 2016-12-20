# Fix for "comparison of String with :current_path failed" error
Tilt::SYMBOL_ARRAY_SORTABLE = false

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :directory_indexes
activate :sprockets

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
