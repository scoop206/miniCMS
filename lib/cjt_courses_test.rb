site = Site.find_by_name('energymanagementu')
# cjts = CourseJobTitle.all
cjt = CourseJobTitle.first
courses = cjt.courses_for_site(site)
p "CourseJobTitle.name is: #{cjt.name}"
p courses.size