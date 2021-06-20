(function() {

  function init_form_ticket_priority() {
    let $form_ticket_priority = $('#js-form-ticket-priority')

    if ($form_ticket_priority.length == 0) return

    $form_ticket_priority.find('.js-picker-color').spectrum({
      locale: 'es',
      palette: [
        [
          '#556ee6',
          '#34c38f',
          '#50a5f1',
          '#f1b44c',
        ],
        [
          '#f46a6a',
          '#343a40',
          '#74788d',
        ]
      ]
    })
  }

  function init_ticket_statuses_sortable() {
    let $ticket_statuses = $('#js-ticket-statuses-sortable')

    if ($ticket_statuses.length == 0) return

    $ticket_statuses.railsSortable()
  }

  function init_form_search_tickets() {
    var $form_search_tickets = $('#js-form-search-tickets')

    if ($form_search_tickets.length == 0) return

    $form_search_tickets.find('#js-clear-filter').on('click', function () {
      setTimeout(() => {
        $form_search_tickets.find('.form-control').val('')
        $form_search_tickets.submit()
      }, 250)
    })
  }

  function init_form_ticket() {
    var $form_ticket =  $('#js-form-ticket')

    console.log($form_ticket)

    if ($form_ticket.length == 0) return

    $form_ticket.find('#js-btn-new-client').on('click', function () {
      console.log('sssssssss')
      $(this).closest('.form-group').hide();
      $form_ticket.find('#js-form-client-fields').fadeIn();
      $form_ticket.find('#ticket_client_source').val('form_client')
    })
  }

  $(document).on('turbolinks:load', function() {
    init_form_ticket_priority()
    init_ticket_statuses_sortable()
    init_form_search_tickets()
    init_form_ticket()
  })

}).call(this);
