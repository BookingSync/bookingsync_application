module BookingsyncApplication
  module Controllers
    module BookingsyncUniverseApiAccess
      private

      def authenticate_account!
        if enable_for_bookingsync_universe_api? && auth = request.headers["Authorization"].presence
          response = Faraday.new(url: bookingsync_url).get do |req|
            req.url oauth_path
            req.headers["Authorization"] = auth
          end
          if response.success?
            @scope = AuthorizationScope.from_response(response)

            session[:account_id] = scope.account_id
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

      def oauth_path
        "/api/v3/oauth"
      end

      def enable_for_bookingsync_universe_api?
        false
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
          oauth.fetch("scopes").map(&:to_s)
        end

        def account_id
          oauth.fetch("account_id")
        end

        def allows_access_for?(required_scopes)
          required_scopes.any? { |scope| scopes.include?(scope) }
        end

        private

        def oauth
          @oauth ||= response_hash.fetch("oauth")
        end
      end
    end
  end
end
