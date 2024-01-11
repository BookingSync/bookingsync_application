module BookingsyncApplication
  module Controllers
    module BookingsyncUniverseApiAccess
      private

      def authenticate_account!
        if auth = request.headers["Authorization"].presence
          response = Faraday.new(url: bookingsync_url).get do |req|
            req.url auth_path
            req.headers["Authorization"] = auth
          end
          if response.success?
            @scope = AuthorizationScope.from_response(response)

            session[:account_id] = scope.account_id
            session[:accounts_user_id] = scope.accounts_user_id
            session[:user_id] = scope.user_id
          else
            render json: response.body, status: response.status and return
          end
        else
          super
        end
      end

      def bookingsync_url
        "#{ENV['BOOKINGSYNC_URL']}"
      end

      def auth_path
        "/api/v3/auth"
      end

      def scope
        @scope
      end

      def bookingsync_universe_authorize_request!(*required_scopes)
        if !scope.allows_access_for?(Array(required_scopes).map(&:to_s))
          render json: { errors: [ { code: :forbidden } ] }, status: 403 and return
        end
      end

      class AuthorizationScope
        attr_reader :response_hash
        private     :response_hash

        def self.from_response(response)
          new(JSON.parse(response.body))
        end

        def initialize(response_hash)
          @response_hash = response_hash
        end

        def scopes
          auth.fetch("scopes").map(&:to_s)
        end

        def account_id
          auth.fetch("account_id")
        end

        def accounts_user_id
          auth.fetch("accounts_user_id")
        end

        def user_id
          auth.fetch("user_id")
        end

        def allows_access_for?(required_scopes)
          required_scopes.any? { |scope| scopes.include?(scope) }
        end

        private

        def auth
          @auth ||= response_hash.fetch("auth")
        end
      end
    end
  end
end
