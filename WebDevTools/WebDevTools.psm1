<#
.Synopsis
   creates a standard web development environment with npm and gulp
.DESCRIPTION
   Creates a standard web development environment with npm, gulp, app folder, wwwroot
   folder, js folder, css folder, fonts folder, images folder, scss folder and a index.html. gulp packages installed are
   glup, glup-concat, gulp-uglify, gulp-sass, browser-sync, gulp-cssnano, del. a default gulpfile can also be added by adding
   the -gulpfile switch. default tasks are added in the gulpfile and assume that the defualt DevGulpPackages are installed.
   Parameters are provided to rename each of the folders. see the full help for examples.
.EXAMPLE
    c:\funtimes, c:\webtime | New-WebEnvironment

    ========description============
   Creates the web environment with all the default folders and not gulp file for each of the paths provided by the pipeline
   folder structure is
   C:\
   -funtimes
   --app
   ---css
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json

   and

   folder structure is
   C:\
   -webtime
   --app
   ---css
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json
.EXAMPLE
   New-WebEnvironment c:\funtimes

   ========description============
   Creates the web environment with all the default folders and not gulp file
   folder structure is
   C:\
   -funtimes
   --app
   ---css
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json
.EXAMPLE
   New-WebEnvironment c:\funtimes -gulpfile

   ========description============
   Creates the web environment with all the default folders and with gulp file
.EXAMPLE
    New-WebEnvironment c:\funtimes -AppFolder funapp
    
    ========description============
   Creates the web environment with an application folder named funapp and all the rest are default folders and not gulp file
   folder structure is
   C:\
   -funtimes
   --funapp
   ---css
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json
.EXAMPLE
    New-WebEnvironment c:\funtimes -CssFolder funcss
    
    ========description============
   Creates the web environment with an css folder named funcss and all the rest are default folders and not gulp file
   folder structure is
   C:\
   -funtimes
   --app
   ---funcss
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json
.EXAMPLE
    New-WebEnvironment c:\funtimes -FontFolder funfonts
    
    ========description============
   Creates the web environment with an font folder named funfonts and all the rest are default folders and not gulp file
   folder structure is
   C:\
   -funtimes
   --funapp
   ---css
   ---fonts
   ---images
   ---js
   ---scss
   ---index.html
   --wwwroot
   --package.json
.EXAMPLE
    New-WebEnvironment c:\funtimes -DevGulpPackages gulp, gulp-uglify, del
    
    ========description============
    DevGulpPackages takes a comma seperated list of packages to install into the dev section of the package.json file.
    defaults are 'gulp','gulp-concat','gulp-uglify','gulp-sass','browser-sync','gulp-cssnano', 'del','typescript' 
.EXAMPLE
    New-WebEnvironment c:\funtimes -DependancyPackages jquery, bootstrap, typescript
    
    ========description============
   DependancyPackages takes a comma seperated list of packages to install into the dependancy section of the package.json file.
   defaults 'jquery','bootstrap'
