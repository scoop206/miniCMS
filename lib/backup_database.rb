#!/usr/local/bin/ruby
#
# backup_database.rb
#
# DUCMS Backup Script

require 'rubygems'
require 'active_support'


BACKUP_LOCATION = "/var/ducms_mysql_backups"
RETENTION_PERIOD = 14
PREFIX = "ducms_backup"
MYSQL_DATABASE = "duwc"
MYSQL_USER = "root"
MYSQL_PASSWORD = "DUmysql82" 

today = Date.today

backup_base_name = PREFIX + "_" + today.strftime('%d_%m_%Y')
backup_file = backup_base_name + ".sql"
compressed_file = backup_base_name + ".tar.gz"

# switch current working directory to our backup location
Dir.chdir(BACKUP_LOCATION)

# write the mysql database to a sql file
`mysqldump -u #{MYSQL_USER} -p#{MYSQL_PASSWORD} #{MYSQL_DATABASE} > #{backup_file}`

# compress the file
`tar -czf #{compressed_file} #{backup_file}`

# copy this backup_file to DreamHost PS
# no password is needed as the servers ssh key's have been authorized
`scp #{compressed_file} duwebadmin@ps25540.dreamhost.com:/home/duwebadmin/ducms_backup/#{compressed_file}`

# Delete the non-compressed file
File.unlink(backup_file)

# remove any files that are older than the retention period
Dir.new(BACKUP_LOCATION).each do |file|
  
  if file.include?(PREFIX)
    
    date_parts = file.slice(/\d+_.*_.*\.tar.gz$/)
    day, month, year = date_parts.split('_')
    filedate = Date.new(year.to_i, month.to_i, day.to_i)
    
    # if it's too old then purge
    if filedate.advance(:days => RETENTION_PERIOD) < Date.today
      File.delete(File.join(BACKUP_LOCATION, file))
    end  
  end
end
