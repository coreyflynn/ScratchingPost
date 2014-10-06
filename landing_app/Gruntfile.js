'use strict';

var request = require('request');

module.exports = function (grunt) {
  // show elapsed time at the end
  require('time-grunt')(grunt);
  // load all grunt tasks
  require('load-grunt-tasks')(grunt);

  var reloadPort = 35729, files;

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    develop: {
      server: {
        file: 'app.js'
      }
    },

    // configure compilation of sccs to css
    sass: {
        dist: {
          options: {
            style: 'expanded'
          },
          files: {
            'public/css/CLUE.css': 'public/css/CLUE.scss'
          }
        }
    },

    // watch task
    watch: {
      options: {
        nospawn: true,
        livereload: reloadPort
      },
      server: {
        files: [
          'app.js',
          'routes/*.js',
          'views/**/*.jade'
        ],
        tasks: ['develop', 'delayed-livereload']
      },
      js: {
        files: ['public/js/*.js'],
        options: {
          livereload: reloadPort
        }
      },
      css: {
        files: ['public/css/*.css'],
        options: {
          livereload: reloadPort
        }
      },
      sass: {
          files: ['public/css/*.scss','public/css/scss/*.scss'],
          tasks: ['sass compile']
      },
      views: {
        files: ['views/*'],
        options: {
          livereload: reloadPort
        }
      }
    }
  });

  grunt.config.requires('watch.server.files');
  files = grunt.config('watch.server.files');
  files = grunt.file.expand(files);

  grunt.registerTask('delayed-livereload', 'Live reload after the node server has restarted.', function () {
    var done = this.async();
    setTimeout(function () {
      request.get('http://localhost:' + reloadPort + '/changed?files=' + files.join(','),  function (err, res) {
          var reloaded = !err && res.statusCode === 200;
          if (reloaded) {
            grunt.log.ok('Delayed live reload successful.');
          } else {
            grunt.log.error('Unable to make a delayed live reload.');
          }
          done(reloaded);
        });
    }, 500);
  });

  // load the plugin that provides the "sass" task
  grunt.loadNpmTasks('grunt-contrib-sass');

  grunt.registerTask('default', ['develop', 'watch']);
  grunt.registerTask('sass compile',['sass']);
};
