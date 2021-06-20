class TicketIssuesController < ApplicationController
  before_action :set_ticket_issue, only: %i[ show edit update destroy ]

  def showimei
    k = params[:id]
    conn = Faraday.new(url: ENV["GEO_API_URL"].to_s) do |faraday|
      faraday.use Faraday::Request::UrlEncoded
      faraday.use Faraday::Response::Logger
      faraday.use Faraday::Adapter::NetHttp
    end

    response = conn.get do |req|
      req.url "ticket/gps/details"
      req.headers['GEOAPI_APIKEY'] = ENV['GEOAPI_APIKEY'].to_s
      req.params['imei'] = k
      req.params['apikey'] = ENV['GEOAPI_APIKEY'].to_s
    end

    body = JSON.parse(response.body) rescue {}

    case response.status
    when 200..201
       @result = body
    end
    #render plain: @result.inspect

    respond_to do |f|
      f.js
    end
    
  end
  
  def show
      k=@ticket_issue.issue_id

      conn = Faraday.new(url: ENV["MONITORING_URL"].to_s) do |faraday|
        faraday.use Faraday::Request::UrlEncoded
        faraday.use Faraday::Response::Logger
        faraday.use Faraday::Adapter::NetHttp
      end

      response = conn.get do |req|
        req.url "api/v1/issues/search"
        req.headers['X-GEO-APIKEY'] = ENV['X_GEO_APIKEY'].to_s
        req.params['q'] = k
      end

      body = JSON.parse(response.body) rescue {}

      case response.status
      when 200..201
         @result = body
      end

      respond_to do |f|
        f.js
      end
  end
      #/api/v1/issues/search/?q=33
      # url='http://198.12.248.199:3030/api/issues/search/'+k.to_s
      # resp = Faraday.get(url)
      # @result = ActiveSupport::JSON.decode(resp.body)
      #render plain: @result.inspect
  def create
    @issue = TicketIssue.new(issue_permit)
    if @issue.save
      redirect_to @issue
    else
      render plain: @issue.inspect
    end
  end

  private
  def set_ticket_issue
    @ticket_issue = TicketIssue.find(params[:id])

  end

  def issue_permit
    params.require(:issue).permit(:issue_id, :cliente, :cliente_id, :imei, :ticket_id)
  end
end
