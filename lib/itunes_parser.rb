require 'nokogiri'

require 'time' # For Time.parse

class ItunesParser
  def self.parse(xml)
    instance = new(xml)
    return instance.tracks, instance.playlists
  end

  def initialize(xml)
    @doc = Nokogiri::XML(xml)
  end

  def tracks
    @tracks ||= parse_tracks
  end

  def playlists 
    @playlists ||= parse_playlists
  end

  def parse_tracks
    @doc.xpath('/plist/dict/dict/dict').map do |node|
      node.xpath("key").each_with_object({}) do |key, hash|
        value = key.next
        hash[key.text] = self.class.cast_value(value.name, value.text)
      end
    end
  end

  def parse_playlists
    @doc.xpath('/plist/dict/array/dict').map do |node|
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
