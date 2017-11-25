module GaReportingV4
  module Management
    class Segment < Base
      attr_accessor :id, :name, :definition, :user

      def initialize(attributes, user)
        @id = attributes['id']
        @name = attributes['name']
        @definition = attributes['definition']
        @user = user
      end

      def self.default_path
        "/segments"
      end
    end
  end
end
