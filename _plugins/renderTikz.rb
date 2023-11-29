module Jekyll
    class TikzEnvironment < Liquid::Block
		def initialize(tag_name, input, tokens)
			super
			@input = input
		end
		def render(context)
			id = ""    
			text = super
	
			begin
				if( !@input.nil? && !@input.empty? )
				jdata = JSON.parse(@input)
				if( jdata.key?("id") )
					id = jdata["id"].strip
				end
				end
			rescue
			end
	
			output =  "<div class=\"tikz\" id=\"#{id}\">"    
			output += "<script type=\"text/tikz\">"
			output += "#{text}"
			output += "</script>"
			output += "</div>"
			return output;
		end
    end
    class QuiverEnvironment < Liquid::Block
		def initialize(tag_name, input, tokens)
			super
			@input = input
		end
		def render(context)
			id = ""    
			text = super
	
			begin
				if( !@input.nil? && !@input.empty? )
				jdata = JSON.parse(@input)
				if( jdata.key?("id") )
					id = jdata["id"].strip
				end
				end
			rescue
			end
			
			output =  "<div class=\"quiver\" style=\"display: flex; justify-content: center;\" id=\"#{id}\">"    
			output += "#{text}"
			output += "</div>"
			return output;
		end
  end
end

Liquid::Template.register_tag('tikz', Jekyll::TikzEnvironment)
Liquid::Template.register_tag('quiver', Jekyll::QuiverEnvironment)


# <div style="display: flex; justify-content: center;">
