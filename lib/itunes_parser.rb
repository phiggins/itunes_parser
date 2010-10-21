require 'nokogiri'

module ItunesParser
  def self.parse(xml)
    doc = Nokogiri::XML(xml)
    return parse_tracks(doc), parse_playlists(doc)
  end

  def self.parse_tracks(doc)
    doc.xpath('/plist/dict/dict/dict').map do |node|
      hash     = {}
      last_key = nil

      node.children.each do |child|
        next if child.blank? # Don't care about blank nodes

        if child.name == 'key'
          last_key = child.text
        else
          hash[last_key] = child.text
        end
      end

      hash
    end
  end

  def self.parse_playlists(doc)
    doc.xpath('/plist/dict/array/dict').map do |node|
      hash = {}
      last_key = nil

      node.children.each do |child|
        next if child.blank?

        if last_key == "Playlist Items"
          hash[last_key] = child.children.map do |child_node|
            next if child_node.blank?
            child_node.children[2].children.first.text
          end.compact
        elsif child.name == 'key'
          last_key = child.text
        else
          hash[last_key] = child.text
        end
      end

      hash
    end
  end
end
