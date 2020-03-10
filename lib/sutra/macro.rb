require 'yaml'
require 'optparse'

module Sutra
  class Macro
    def initialize(argv)
      @action = argv.shift
      @options = OptionParser.getopts(argv, 'c:o:', 'category:', 'out:')

      if @action != "dump"
        raise OptionParser::ParseError
      end
    rescue OptionParser::ParseError
      $stderr.puts usage
      exit 1
    end

    def usage
      <<~USAGE
        #{File.basename $0} macro
        Available actions:
        \tdump [-c|--category CATEGORY_NAME] [-o|--out OUTFILE]
        \t`- dump current existing macro into YAML
      USAGE
    end

    def run
      case @action
      when /^d/
        do_dump
      else
        raise "[BUG] unknown subcommand #{ARGV.inspect}"
      end
    end

    def do_dump
      category = @options['category'] || @options['c']
      yaml = YAML.dump find_all_by_category(category).map(&:to_h)

      out = @options['out'] || @options['o']
      io = if !out
             $stdout
           else
             File.open(out, 'w')
           end
      io.write yaml + "\n"
      puts "Dump int #{out} successfully" if out
    end

    def find_all_by_category(category)
      ms = Sutra::API.current.client.macros(category: category)
      ms.to_a.map{|m| Entity.new(m) }
    end

    class Entity
      def initialize(data)
        @_data = data
      end

      def [](key)
        @_data[key]
      end

      def key
        self["title"]
      end

      def to_h
        h = @_data.to_hash
        {
          "title" => h["title"],
          "active" => h["active"],
          "position" => h["position"],
          "description" => h["description"],
          "actions" => h["actions"],
          "restriction" => readable_restriction,
        }
      end

      def to_yaml
        YAML.dump to_h
      end

      def readable_restriction
        case @_data.dig("restriction", "type")
        when "Group"
          @_restriction_group ||= Sutra::API.current.client.groups.find(id: @_data.dig("restriction", "id"))
          ret = self["restriction"].merge({"name" => @_restriction_group.name}).to_hash
          if ret["ids"] && ret["ids"].size <= 1
            ret.delete "ids"
          end
          ret
        else
          self["restriction"].to_hash
        end
      end
    end
  end
end
