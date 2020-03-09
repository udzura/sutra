require 'yaml'
module Sutra
  class Macro

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

      def to_managed_h
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
        YAML.dump to_managed_h
      end

      def readable_restriction
        case @_data.dig("restriction", "type")
        when "Group"
          @_restriction_group ||= Sutra::API.current.client.groups.find(id: @_data.dig("restriction", "id"))
          self["restriction"].merge({"name" => @_restriction_group.name}).to_hash
        else
          self["restriction"].to_hash
        end
      end
    end
  end
end
