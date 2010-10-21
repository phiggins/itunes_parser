require 'nokogiri'

module ItunesMock
  def self.generate(params={})
    tracks    = params[:tracks]
    playlists = params[:playlists]

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
            tracks.each_with_index do |track, i|
              index = i+1
              xml.key(index)
              xml.dict do
                xml.key("Track ID")
                xml.integer(index)

                track.each do |key, value|
                  xml.key(key)
                  # TODO: assume they're all strings for now
                  xml.string(value)
                end
              end
            end
          end

          xml.key("Playlists")
          xml.array do
            playlists.each do |playlist|
              xml.dict do
                playlist.each do |key, value|
                  xml.key(key)
                  # TODO: Just like tracks, assume it's all strings
                  xml.string(value)
                  xml.key("Playlist Items")
                  xml.array do
                    # TODO: All tracks are on all playlists. 
                    # Figure out something more clever?
                    (1..tracks.size).each do |i|
                      xml.dict do
                        xml.key("Track ID")
                        xml.integer(i)
                      end
                    end
                  end
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
