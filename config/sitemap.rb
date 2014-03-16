require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.notist.co'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily', :priority => 0.9
  add '/about', :changefreq => 'weekly'
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks





# Sitemap::Generator.instance.load :host => "mywebsite.com" do

#   # Sample path:
#   #   path :faq
#   # The specified path must exist in your routes file (usually specified through :as).

#   # Sample path with params:
#   #   path :faq, :params => { :format => "html", :filter => "recent" }
#   # Depending on the route, the resolved url could be http://mywebsite.com/frequent-questions.html?filter=recent.

#   # Sample resource:
#   #   resources :articles

#   # Sample resource with custom objects:
#   #   resources :articles, :objects => proc { Article.published }

#   # Sample resource with search options:
#   #   resources :articles, :priority => 0.8, :change_frequency => "monthly"

#   # Sample resource with block options:
#   #   resources :activities,
#   #             :skip_index => true,
#   #             :updated_at => proc { |activity| activity.published_at.strftime("%Y-%m-%d") }
#   #             :params => { :subdomain => proc { |activity| activity.location } }

# end
