require 'nokogiri'

require 'time' # For Time.parse

class ItunesParser
  def self.parse(xml, procs={})
    track_proc    = procs[:on_track]
    playlist_proc = procs[:on_playlist]

    instance = new(xml)

    if track_proc
      instance.on_track = track_proc
      instance.parse_tracks
    end

    if playlist_proc
      instance.on_playlist = playlist_proc
      instance.parse_playlists
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
      hash[key.text] = self.class.cast_value(value.name, value.text)
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
        hash[key_name] = self.class.cast_value(value.name, value.text)
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

  def self.cast_value(type, value)
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
end
