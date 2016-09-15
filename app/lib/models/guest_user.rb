require_relative 'user.rb'
class GuestUser < User

  def save(options = {})
    super(options.merge(validate: false))
  end

  def name
    "Guest"
  end
end
