class Changelog < ActiveRecord::Base
  
  default_scope :order => "date DESC"
  
  def self.add(user, text)
    cl = Changelog.new
    cl.user = user
    cl.text = text
    cl.date = DateTime.now
    cl.save!
    cl
  end
  
  validates_presence_of :user, :date
    

end
