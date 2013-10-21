$:.push "#{ ENV[ 'HEL' ] }/compass-spex/lib"
require 'spex'

project_path = '.'
http_path = "/"
css_dir = "css"
sass_dir = "css"
images_dir = "images"
javascripts_dir = "js"

output_style = :compressed

relative_assets = true

line_comments = false
preferred_syntax = :sass
sass_options = { :precision => 8 }
add_import_path "#{ ENV[ 'HEL' ] }/compass-spex/lib/stylesheets"
