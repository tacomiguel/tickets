class AssignIssuesToTicketJob < ApplicationJob
  queue_as :default

  def perform(ticket_id, issues_ids)
    return if issues_ids.blank? || issues_ids.class != Array

    ticket = Ticket.find_by(id: ticket_id)
    return if ticket.nil?

    conn = Faraday.new(url: ENV["MONITORING_URL"].to_s) do |faraday|
      faraday.use Faraday::Request::UrlEncoded
      faraday.use Faraday::Response::Logger
      faraday.use Faraday::Adapter::NetHttp
    end

    issues_ids.each do |issue_id|
      begin
        response = conn.get do |req|
          req.url "api/v1/issues/search"
          req.headers['X-GEO-APIKEY'] = ENV['X_GEO_APIKEY'].to_s
          req.params['q'] = issue_id
        end

        body = JSON.parse(response.body) rescue {}
        ap body
        case response.status
        when 200..201
          issue = body['data'].first
          if issue
            ticket_issue = ticket.ticket_issues.find_or_initialize_by(issue_id: issue_id)
            ticket_issue.cliente = issue['client']['name'] rescue ''
            ticket_issue.cliente_id = issue['client']['document'] rescue ''
            ticket_issue.imei = issue['vehicle']['imei'] rescue ''
            ticket_issue.save
          end
        end
      rescue Exception => e
        p "========================="
        p "Error during processing: #{$!}"
        p "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        p "========================="
      end
    end
  end

  def asign_claim_to_ticket(ticket_id,title_claim)
    nro = title_claim.toString().split("{Libro} Reclamo Nro: ")
    ti = TicketIssue.new
    ti.issue_id = nro
    ti.ticket_id = ticket_id
    ti.save
  
  end



end
