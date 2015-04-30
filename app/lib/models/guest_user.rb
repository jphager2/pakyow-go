require_relative 'user.rb'
class GuestUser < User

  def name
    "Guest"
  end
end
