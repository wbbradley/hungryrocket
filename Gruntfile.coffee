module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    coffee:
      options:
        sourceMap: false
      compile:
        files: [{
          expand: true
          cwd: 'static/coffee/'
          src: ['**/*.coffee']
          dest: 'static/js/'
          ext: '.js'
          }]

    less:
      production:
        options:
          yuicompress: true
        files:
          'static/css/site.css': 'static/less/site.less'

    watch:
      coffee:
        files: '**/*.coffee'
        tasks: ['coffee']

      less:
        files: 'static/less/**/*.less'
        tasks: ['less']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.registerTask('default', ['less', 'coffee'])
