class BookingsyncApplication::Webhooks::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_signature

  protected

  def invalidate_request_and_log(message)
    logger.info "Failing with 422 because: #{message}"
    head 422
  end

  def verify_signature
    Rails.logger.debug "bookingsync_hook_raw_post: #{request.raw_post}"
    unless [old_signature, new_signature].include? request.headers["X-Content-Signature"]
      invalidate_request_and_log "Bad BookingSync signature"
    end
  end

  def old_signature
    OpenSSL::HMAC.hexdigest(digest, ENV["BOOKINGSYNC_APP_SECRET"],
      base64_encoded_payload)
  end

  def new_signature
    OpenSSL::HMAC.hexdigest(digest, ENV["BOOKINGSYNC_APP_SECRET"],
      base64_strict_encoded_payload)
  end

  def digest
    OpenSSL::Digest.new("sha1")
  end

  def base64_encoded_payload
    Base64.encode64(request.raw_post)
  end

  def base64_strict_encoded_payload
    Base64.strict_encode64(request.raw_post)
  end
end
