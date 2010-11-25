require 'nokogiri'

module ItunesParser
  class NokogiriXpath
    def initialize(xml, params={})
      @doc = Nokogiri::XML(xml)
      @on_track = params[:on_track]
      @on_playlist = params[:on_playlist]

      @with_callbacks = @on_track || @on_playlist
    end

    def on_track &block
      @with_callbacks = true
      @on_track = block
    end

    def on_playlist &block
      @with_callbacks = true
      @on_playlist = block
    end

    def parse
      parse_tracks
      parse_playlists
    end

    def tracks
      @tracks ||= parse_tracks
    end

    def playlists 
      @playlists ||= parse_playlists
    end

    def parse_track(node)
      node.xpath("key").each_with_object({}) do |key, hash|
        value = key.next
        name = value.name
        hash[key.text] = case name
          when 'false'  ; false
          when 'true'   ; true
          else          ; value.text
        end
      end
    end

    def parse_tracks
      xpath = @doc.xpath('/plist/dict/dict/dict')

      if !@with_callbacks
        xpath.map {|node| parse_track(node) }
      elsif @on_track
        xpath.each {|node| @on_track.call(parse_track(node)) }
        nil
      end
    end

    def parse_playlist(node)
      node.xpath("key").each_with_object({}) do |key, hash|
        value = key.next
        value = value.next while value.blank?
        key_name = key.text

        if key_name == 'Playlist Items'
          items = value.xpath("dict/integer").map {|i| i.text.to_i }
          hash[key_name] = items
        else
          name = value.name
          hash[key_name] = case name
            when 'false'  ; false
            when 'true'   ; true
            else          ; value.text
          end
        end
      end
    end

    def parse_playlists
      xpath = @doc.xpath('/plist/dict/array/dict')

      if !@with_callbacks
        xpath.map {|node| parse_playlist(node) }
      elsif @on_playlist
        xpath.each {|node| @on_playlist.call(parse_playlist(node)) }
        nil
      end
    end
  end
end
