module Gitlab
  class Request
    def raw_get(path, options={})
      set_private_token_header(options)
      response = self.class.get(path, options)
      raw_validate response

      response.body
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      raw_validate response

      response.parsed_response
    end

    def raw_validate(response)
      case response.code
        when 400; raise Error::BadRequest.new error_message(response)
        when 401; raise Error::Unauthorized.new error_message(response)
        when 403; raise Error::Forbidden.new error_message(response)
        when 404; raise Error::NotFound.new error_message(response)
        when 405; raise Error::MethodNotAllowed.new error_message(response)
        when 409; raise Error::Conflict.new error_message(response)
        when 500; raise Error::InternalServerError.new error_message(response)
        when 502; raise Error::BadGateway.new error_message(response)
        when 503; raise Error::ServiceUnavailable.new error_message(response)
      end
    end
  end
end
