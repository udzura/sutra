require 'optparse'

module Sutra
  class Help
    def initialize(*)
    end

    def run
      $stderr.puts <<~USAGE
        #{File.basename $0} version: #{VERSION}
        Available commands:
        \tmacro - manage Zendesk macros
        \thelp - show this message
      USAGE
    end
  end

  class Cli
    def initialize(argv)
      @subcommand = argv.shift
      @argv = argv
    end

    COMMANDS = {
      "help" => Help,
      "--help" => Help,
      "-h" => Help,
      "macro" => Macro
    }

    def run
      if klass = COMMANDS[@subcommand]
        klass.new(@argv).run
      else
        $stderr.puts "subcommand not found: #{@subcommand.inspect}"
        Help.new(nil).run
        exit 1
      end
    end
  end
end
