require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList[
    'spec/api/*_spec.rb',
    'spec/integration/*_spec.rb',
    'spec/models/*_spec.rb',
    'spec/presenters/*_spec.rb',
    'spec/utils/*_spec.rb',
    'spec/validators/*_spec.rb'
  ]
end

def load_env
  env_loaded = require_relative "config/environment"
  if env_loaded
    Sequel.extension :migration
    puts "#{ENV['RACK_ENV']} environment loaded!"
  end
end

task :default => :spec
task :c => :console

task :console do
  ENV['RACK_ENV'] = 'development'
  load_env
  require 'pry'
  ARGV.clear
  Pry.start
end

namespace :db do

  MIGRATIONS_PATH = "db/migrations"

  desc "Prints current schema version"
  task :version do
    load_env
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    load_env
    Sequel::Migrator.run(DB, MIGRATIONS_PATH)
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    load_env
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, MIGRATIONS_PATH, :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    load_env
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, :target => 0)
    Sequel::Migrator.run(DB, MIGRATIONS_PATH)
    Rake::Task['db:version'].execute
  end

  desc "Seeds a database with fixture data"#FIXME: should take always development db
  task :seed do
    ENV['RACK_ENV'] = 'development'
    load_env
    begin
      employee = Fabricate(:employee)
      Fabricate(:employee, rut: 13045674, name: "Claudia")
      Fabricate(
        :clock, employee: employee,
        clock_in: (DateTime.now + Rational(3600, 86400)),
        clock_out: (DateTime.now + Rational(3600*8, 86400)),
        total_hours: 7
      )
      Fabricate(:clock, employee: employee,
        clock_in: (DateTime.now + Rational(3600*24, 86400))
      )
      puts "Data generated."
    rescue
      puts "Data looks stale, you may want to run rake db:reset first."
    end
  end
end
