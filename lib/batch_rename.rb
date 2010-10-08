# point the dir at whatever directory where you want to change every file name
# from .shtml to .html.erb
# if you pass true for second parameter that in addition an underscore will be appended
# onto the front of the new file name

dir = "/Users/scooper/Documents/chgworks/sites/du/app/views/nascus_stage"
# dir = "#{RAILS_ROOT}/test/fixtures/files/shtml_conversion"
DuMigrationUtils.convert_dirs_filenames_to_erb(dir, is_partials = false)