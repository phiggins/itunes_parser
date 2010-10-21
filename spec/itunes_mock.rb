require 'nokogiri'

module ItunesMock
  def self.generate
    builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
      xml.doc.create_internal_subset(
        'plist',
        "-//Apple Computer//DTD PLIST 1.0//EN",
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
      )

      xml.plist(:version => 1.0) do
      xml.dict do
        xml.key("Tracks")
        xml.dict do
          xml.key(1)
          xml.dict do
            xml.key("Track ID")
            xml.integer(120)
          end
        end

        xml.key("Playlists")
        xml.array do
          xml.dict do
            xml.key("Name")
            xml.string("90's Music")
            xml.key("Playlist Items")
            xml.array do
              xml.dict do
                xml.key("Track ID")
                xml.integer(1)
              end
            end
          end
        end
      end
    end
    end

    builder.to_xml.gsub(/<\/key>(?!\s+<(array|dict)>)\s+/, "</key>")
  end
end
