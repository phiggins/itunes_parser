require 'nokogiri'

require 'time' # For Time.parse

class ItunesParser
  def self.parse(xml, procs={})
    on_track    = procs[:on_track]
    on_playlist = procs[:on_playlist]

    parser = new(xml)

    if on_track
      parser.on_track = on_track
      parser.parse_tracks
    end

    if on_playlist
      parser.on_playlist = on_playlist
      parser.parse_playlists
    end
  end

  attr_accessor :on_track, :on_playlist

  def initialize(xml)
    @doc = Nokogiri::XML(xml)
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
      hash[key.text] = cast_value(value.name, value.text)
    end
  end

  def parse_tracks
    xpath = @doc.xpath('/plist/dict/dict/dict')

    if @on_track
      xpath.each {|node| @on_track.call(parse_track(node)) }
    else
      xpath.map {|node| parse_track(node) }
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
        hash[key_name] = cast_value(value.name, value.text)
      end
    end
  end

  def parse_playlists
    xpath = @doc.xpath('/plist/dict/array/dict')
    
    if @on_playlist
      xpath.each {|node| @on_playlist.call(parse_playlist(node)) }
    else
      xpath.map {|node| parse_playlist(node) }
    end
  end

  def cast_value(type, value)
    case type
    when 'integer'
      value.to_i
    when 'date'
      Time.parse(value)
    when 'false'
      false
    when 'true'
      true
    else
      value
    end
  end

  VERSION = "0.0.1"
end
