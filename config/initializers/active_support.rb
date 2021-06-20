# Be sure to restart your server when you modify this file.

class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime("%d/%m/%Y %H:%M:%S")
  end
end
