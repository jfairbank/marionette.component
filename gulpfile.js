// Gulp modules
var gulp   = require('gulp');
var wrap   = require('gulp-wrap-umd');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var header = require('gulp-header');
var jshint = require('gulp-jshint');
var clean  = require('gulp-clean');
var coffee = require('gulp-coffee');
var mocha  = require('gulp-mocha');

// Other modules
var runSequence = require('run-sequence');

// Build variables
var name        = 'marionette.component';
var filename    = name + '.js';
var minFilename = name + '.min.js';
var distPath    = 'dist';
var srcPath     = 'src';
var srcFile     = srcPath + '/' + filename;
var distFile    = distPath + '/' + filename;
var distFiles   = distPath + '/*.js';

// Wrap in a UMD
// =============
gulp.task('wrap', function() {
  return gulp.src(srcFile)
    .pipe(wrap({
      namespace: 'Marionette.Component',
      exports: 'Component',
      deps: [
        { name: 'marionette', globalName: 'Marionette', paramName: 'Marionette' }
      ]
    }))
    .pipe(gulp.dest(distPath));
});

// Uglify
// ======
gulp.task('uglify', function() {
  return gulp.src(distFile)
    .pipe(uglify())
    .pipe(rename(minFilename))
    .pipe(gulp.dest(distPath));
});

// Add headers
// ===========
gulp.task('header', function() {
  var pkg = require('./package.json');
  var banner = [
    '/**',
    ' * <%= pkg.name %> - <%= pkg.description %>',
    ' * @version v<%= pkg.version %>',
    ' * @copyright (c) <%= year %> <%= pkg.author.name %>',
    ' * @link <%= pkg.homepage %>',
    ' * @license <%= pkg.license %>',
    ' */',
    ''
  ].join('\n');

  return gulp.src(distFiles)
    .pipe(header(banner, { pkg: pkg, year: (new Date()).getFullYear() }))
    .pipe(gulp.dest(distPath));
});

// Lint
// ====
gulp.task('lint', function() {
  return gulp.src(srcFile)
    .pipe(jshint());
});

// Testing
// =======
gulp.task('cleanTests', function() {
  return gulp.src('spec/javascript', { read: false })
    .pipe(clean());
});

gulp.task('buildTests', ['cleanTests'], function() {
  return gulp.src('spec/coffee/*.spec.coffee')
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest('spec/javascript'));
});

gulp.task('buildTestLib', function() {
  return gulp.src(srcFile)
    .pipe(wrap({
      namespace: 'Marionette.Component',
      exports: 'Component'
    }))
    .pipe(gulp.dest('spec/support'));
});

gulp.task('runTests', ['buildTests', 'buildTestLib'], function() {
  var files = ['spec/support/setup.js', 'spec/javascript/*.js'];

  require('./spec/support/environment');

  return gulp.src(files, { read: false })
    .pipe(mocha({ reporter: 'nyan' }));
});

gulp.task('test', function(callback) {
  runSequence('lint', 'runTests', callback);
});

// Build
// =====
gulp.task('buildLib', function(callback) {
  runSequence('wrap', 'uglify', 'header', callback);
});

gulp.task('build', function(callback) {
  runSequence('lint', 'buildLib', callback);
});

// Default
// =======
gulp.task('default', function(callback) {
  runSequence('lint', 'runTests', 'buildLib', callback);
});
