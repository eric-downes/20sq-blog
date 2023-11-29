module Jekyll
    class RenderTikz < Liquid::Block
		def initialize(tag_name, input, tokens)
			super
			@input = input
		end
		def render(context)
			id = ""    
			text = super
			noCaption =  "<div class=\"tikz\" id=\"#{id}\">" 
			noCaption += "<script type=\"text/tikz\">"
			noCaption += "#{text}"
			noCaption += "</script>"
			noCaption += "</div>"
			output = noCaption
			begin
				if( !@input.nil? && !@input.empty? )
				jdata = JSON.parse(@input)
				if( jdata.key?("id") )
					id = jdata["id"].strip
					output = "{:.tikzCaption}"
					output += noCaption
				end
				end
			rescue
			end
			return output;
		end
    end

    class RenderQuiver < Liquid::Block
		def initialize(tag_name, input, tokens)
			super
			@input = input
		end
		def render(context)
			id = ""    
			text = super
			noCaption =  "<div class=\"quiver\" id=\"#{id}\">" 
			noCaption += "#{text}"
			noCaption += "</div>"
			output = noCaption
			begin
				if( !@input.nil? && !@input.empty? )
				jdata = JSON.parse(@input)
				if( jdata.key?("id") )
					id = jdata["id"].strip
					output = "{:.quiverCaption}"
					output += noCaption
				end
				end
			rescue
			end

			return output;
		end
  	end

	Liquid::Template.register_tag('tikz', Jekyll::RenderTikz)
	Liquid::Template.register_tag('quiver', Jekyll::RenderQuiver)
end