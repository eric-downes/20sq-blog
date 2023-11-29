module Jekyll
  class RenderTimeTagBlock < Liquid::Block

    def render(context)
      text = super
      "<script type=\"text/tikz\">
      #{text}
      </script>"
    end

  end
end

Liquid::Template.register_tag('tikz', Jekyll::RenderTimeTagBlock)
