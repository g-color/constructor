module Services
  module Audit
    class Log
      def initialize(user:, action:, object_type:, object_name:, object_link:)
        @user        = user
        @action      = action
        @object_type = object_type
        @object_name = object_name
        @object_link = object_link
      end

      def call
        create_audit
      end

      private

      def create_audit
        ::Audit.create(
          user_name:   @user.full_name,
          user_role:   @user.role,
          action:      @action,
          object_type: @object_type,
          object_name: @object_name,
          object_link: @object_link
        )
      end
    end
  end
end
