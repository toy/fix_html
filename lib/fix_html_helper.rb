require 'fix_html'

module FixHtmlHelper
  def fix_html(html)
    FixHtml.fix_html(html)
  end
end
