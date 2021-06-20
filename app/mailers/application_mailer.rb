class ApplicationMailer < ActionMailer::Base
  default from: 'notificaciones@geosatelital.com'
  #layout 'mailer'
  layout 'bootstrap-mailer'
end
