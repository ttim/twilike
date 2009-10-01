task :environment
task :merb_env

namespace :css do
  desc "Build all-in-one css."
  task :build => [:merb_env, :environment] do
    _all = ""
	_theme1 = ""
	_theme2 = ""
    
	dir = "D:/Rails projects/twilike/" 
	
	["main", "sidebar", "timeline", "top", "by_movie", "by_user", "one_opinion"].each do |name|
	  _all += File.read(dir+"public/stylesheets/"+name+".css")+"\n"
	  _theme1 += File.read(dir+"public/stylesheets/theme1/"+name+".css")+"\n"
	  _theme2 += File.read(dir+"public/stylesheets/theme2/"+name+".css")+"\n"
    end
	
	File.open(dir+"public/stylesheets/_all.css", "w") { |file| file.puts(_all) }
	File.open(dir+"public/stylesheets/_theme1.css", "w") { |file| file.puts(_theme1) }
	File.open(dir+"public/stylesheets/_theme2.css", "w") { |file| file.puts(_theme2) }
  end
end
