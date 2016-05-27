require 'cgi'

task default: :build

desc 'Install all the dependencies -- rubygems, node packages, and bower components.'
task :deps do
  bundle :install
  npm    :install
  bower  :install
end

desc 'Build the site and stick the output in build/.'
task :build do
  middleman :build
end

desc 'Deploy the site to S3. Assumes you have AWS credentials in your environment. It assumes you have already run :build.'
task :deploy do
  middleman :sync
  middleman :invalidate

  Rake::Task['ping'].invoke
end

task :ping do
  domain = File.basename File.dirname(__FILE__)
  sitemap = "https://#{domain}/sitemap.xml"

  [
    'http://www.google.com/webmasters/tools/ping?sitemap=',
    'http://www.bing.com/ping?sitemap='
  ].each do |base_url|
    url = base_url + CGI.escape(sitemap)
    sh "curl '#{url}'"
  end
end

desc 'Clobber all the bits that are built with the :build task.'
task :clean do
  gulp :clean
  sh 'rm -rf build'
end

desc 'Clobber everything, including locally installed node packages and bower components.'
task distclean: :clean do
  gulp :distclean
end

def bundle(command, args = '')
  sh "bundle #{command} #{args}"
end

def middleman(command)
  middleman_args = (verbose == true) ? '--verbose' : ''

  bundle :exec, "middleman #{command} #{middleman_args}"
end

def gulp(task)
  sh "node_modules/gulp/bin/gulp.js #{task}"
end

def bower(command)
  sh "node_modules/bower/bin/bower #{command}"
end

def npm(command)
  sh "npm #{command}"
end
