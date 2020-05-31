class ApplicationController < ActionController::Base
  class QueryError < StandardError; end

  private

    def query(definition, variables = {})
      response = GitHub::Client.query(definition, variables: variables, context: client_context)

      if response.errors.any?
        raise QueryError.new(response.errors[:data].join(", "))
      else
        response.data
      end
    end


    def client_context
      { access_token: GitHub::Application.secrets.github_access_token }
    end
end
