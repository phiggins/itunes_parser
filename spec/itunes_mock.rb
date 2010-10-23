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
                  ruby_to_itunes_type(xml, value)
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
                  ruby_to_itunes_type(xml, value)
                end
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

    # Try to make the output match itunes xml as much as possible.
    builder.to_xml.gsub(/<\/key>(?!\s+<(array|dict)>)\s+/, "</key>")
  end

  # Guess the itunes type from the ruby type
  def self.ruby_to_itunes_type(xml, var)
    case var
    when Fixnum 
      xml.integer(var)
    when false
      xml.false
    when true
      xml.true
    when /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/
      xml.date(var)
    else
      xml.string(var)
    end
  end
end
