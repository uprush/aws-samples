require 'yaml'
require_relative 'basic_activity.rb'

# **GetContactActivity** provides a prompt for the user to enter contact
# information. When the user successfully enters contact information, the
# activity is complete.
class GetContactActivity < BasicActivity

  # initialize the activity
  def initialize
    super 'get_contact_activity'
  end

  def do_activity(task)
    puts ""
    puts "Please enter either an email address to receive SNS notifications."

    input_confirmed = false
    while !input_confirmed
      puts ""
      print "Email: "
      email = $stdin.gets.strip

      puts ""
      if email == ''
        print "You provided no subscription information. Quit? (y/n)"
        confirmation = $stdin.gets.strip.downcase
        if confirmation == 'y'
          return false
        end

      else
        puts "You entered:"
        puts "  email: #{email}"
        print "\nIs this correct? (y/n): "
        confirmation = $stdin.gets.strip.downcase
        if confirmation == 'y'
          input_confirmed = true
        end
      end
    end # while

    # make sure that @results is a single string. YAML makes this easy.
    @results = { :email => email, :sms => '' }.to_yaml
    return true
  end

end