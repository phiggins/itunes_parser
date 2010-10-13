require 'rubygems'
require 'nokogiri'
 
module ItunesParser
  class SaxDoc < Nokogiri::XML::SAX::Document
    KEY = "__last_key__"

    attr_reader :root

    def start_document
      @root = {}
      @stack = [@root]
    end

    def end_document
      raise "Parse stack not empty!" if @stack.size > 1
    end

    def error(error_message)
      raise error_message
    end

    def start_element(name, attrs = [])
      #puts "start_element: #{name}\t@stack.last: #{@stack.last.inspect}"
      #puts "start_element: #{name}\t@key: #{@key}"
      
      if @stack.last.is_a?(Hash) && @key
        @stack.last[KEY] = @key
      end

      if name == "dict"
        @stack.push({})  
      elsif name == "array"
        @key = nil
        @stack.push([])
      elsif name == "key"
        @key = nil
      end
    end

    def end_element(name)
      #puts "end_element: #{name}"

      if name == "dict" || name == "array"
        obj = @stack.pop
        last = @stack.last
        case last
        when Hash
          if key = last.delete(KEY)
            last[key] = obj
          else
            @root = obj
          end
        when Array
          obj.delete(KEY)
          last << obj
        end
      end
    end

    def characters(string)
      string.strip!
      return if string.empty?
      if @key
        #puts "characters: #{string}\t@key: #{@key}"
        if current_value = @stack.last[@key]
          current_value << string
        else
          @stack.last[@key] = string
        end
      else
        #puts "characters: #{string}"
        @key = string
      end
    end
  end

  def self.parse(data)
    document = SaxDoc.new 
    parser = Nokogiri::XML::SAX::Parser.new(document)
    parser.parse(data)
    return document.root["Tracks"], document.root["Playlists"]
  end
end

if __FILE__ == $0
  if ARGV.empty?
    $stderr.puts "usage: #{$0} <itunes xml file>"
    exit 1
  end
  require 'benchmark'

  xml = open(ARGV.first)

  tracks, playlists = nil
  Benchmark.bm do |b|
    b.report "nokogiri_sax" do
      tracks, playlists = ItunesParser.parse(xml)
    end
  end
  puts "tracks: #{tracks.size}\tplaylists: #{playlists.size}"
end
