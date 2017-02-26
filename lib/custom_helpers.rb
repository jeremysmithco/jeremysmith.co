module CustomHelpers
  def markdown(text)
    return "" if text.blank?
    renderer = Redcarpet::Render::HTML.new(autolink: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text)
  end
end
