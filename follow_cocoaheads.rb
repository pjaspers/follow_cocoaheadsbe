# Follow everyone who filled in his twitter on the cocoaheads twitter page
# If you're already following someone it won't follow him again
# 1. Plug in your google and twitter account details below
# 2. Run it
# 3. See you in Ghent !
# http://cocoaheads.be/wordpress/2009/09/cocoaheads-belgium-enthousiasts-on-twitter/
# You'll need the google spreadsheet gem (http://github.com/gimite/google-spreadsheet-ruby/tree/master) and the twitter gem


require "rubygems"
require "google_spreadsheet"
require 'twitter'
require 'activesupport'

google_user = "xxxxxxxxxx"
google_pw   = "xxxxxxxxxx"
twitter_user  = "xxxxxxxxxx"
twitter_pw    = "xxxxxxxxxx"
# set it as you like
open_url_in_safari = true
follow_on_twitter = false
session = GoogleSpreadsheet.login(google_user, google_pw)

ws = session.spreadsheet_by_key("0AnofOeVdrQL-dG9DdksyWWM0dFMxdDlMUUU0SlZNWkE").worksheets[0]

# Not even thinking of doing oauth…
httpauth = Twitter::HTTPAuth.new(twitter_user, twitter_pw)
client = Twitter::Base.new(httpauth)

# Skip the header
for row in 2..ws.num_rows
  fullname  = ws[row,1]
  user      = ws[row,2]
  url       = ws[row,3]
  user.tr!("@","")
  if follow_on_twitter
    # As seen on http://blog.10to1.be/rails/2009/08/14/present/
    # But I did have to require activesupport for it to work
    if user.present?
      puts "Attempting to follow #{fullname} (@#{user})"
     begin
             client.friendship_create(user)
             puts "success"
     rescue
             puts "******* Failed  #{$!.message}"
     end
    else
      puts "Can't find twitter for #{fullname}"
    end
  end
  
  if url.present? and open_url_in_safari
    `open -a safari #{url}`
  end
end
