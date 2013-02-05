require 'mkmf'

def gsl_config
  'gsl-config'
end

def gsl_version
  return $gsl_version if $gsl_version

  version = nil
  IO.popen("#{gsl_config} --version") {|f| version = f.gets.chomp}
  version ? Gem::Version.new(version) : raise('Ruby/GSL requires gsl-0.9.4 or later.')
end

def gsl_cflags
  cflags = nil
  IO.popen("#{gsl_config} --cflags") {|f| cflags = f.gets.chomp}
  cflags or raise('Ruby/GSL requires gsl-0.9.4 or later')
end

def gsl_libs
  libs = nil
  IO.popen("#{gsl_config} --libs") {|f| libs = f.gets.chomp}
  libs or raise('Ruby/GSL requires gsl-0.9.4 or later')
end

$CFLAGS << " #{gsl_cflags}" 

dir_config("cblas")
dir_config("atlas")

if have_library("cblas") and have_library("atlas")
  $LOCAL_LIBS << ' ' + gsl_libs.gsub('-lgslcblas', '-lcblas -latlas')
else
  $LOCAL_LIBS << ' ' + gsl_libs
end

$defs << '-DGSL_0_9_4_LATER'   if gsl_version >= Gem::Version.new('0.9.4')
$defs << '-DGSL_1_0_LATER'     if gsl_version >= Gem::Version.new('1.0')
$defs << '-DGSL_1_1_LATER'     if gsl_version >= Gem::Version.new('1.1')
$defs << '-DGSL_1_1_1_LATER'   if gsl_version >= Gem::Version.new('1.1.1')
$defs << '-DGSL_1_2_LATER'     if gsl_version >= Gem::Version.new('1.2')
$defs << '-DGSL_1_3_LATER'     if gsl_version >= Gem::Version.new('1.3')
$defs << '-DGSL_1_4_LATER'     if gsl_version >= Gem::Version.new('1.4')
$defs << '-DGSL_1_4_9_LATER'   if gsl_version >= Gem::Version.new('1.4.9')
$defs << '-DGSL_1_6_LATER'     if gsl_version >= Gem::Version.new('1.5.9')
$defs << '-DGSL_1_7_LATER'     if gsl_version >= Gem::Version.new('1.6.9')
$defs << '-DGSL_1_8_LATER'     if gsl_version >= Gem::Version.new('1.7.9')
$defs << '-DGSL_1_9_LATER'     if gsl_version >= Gem::Version.new('1.8.9')
$defs << '-DGSL_1_10_LATER'    if gsl_version >= Gem::Version.new('1.9.9')
$defs << '-DGSL_1_11_LATER'    if gsl_version >= Gem::Version.new('1.11')
$defs << '-DGSL_1_13_LATER'    if gsl_version >= Gem::Version.new('1.12.9')
$defs << '-DGSL_1_14_LATER'    if gsl_version >= Gem::Version.new('1.14')

# Check functions
have_func("round")

# Check GSL extensions
  
extensions = {
  "rngextra/rngextra.h"              => "rngextra",
  "qrngextra/qrngextra.h"            => "qrngextra",
  "ool/ool_version.h"                => "ool",
  "tensor/tensor.h"                  => "tensor",
  "jacobi.h"                         => "jacobi",
  "gsl/gsl_cqp.h"                    => "cqp",
  "gsl/gsl_multimin_fsdf.h"          => "bundle_method",
  "ndlinear/gsl_multifit_ndlinear.h" => "ndlinear",
  "alf/alf.h"                        => "alf"
}

extensions.each {|header, lib| have_header(header) && have_library(lib)}

$defs << '-DHAVE_POLY_SOLVE_QUARTIC' if have_library("gsl", "gsl_poly_solve_quartic")
$defs << '-DHAVE_EIGEN_FRANCIS'      if have_library("gsl", "gsl_eigen_francis")

# Ruby version
RB_VERSION = Gem::Version.new(RUBY_VERSION.dup)

$defs << '-DRUBY_1_8_LATER'   if RB_VERSION >= Gem::Version.new('1.8')
$defs << '-DRUBY_1_9_LATER'   if RB_VERSION >= Gem::Version.new('1.9')
$defs << '-DRUBY_1_9_2_LATER' if RB_VERSION >= Gem::Version.new('1.9.2')

# GNU Graph
$defs << '-DHAVE_GNU_GRAPH'   if find_executable("graph")

# Find narray with rubygems
spec = Gem::Specification.find_by_name('narray')
if spec 
  $CFLAGS << " -I#{File.join(spec.full_gem_path, spec.require_path)}"
  have_header('narray.h')
end

# Build
$srcs = Dir[File.join('gsl', "*.{#{SRC_EXT.join(%q{,})}}")] - ["gsl/vector_source.c", "gsl/matrix_source.c", "gsl/tensor_source.c", "gsl/poly_source.c", "gsl/block_source.c"]

create_header
create_makefile 'gsl/rb_gsl', 'gsl'