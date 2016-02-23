class Webhooks::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_signature

  protected

  def invalidate_request_and_log(message)
    logger.info "Failing with 422 because: #{message}"
    head 422
  end

  def verify_signature
    Rails.logger.debug "bookingsync_hook_raw_post: #{request.raw_post}"
    unless signature == request.headers["X-Content-Signature"]
      invalidate_request_and_log "Bad BookingSync signature"
    end
  end

  def signature
    OpenSSL::HMAC.hexdigest(digest, ENV["BOOKINGSYNC_APP_SECRET"],
      base64_encoded_payload)
  end

  def digest
    OpenSSL::Digest::Digest.new("sha1")
  end

  def base64_encoded_payload
    Base64.encode64(request.raw_post)
  end
end
