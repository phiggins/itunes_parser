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
    @doc.xpath('/plist/dict/dict/dict').each_with_object({}) do |node, hash|
      track    = {}
      last_key = nil

      node.children.each do |child|
        next if child.blank? # Don't care about blank nodes

        case child.name 
        when 'key'
          last_key = child.text
        else 
          track[last_key] = self.class.cast_value(child.name, child.text)
        end
      end

      id = track["Track ID"]
      hash[id] = track
    end
  end

  def parse_playlists
    @doc.xpath('/plist/dict/array/dict').map do |node|
      hash = {}
      last_key = nil

      node.children.each do |child|
        next if child.blank?

        if last_key == "Playlist Items"
          hash[last_key] = child.children.map do |child_node|
            next if child_node.blank?
            child_node.children[2].children.first.text
          end.compact
        else
          case child.name 
          when 'key'
            last_key = child.text
          else 
            hash[last_key] = self.class.cast_value(child.name, child.text)
          end
        end
      end

      hash
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
