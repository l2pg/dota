module Dota
  module API
    class Ability
      include Utilities::JsonMapped

      attr_reader :id, :name, :full_name, :manacost, :behavior, :cooldown, :internal_name

      alias_method :full_name, :name

      def initialize(id)
        @id = id
        sid = id.to_s
        ab = mapping[sid]
        ab = {'name' => nil, 'human_name' => nil, 'manacost' => nil, 'cooldown' => nil, 'behavior' => nil} if ab.nil?
        
        @internal_name = ab['name'] || "unknown_ability_#{sid}"
        @name = ab['human_name'] || @internal_name
        @manacost = ab['manacost']
        @cooldown = ab['cooldown']
        @behavior = ab['behavior']
      end

      def image_url(type = :lg)
        # Possible values for type:
        # :hp1 - 90x90 PNG image
        # :hp2 - 105x105 PNG image
        # :lg - 128x128 PNG image
        if internal_name.match(/special_bonus_/)
          "https://steamcdn-a.akamaihd.net/apps/dota2/images/workshop/itembuilder/stats.png"
        else
          "http://cdn.dota2.com/apps/dota2/images/abilities/#{internal_name}_#{type}.png"
        end
      end

      def self.all
        @all ||= mapping.to_a.map { |id, item_json| new(id) }
      end
    end
  end
end
