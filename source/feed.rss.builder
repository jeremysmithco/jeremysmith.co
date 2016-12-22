---
blog: posts
---

xml.instruct!
xml.rss version: '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title data.site.name
    xml.link URI.join(data.site.url)
    xml.description data.site.description
    xml.atom :link, href: URI.join(data.site.url, current_page.path), rel: 'self', type: 'application/rss+xml'

    unless blog.articles.empty?
      xml.pubDate blog.articles.first.date.to_time.rfc2822

      blog.articles.each do |article|
        xml.item do
          xml.title article.title
          xml.link URI.join(data.site.url, article.url)
          xml.guid URI.join(data.site.url, article.url)
          xml.pubDate article.date.to_time.rfc2822
          xml.description article.summary
        end
      end
    end
  end
end
