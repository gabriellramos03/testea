class PlayersController < ApplicationController
  include HTTParty

  def index
    api_url = "https://www.sofascore.com/api/v1/unique-tournament/1/season/56953/statistics"

    query_params = {
      limit: 20,
      order: "-rating",
      offset: 20,
      accumulation: "total",
      group: "summary"
    }

    response = HTTParty.get(api_url, query: query_params)

    if response.success?
      render json: response.parsed_response
    else
      render json: { error: "Erro ao buscar dados da API" }, status: :bad_request
    end
  end
end
