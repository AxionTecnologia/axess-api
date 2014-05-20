require File.expand_path('../boot', __FILE__)

class Project
  def self.root
    File.expand_path( '..',File.dirname( __FILE__ ))
  end

  def self.join(path)
    File.join(self.root,path)
  end
end

#Load gems for the corresponding env
Bundler.require :default, ENV['RACK_ENV']

I18n.enforce_available_locales = true

#Load db config stuff
db_config = YAML.load_file(Project.join('config/database.yml'))[ENV['RACK_ENV']]

db_options = Hash.new
db_options[:logger] = Logger.new('log/db.log') unless ENV['RACK_ENV'] == 'production'

DB = Sequel.connect db_config, db_options

#Load all the basic scripts

['utils','api/validators','api','models','config/initializers', 'presenters'].each do |folder|
  Dir[File.expand_path(Project.join("#{folder}/*.rb"))].each do |f|
    require f
  end
end

#Load starter app
require File.expand_path('../../main', __FILE__)
