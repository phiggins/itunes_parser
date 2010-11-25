require 'nokogiri'
 
module ItunesParser
  class NokogiriSax
    class SaxDoc < Nokogiri::XML::SAX::Document
      attr_accessor :tracks, :playlists

      def initialize on_track, on_playlist
        super()
        @on_track, @on_playlist = on_track, on_playlist
        @with_callbacks = on_track || on_playlist
        @tracks, @playlists = [], [] unless @with_callbacks
        @buffer = ""
      end

      def error(error_message)
        raise error_message
      end

      #def start_element(name, attrs = [])
      def start_element_namespace(name, *)
        case name
        when 'dict' ; start_dict
        when 'array'
          start_playlist_items if @key_string == 'Playlist Items'
        end
      end

      #def end_element(name)
      def end_element_namespace(name, *)
        case name
        when 'key'    
          @key_string = @buffer.strip
        when 'dict'   
          end_dict
        when 'array'  
          if @parsing_playlist_items
            end_playlist_items
          elsif @parsing_playlists
            end_playlists
          end
        when 'true'
          @current << @key_string << true
        when 'false'
          @current << @key_string << false
        else
          if @parsing_playlist_items
            @current_playlist_items << @buffer.to_i
          elsif @parsing_playlists || @parsing_tracks
            #puts "key_string: #{@key_string}\tbuffer: #{@buffer.strip}"
            @current << @key_string << @buffer.strip
          end
        end

        @buffer = ""
      end

      def characters(string)
        @buffer << string
      end

      def start_tracks
        #puts " ** parsing tracks"
        @parsing_tracks = true
        @current = []
      end

      def end_tracks
        #puts " ** end tracks"
        @parsing_tracks = false
      end

      def start_playlists
        #puts " ** parsing playlists"
        @parsing_playlists = true
        @current = []
      end

      def end_playlists
        @parsing_playlists = false
      end
    
      def start_playlist_items
        #puts " ** parsing playlist items"
        @current_playlist_items = []
        @parsing_playlist_items = true
      end

      def end_playlist_items
        #puts " ** end playlist items"
        @parsing_playlist_items = false
        @current << "Playlist Items"
        @current << @current_playlist_items
      end

      def start_dict
        case @key_string 
        when "Tracks"
          start_tracks
        when "Playlists"
          start_playlists
        end
      end

      def end_dict
        if @parsing_playlists && !@parsing_playlist_items
          current = Hash[*@current]
          if !@with_callbacks
            @playlists.push(current)
          elsif @on_playlist
            @on_playlist.call(current)
          end
          @current = []
        elsif @parsing_tracks
          if @current == []
            end_tracks
          else
            current = Hash[*@current]
            if !@with_callbacks
              @tracks.push(current)
            elsif @on_track
              @on_track.call(current)
            end
            @current = []
          end
        end
      end
    end

    def initialize(xml, params={})
      @xml = xml

      @on_track = params[:on_track]
      @on_playlist = params[:on_playlist]
    end

    def on_track &block
      @on_track = block
    end

    def on_playlist &block
      @on_playlist = block
    end

    def playlists
      return @playlists if @playlists
      parse
      @playlists
    end

    def tracks
      return @tracks if @tracks
      parse
      @tracks
    end

    def parse
      document = SaxDoc.new(@on_track, @on_playlist)
      parser = Nokogiri::XML::SAX::Parser.new(document)
      parser.parse(@xml)

      @tracks = document.tracks
      @playlists = document.playlists

      self
    end
  end
end
