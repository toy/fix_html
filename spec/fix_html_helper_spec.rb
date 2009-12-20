require File.dirname(__FILE__) + '/spec_helper'

describe FixHtmlHelper do
  include FixHtmlHelper

  it "should leave vaild html as is" do
    html = %{<div><p>Hello world!</p><ul><li>a<br />b</li></ul></div>}
    fix_html(html).should == html
  end

  it "should fix invalid html" do
    invalid = %{<div class=abc><div title='<he"ll&o>'>1 < 2<br>2 > 1</p>}
    valid = %{<div class="abc"><div title="&lt;he&quot;ll&amp;o&gt;">1 &lt; 2<br />2 &gt; 1</div></div>}
    fix_html(invalid).should == valid
  end
end
