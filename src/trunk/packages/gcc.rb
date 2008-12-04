
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# gcc.rb 
#
# Gcc package.
#
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright 2008, GPL.
#
# This file is part of AbTLinux.
#
# AbTLinux is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# AbTLinux is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#                                   
# You should have received a copy of the GNU General Public License along with
# AbTLinux; if not, write to the Free Software Foundation, Inc., 51 Franklin
# St, Fifth Floor, Boston, MA 02110-1301  USA
##

class Gcc < AbtPackage
  
protected
  
private
  
  $name         = "Gcc"
  $version      = "4.3.2"
  $srcDir       = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tar.bz2"
  $packageData  = {
    'name'              => $name,
    'execName'          => $name.downcase,
    'version'           => $version,
    'srcDir'            => $srcDir,
    'homepage'          => "http://gcc.gnu.org/",
    'srcUrl'            => "#{$GNU_URL}/#{$name.downcase}/#{$srcDir}/#{$name.downcase}-core-#{$version}.tar.bz2",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
#    'hashCheck'         => "dda63ba27ac8342d4fb5dcf904e4b0880936a1a9",   # gcc 4.2.4
    'hashCheck'         => "309674c707644e7cf187e848af01f3e45021abe0",    # gcc 4.3.2
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada, as well as libraries for these languages (libstdc++, libgcj,...)."
  }
  
public

  ##
  # Constructor for an AbtPackage, requires all the packge details.
  #
  # <b>PARAM</b> <i>Hash</i> - hash containing all pacakge data.
  #
  ##
  def initialize()
      super($packageData)
  end  
  
  ##
  # Overriding standard configure here for gcc.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def configure(verbose=true)
    cmd = "./configure --prefix=#{$BUILD_PREFIX} --sysconfdir=#{$BUILD_SYSCONFDIR} --localstatedir=#{$BUILD_LOCALSTATEDIR} --mandir=#{$BUILD_MANDIR} --infodir=#{$BUILD_INFODIR}"
    verbose_redirect = "| tee #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure"
    silent_redirect = "> #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure 2>&1"

    # if we chain commands with pipe for verbose is true, then want to get
    # the configure command exit status with the following.
    verbose_results = %x/exit \$\{PIPESTATUS\[0\]\}/

    # setup command.
	
    if verbose
      command = "#{cmd} #{verbose_redirect}; #{verbose_results}"
      puts "[DEBUG] Command is : #{command}"
    else
      command = "#{cmd} #{silent_redirect}"
      puts "[DEBUG] Command is : #{command}"
    end

    Dir.chdir("#{$BUILD_LOCATION}/#{@srcDir}")
    
    # set our optimizations before configuring.
    $cflags   = "CFLAGS=" + '"' + $BUILD_CFLAGS + '"'
    puts "Using the following optimizations:  export #{$cflags}\n"

    # now start to configure.
    if !system("export #{$cflags}; export CXXFLAGS='${CFLAGS}'")
      puts "[gcc.configure] - configure section failed trying to export #{$cflags}, exit code was #{$?.exitstatus}."
      return false
    end

    if !system(command)
      puts "[gcc.configure] - configure section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[gcc.configure] - configure section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
end 
