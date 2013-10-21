module.exports =
 ( grunt ) ->
  grunt
   .initConfig
               pkg:
                grunt
                 .file
                 .readJSON "package.json"
               proj:
                html:
                 "."
                css:
                 "css"
                js:
                 "js"
               coffee:
                compile:
                 files:
                  [
                    expand:
                     yes
                    cwd:
                     "<%= proj.js %>"
                    src:
                     "*.coffee"
                    dest:
                     "<%= proj.js %>"
                    ext:
                     ".js" ]
               compass:
                compile:
                 {}
               haml:
                dev:
                 files:
                  'orders.html':
                   'orders.haml'
               livereload:
                port:
                 35729
               regarde:
                livereload:
                 files:
                  [ '<%= proj.css %>/*.css',
                    '<%= proj.js %>/*.js',
                    '<%= proj.html %>/*.html' ]
                 tasks:
                  [ 'livereload' ]
                coffee:
                 files:
                  [ '<%= proj.js %>/*.coffee' ]
                 tasks:
                  [ 'coffee:compile' ]
                compass:
                 files:
                  [ '<%= proj.css %>/*.sass' ]
                 tasks:
                  [ 'compass:compile' ]
                haml:
                 files:
                  [ '<%= proj.html %>/*.haml' ]
                 tasks:
                  [ 'haml' ]

  grunt
   .loadNpmTasks "grunt-regarde"
  grunt
   .loadNpmTasks "grunt-contrib-coffee"
  grunt
   .loadNpmTasks "grunt-contrib-compass"
  grunt
   .loadNpmTasks "grunt-contrib-haml"
  grunt
   .loadNpmTasks "grunt-contrib-livereload"

  grunt
   .registerTask "default",
                 [ "livereload-start",
                   "regarde" ]
