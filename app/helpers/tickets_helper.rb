module TicketsHelper
  SKOTE_COLORS = {
    '#556ee6' => 'primary',
    '#34c38f' => 'success',
    '#50a5f1' => 'info',
    '#f1b44c' => 'warning',
    '#f46a6a' => 'danger',
    '#343a40' => 'dark',
    '#74788d' => 'secondary',
  }.freeze

  def render_ticket_priority(ticket)
    css_class = SKOTE_COLORS[ticket.priority_color]

    if css_class.nil?
      "<span class='badge font-size-12' style='background-color: #{ticket.priority_color}; color: #fff;'>
        #{ticket.priority_name || '-'}
      </span>".html_safe
    else
      "<span class='badge badge-#{css_class} font-size-12'>
        #{ticket.priority_name || '-'}
      </span>".html_safe
    end
  end
end
