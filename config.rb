require File.expand_path('../lib/extensions/fallback_for_directory_indexes', __FILE__)
require File.expand_path('../lib/extensions/gocd_helpers', __FILE__)

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

deploy_environment = (ENV['DEPLOY_ENVIRONMENT'] || 'preview')

set :base_url, ENV['BASE_URL'] || 'http://localhost:4547'
# Repeated, just to show that it is important. Changing this might mean you lose Disqus comments.
set :base_url_for_blog_posts, "https://www.go.cd"
set :deploy_environment, deploy_environment

set :js_dir, "assets/javascripts"
set :css_dir, "assets/stylesheets"
set :images_dir, "assets/images"

set :relative_links, true

REDIRECTS = {
  "2014/02/25/go-is-now-open-source.html"      => "/2014/02/25/go-moving-to-open-source/index.html",
  "2014/10/09/Distrubuted-Test-Execution.html" => "/2014/10/09/Distributed-Test-Execution/index.html",
  "community/resources/index.html"             => "/resources/index.html",
  "community/events/index.html"                => "/events/index.html",
  "community/partners/index.html"              => "/partners/index.html",
  "community/plugins/index.html"               => "/plugins/index.html",
  "contribute/cla/index.html"                  => "/contributor-license-agreement/index.html",
  "contribute/roadmap/index.html"              => "/roadmap/index.html",
  "getting-started/index.html"                 => "/getting-started/part-1/index.html",
  "contribute/contribution-guide.html"         => "/contribute/index.html",
  "learn-more/why-go.html"                     => "/why-gocd/index.html",
  "cla/index.html"                             => "/contributor-license-agreement/index.html",
  "documentation/index.html"                   => "https://docs.gocd.io",
  "support/index.html"                         => "https://www.thoughtworks.com/go",
  "infoq/index.html"                           => "/index.html?utm_campaign=infoq_2016_q4&utm_medium=podcast_infoq&utm_source=podcast_infoq&utm_content=go_download&utm_term=",
  "changelog/index.html"                       => "/index.html?utm_campaign=the_changelog_2016&utm_medium=podcast&utm_source=podcast_audio&utm_content=go_download&utm_term=",
  "talkpython/index.html"                      => "/download/index.html?utm_campaign=tptm_2016&utm_medium=podcast_banner&utm_source=podcast_Banner_tptm&utm_content=manage_complexity_ease&utm_term=",
  "recode/index.html"                          => "/index.html?utm_campaign=recode_podcast_q1_2017&utm_medium=podcast_recode&utm_source=podcast_recode&utm_content=go_cd&utm_term=",
  "twit/index.html"                            => "/index.html?utm_campaign=twit_podcast_q1_2017&utm_medium=podcast_twit&utm_source=podcast_twit&utm_content=go_cd&utm_term=",
  }
#To ignore HtmlCheck for URL's with &, update file_ignore options in lib/tasks/static_checks.rake
activate :sprockets

activate :autoprefixer
activate :relative_assets
activate :blog do |blog|
  blog.sources           = "posts/{year}-{month}-{day}-{title}.html"
  blog.layout            = "post"
  blog.tag_template      = "posts/tag.html"
  blog.calendar_template = "posts/calendar.html"
  blog.paginate          = true
end
activate :directory_indexes
activate :fallback_for_directory_indexes
activate :gocd_helpers

configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload
end

REDIRECTS.each do |from, to|
  proxy from, "/redirect.template.html", :locals => { :redirect_to => to }, :ignore => true
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket       = ENV['S3_BUCKET']
  s3_sync.region       = 'us-east-1'
  s3_sync.prefer_gzip  = false
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript
end