#>
function New-WebEnvironment
{
    [CmdletBinding()]
    [Alias("cwe")]
    Param
    (
        # path for web environment to be created
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path,

        # Turns on whether or not to create a gulpfile.js
        [Parameter(Mandatory=$false)]
        [switch]
        $gulpfile,

        # array of gulp or npm packages to be installed in the dev environment
        [Parameter(Mandatory=$false, position=9)]
        [string[]]
        $DevGulpPackages = @('gulp','gulp-concat','gulp-uglify','gulp-sass','browser-sync','gulp-cssnano', 'del','typescript'),

        #array of gulp or npm packages to be installed in the dependency environment
        [Parameter(Mandatory=$false, position=10)]
        [string[]]
        $DependencyPackages= @('jquery','bootstrap'),

        #folder name for the application files to be stored in. this is created at the path provided. default is app
        [Parameter(Mandatory=$false, position=1)]
        [string]
        $AppFolder = 'app',

        #folder name for css files within the application default is css
        [Parameter(Mandatory=$false, position=2)]
        [string]
        $CssFolder = 'css',

        #folder name for font files within the applicaion default is fonts
        [Parameter(Mandatory=$false, position=3)]
        [string]
        $FontFolder = 'fonts',

        #folder name for images in the application. default is images
        [Parameter(Mandatory=$false, position=4)]
        [string]
        $ImageFolder = 'images',

        #folder name for javascript files within the application. default is js
        [Parameter(Mandatory=$false, position=5)]
        [string]
        $JsFolder = 'js',

        #folder name for SASS css files within the application. default is scss
        [Parameter(Mandatory=$false, position=6)]
        [string]
        $SassFolder = 'scss',

        #folder name for main html file in the application. default is index.html
        [Parameter(Mandatory=$false, position=7)]
        [string]
        $HtmlFileName = 'index.html',
        
        #folder name for the distribution files for the project. default is wwwroot
        [Parameter(Mandatory=$false, position=8)]
        [string]
        $DistributionFolder = 'wwwroot'
    )

    Begin
    {
        if(-not $env:Path.Contains("npm"))
        {
            Write-Error("You Must install nodejs before running this cmdlet. 
            Get node from https://nodejs.org.")
            break
        }
        $currentlocation = Get-Location
    }
    Process
    {
        
        $AppPath = $Path +"/" +$AppFolder
        Write-Verbose("Creating project structue at " + $Path)
        New-Item -Path $Path -Name $AppFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $CssFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $FontFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $ImageFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $JsFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $SassFolder -ItemType directory | Out-Null
        New-Item -Path $AppPath -Name $HtmlFileName -ItemType file | Out-Null
        New-Item -Path $Path -Name $DistributionFolder -ItemType directory | Out-Null
        New-Item -Path $Path -Name package.json -ItemType file | Out-Null
        Write-Verbose("Creating package.json")
        Add-Content -path ($Path+"/package.json") -Value '{
  "name": "",
  "version": "1.0.0",
  "description": "default description",
  "main": "index.html",
  "repository": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' | Out-Null
                        
        if($gulpfile)
        {
            Write-Verbose("Creating gulpfile.js")
            New-Item $Path -Name gulpfile.js -ItemType file | Out-Null
            Add-Content -Path ($Path + "/gulpfile.js") -Value "var gulp = require('gulp');
var sass = require('gulp-sass');
var browserSync = require('browser-sync').create();
var  useref = require('gulp-useref');
var uglify = require('gulp-uglify');
var prefixer = require('gulp-autoprefixer');
var gulpif = require('gulp-if');
var nano = require('gulp.cssnano');
var sourcemap = require('gulp-sourcemaps');
var del = require('del');
var runSequence = require('run-sequence');

//build tasks
gulp.task('useref',function(){
    return gulp.src('app/*html')
    .pipe(useref())
    .pipe(gulpif('*.js', uglify()))
    .pipe(gulpif('*.css',prefixer()))
    .pipe(gulpif('*.css',nano()))
    .pipe(sourcemap.write('.'))
    .pipe(gulp.dest('wwwroot'))
});

gulp.task('fonts', () =>{
    return gulp.src('app/fonts/**/*')
    .pipe(gulp.dest('wwwroot/fonts'))
});

gulp.task('clean:dist',()=>{
    return del.sync('wwwroot');

});

//development tasks
gulp.task('browserSync', function(){
    browserSync.init({
        server:{
            baseDir: 'app'
        },
    })
});

gulp.task('sass', function(){
    return gulp.src('app/scss/**/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('app/css'))
    .pipe(browserSync.reload({
        stream: true
    }))
});

gulp.task('watch',['browserSync','sass'], function(){
    gulp.watch('app/scss/**/*.scss',['sass']);
    gulp.watch('app/*.html',browserSync.reload);
    gulp.watch('app/js/**/*.js',browserSync.reload);
});

//run tasks
gulp.task('buld',function(callback){
    runSequence('clean:wwwroot',['sass','useref','fonts'],callback)
});

gulp.task('default', function(callback){
    runSequence(['sass','browserSync','watch'])
});" | Out-Null
        } 
        Write-Verbose("Installing gulp packages")
        
        Set-location -Path $Path
        foreach ($item in $DevGulpPackages)
        {
            Write-Verbose("Installing " + $item + " in Dev dependencies")
            npm install $item --save-dev --silent | Out-Null
        }
        foreach($item in $DependencyPackages)
        {
            Write-Verbose("Installing " + $item + " in Dependencies")
            npm install $item --save --silent | Out-Null
        }
    }
    End
    {
        Set-Location $currentlocation
    }
}
Export-ModuleMember -function New-WebEnvironment