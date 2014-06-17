#!/usr/bin/env ruby
require_relative 'get_contact_activity.rb'
require_relative 'subscribe_topic_activity.rb'
require_relative 'wait_for_confirmation_activity.rb'
require_relative 'send_result_activity.rb'

class ActivitiesPoller

  def initialize(domain, task_list)
    @domain = domain
    @task_list = task_list
    @activities = {}

    # These are the activities we'll run
    activity_list = [
      GetContactActivity,
      SubscribeTopicActivity,
      WaitForConfirmationActivity,
      SendResultActivity ]

    activity_list.each do |activity_class|
      activity_obj = activity_class.new
      puts "** initialized and registered activity: #{activity_obj.name}"
      # add it to the hash
      @activities[activity_obj.name.to_sym] = activity_obj
    end
  end

  def poll_for_activities
    @domain.activity_tasks.poll(@task_list) do |task|
      activity_name = task.activity_type.name

      # find the task on the activities list, and run it.
      if @activities.key?(activity_name.to_sym)
        activity = @activities[activity_name.to_sym]
        puts "** Starting activity task: #{activity_name}"
        if activity.do_activity(task)
           puts "++ Activity task completed: #{activity_name}"
           task.complete!({ :result => activity.results })
           # if this is the final activity, stop polling.
           if activity_name == 'send_result_activity'
             return true
           end

        else
          puts "-- Activity task failed: #{activity_name}"
          task.fail!({
            :reason => activity.results[:reason],
            :details => activity.results[:details]
            })
        end

      else
        puts "couldn't find key in @activities list: #{activity_name}"
        puts "contents: #{@activities.keys}"
      end
    end
  end

end # Class

if ARGV.count < 1
  puts "You must supply a task-list name to use!"
  exit
end

poller = ActivitiesPoller.new(init_domain, ARGV[0])
poller.poll_for_activities
puts "All done!"
