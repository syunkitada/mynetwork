module.exports = function(grunt) {

    grunt.initConfig({
        coffee: {
            build: {
                options: {
                    join: true,
                },
                files: {
                    'public/js/index.js': [
                        'js_src/coffee/index/base.coffee',
                    ],
                }
            }
        },
        watch: {
            options: {
                interval: 1000
            },
            coffee: {
                files: ['js_src/coffee/**'],
                tasks: ['coffee'],
                options: {
                    livereload: true
                }
            },
            views: {
                files: [
                    'views/**',
                    'routes/**',
                    'public/css/**',
                ],
                options: {
                    livereload: true,
                }
            }
        }
    });

    // パッケージの自動読み込み
    var pkg = grunt.file.readJSON('package.json');
    var taskName;
    for (taskName in pkg.devDependencies) {
        if (taskName.substring(0, 6) == 'grunt-') {
            grunt.loadNpmTasks(taskName);
        }
    }

    // grunt.registerTask('default', ['cssmin', 'watch'])
    grunt.registerTask('default', ['coffee', 'watch'])
};
