# General configuration
config[:domain]                  = 'homekit.family'
config[:www_prefix]              = false
config[:cloudfront_distribution] = 'E8RCPL2WH8YV8'
config[:twitter_owner]           = 'wossname'
config[:twitter_creator]         = 'mathie'
config[:fb_app_id]               = '1598536190461823'
config[:gtm_id]                  = 'GTM-PWKNWJ'
config[:google_plus_id]          = '108986677544246298780'

# Generic metadata
config[:short_title]   = 'The HomeKit Family'
config[:long_title]    = "#{config[:short_title]}: setting up a family home with Apple HomeKit"
config[:description]   = "We're having a wee experiment to see what it's like to live in an iOS-centric geek family home, and what home automation can do for us."
config[:logo]          = 'wossname-industries.png'
config[:company]       = 'Wossname Industries'
config[:company_url]   = 'https://woss.name/'
config[:telephone]     = '+44 (0)7949 077744'
config[:location]      = 'Teignmouth, Devon, United Kingdom'
config[:site_category] = "Software Development"
config[:site_tags]     = [ ]

config[:related] = {
  facebook: 'https://www.facebook.com/wossname-industries',
  twitter:  "https://twitter.com/#{config[:twitter_owner]}",
  google:   'https://plus.google.com/+WossnameIndustries',
  linkedin: 'https://www.linkedin.com/company/wossname-industries'
}

# UTM-related bits
config[:default_utm_medium] = 'website'
config[:default_utm_campaign] = 'The HomeKit Family'

# Mailing list signup form configuration
config[:mailchimp_url]      = "//family.us1.list-manage.com/subscribe/post?u=e2954746a3d6f76209fcd2a6a&amp;id=3aec9c4330"
config[:mailchimp_group_id] = "5181"
config[:mailchimp_antispam] = "b_e2954746a3d6f76209fcd2a6a_3aec9c4330"

# Calculated configuration
config[:hostname]           = config[:www_prefix] ? "www.#{config[:domain]}" : config[:domain]
config[:url]                = "https://#{config[:hostname]}"
config[:email_address]      = "hello@#{config[:domain]}"
config[:default_utm_source] = config[:domain]
config[:gravatar]           = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(config[:email_address])}"
config[:copyright]          = "Copyright &copy; 2015-#{Time.now.year} #{config[:company]}. All rights reserved."

set :markdown_engine, :redcarpet

# Pages with no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# General configuration
activate :directory_indexes
activate :asset_hash
activate :gzip
activate :automatic_image_sizes
activate :relative_assets
activate :livereload

activate :external_pipeline,
  name: :gulp,
  command: "./node_modules/gulp/bin/gulp.js #{build? ? 'build' : 'serve'}",
  source: 'intermediate/'

# Build-specific configuration
configure :build do
  activate :minify_html
end

activate :s3_sync do |s3|
  s3.bucket                = config[:hostname]
  s3.aws_access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  s3.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end

activate :cloudfront do |cf|
  cf.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  cf.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  cf.distribution_id   = config[:cloudfront_distribution]
  cf.filter            = /\.(html|xml|txt)$/
end

# Set cache-control headers to revalidate pages, but everything else is
# asset-hashed, so can live forever.
caching_policy 'text/html',       max_age: 0, must_revalidate: true
caching_policy 'application/xml', max_age: 0, must_revalidate: true
caching_policy 'text/plain',      max_age: 0, must_revalidate: true

default_caching_policy max_age: (60 * 60 * 24 * 365)
