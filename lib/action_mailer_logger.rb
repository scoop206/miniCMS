class ActionMailerLogger < Logger

  @@location = "#{RAILS_ROOT}/log/mail.log"
  
  def initialize
    _log = File.open(@@location, 'a')
    _log.sync = true
    super _log
  end
  
  def format_message(severity, timestamp, progname, msg)
     "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end

end