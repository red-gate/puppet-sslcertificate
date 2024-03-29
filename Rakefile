require 'rake'
require 'rake_performance'
require 'find'
require 'fileutils'
require 'bundler/setup'

# always destroy the kitchen when running within Teamcity
destroy_strategy = ENV['TEAMCITY_VERSION'] ? 'always' : 'passing'
color = ENV['TEAMCITY_VERSION'] ? '--no-color' : '--color'
ENV['PUPPET_COLOR'] = '--color false' if ENV['TEAMCITY_VERSION']
rootdir = File.dirname(__FILE__)

namespace :acceptance do
  desc 'Install puppet modules from Puppetfile'
  task :installpuppetmodules do
    sh 'bundle exec r10k puppetfile install --verbose'
  end

  desc 'Execute the acceptance tests'
  task kitchen: [:installpuppetmodules] do
    begin
      Dir.mkdir('.kitchen') unless Dir.exist?('.kitchen')
      sh "kitchen test --destroy=#{destroy_strategy} --concurrency 2 --log-level=info #{color} 2> .kitchen/kitchen.stderr" do |ok, _|
        raise IO.read('.kitchen/kitchen.stderr') unless ok
      end
    ensure
      puts "##teamcity[publishArtifacts '#{Dir.pwd}/.kitchen/logs/*.log => logs.zip']"
    end
  end
end

namespace :check do
  namespace :manifests do
    desc 'Validate syntax for all manifests'
    task :syntax do
      Bundler.with_unbundled_env  do
        # Use bundler.with_clean_env as the way bundler set ruby environment variables
        # is killing puppet on windows.
        sh "puppet parser validate #{rootdir}"
      end
    end

    require 'puppet-lint/tasks/puppet-lint'
    Rake::Task[:lint].clear
    desc 'puppet-lint all the manifests'
    PuppetLint::RakeTask.new :lint do |config|
      # List of checks to disable
      config.disable_checks = %w(80chars trailing_whitespace 2sp_soft_tabs hard_tabs)

      config.relative = true
    end
  end

  namespace :ruby do
    desc 'Validate syntax for all ruby files'
    task :syntax do
      Dir.glob('**/*.rb').each do |ruby_file|
        sh "ruby -c #{ruby_file}"
      end
      Dir.glob('**/*.erb').each do |erb_file|
        sh "erb -P -x -T '-' #{erb_file} | ruby -c"
      end
    end
  end
end

task checks: ['check:manifests:syntax', 'check:manifests:lint', 'check:ruby:syntax']
task default: :checks
