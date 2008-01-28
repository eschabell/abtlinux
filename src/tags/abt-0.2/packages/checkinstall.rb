#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# checkinstall.rb 
#
# Checkinstall package.
#
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright 2006, GPL.
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

class Checkinstall < AbtPackage
  
protected
  
private
  
  $name				  = "Checkinstall"
  $version			= "1.6.1"
  $srcDir			  = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tgz"
  $packageData	= {
    'name'				      => $name,
    'execName'		      => $name.downcase,
    'version'			      => $version,
    'srcDir'			      => $srcDir,
    'homepage'		      => "http://asic-linux.com.mx/~izto/checkinstall",
    'srcUrl'			      => "http://asic-linux.com.mx/~izto/checkinstall/files/source/#{$srcFile}",
    'dependsOn'			    => "gettext",
    'reliesOn'			    => "",
    'optionalDO'		    => "",
    'optionalRO'		    => "",
    'hashCheck'			    => "3b52f4ccb999522776e9874472c2eef91563e822",
    'patches'			      => "",
    'patchesHashCheck'	=> "",
    'mirrorPath'		    => "",
    'license'			      => "GPL2",
    'description'		    => 
		"Installs a compiled program from the program's source directory 
		  using 'make install' or any other command supplied on 
			checkinstall's command line. Includes installwatch program."
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
  # Override configure by returning true, none needed.
	#
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
	#
  # <b>RETURNS:</b>  <i>boolean</i> - True always.
  ##
  def configure(verbose=true)
    return true
  end
  
  ##
  # All files to be installed are installed here, note without installwatch,
	# as we are installing it!
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def install(verbose=true)
    if (verbose)
      command = "make install"
    else
      command = "make install >/dev/null"
    end 
  
    Dir.chdir("#{$BUILD_LOCATION}/#{@srcDir}")
    
    if !system(command)
      puts "[AbtPackage.install] - pre-install section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    if (verbose)
      command = "installwatch --transl=no --backup=no " +
          "--exclude=/dev,/proc,/tmp,/var/tmp,/usr/src,/sys " +
          "--logfile=#{$ABT_TMP}/#{@srcDir}.watch make install"
    else
      command = "installwatch --transl=no --backup=no " +
          "--exclude=/dev,/proc,/tmp,/var/tmp,/usr/src,/sys " +
          "--logfile=#{$ABT_TMP}/#{@srcDir}.watch make install >/dev/null"
    end 
  
    Dir.chdir("#{$BUILD_LOCATION}/#{@srcDir}")
    
    if !system(command)
      puts "[AbtPackage.install] - install section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[AbtPackage.install] - install section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
end
