require 'hpricot'

module FixHtml
  # updated hpricot version
  def self.unescape(s)
    s.to_s.
      gsub(/\&([a-zA-Z][a-zA-Z0-9]*);/) { [Hpricot::NamedCharacters[$1] || ??].pack("U*") }.
      gsub(/\&\#([0-9]+);/) { [$1.to_i].pack("U*") }.
      gsub(/\&\#[xX]([0-9a-fA-F]+);/) { [$1.to_i(16)].pack("U*") }
  end

  HTML_ESCAPE = Hash[*%w[& &amp; > &gt; < &lt; " &quot;]]
  def self.escape(s)
    s.to_s.gsub(/[&"><]/){ |special| HTML_ESCAPE[special] }
  end

  def self.escape_unescaped(str)
    escape(unescape(str))
  end

  def self.fix_html(html)
    fragment = Hpricot(html.to_s)

    fragment.search('*') do |node|
      if node.bogusetag? || node.doctype? || node.procins? || node.xmldecl?
        node.parent.replace_child(node, '')
        next
      end

      if node.comment?
        node.parent.replace_child(node, '')
      elsif node.elem?
        if node.raw_attributes
          node.raw_attributes.each do |key, value|
            node.raw_attributes[key] = escape_unescaped(value)
          end
        end
      end
    end

    fragment.search('*') do |node|
      node.swap(escape_unescaped(node.to_original_html)) if node.text?
    end

    fragment.to_s
  end
end
