
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# bash.rb 
#
# Bash package.
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

class Bash < AbtPackage
  
protected
  
private
  
  $name         = "Bash"
  $version      = "3.2"
  $srcDir       = "bash-3.2"
  $srcFile      = "bash-3.2.tar.gz"
  $packageData  = {
    'name'              => "bash",
    'execName'          => "bash",
    'version'           => "3.2",
    'srcDir'            => "bash-3.2",
    'homepage'          => "http://cnswww.cns.cwru.edu/~chet/bash/bashtop.html",
    'srcUrl'            => "#{$GNU_URL}/bash/bash-3.2.tar.gz",
    'dependsOn'         => "patch, gnupg, readline, autoconf",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "8ba17e8d218c39c20144b9c755f8a5f3b25fe3aa",
    'patches'           => "#{$GNU_URL}/bash/bash-3.2-patches",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL2",
    'description'       => "Bash - Shell of the GNU operating system."
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
  # Preliminary work will happen here such as downloading the tarball,
  # unpacking it, downloading and applying patches.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if completes sucessfully, 
  # otherwise false.
  ##
  def pre(verbose=true)
    downloader = AbtDownloadManager.new
    
    # download sources.
    if (!downloader.retrieve_package_source(@name.downcase, $SOURCES_REPOSITORY))
      return false
    end
    
    # validate sources sha1.
    if (!downloader.validated(@hashCheck, "#{$SOURCES_REPOSITORY}/#{File.basename(@srcUrl)}"))
      return false
    end
    
    # unpack sources.
    if (!unpack_sources)
      return false
    end
    
    # ensure we have an installed directory to use.
    if (! File.directory?("#{$PACKAGE_INSTALLED}/#{@srcDir}"))
      FileUtils.mkdir_p("#{$PACKAGE_INSTALLED}/#{@srcDir}")
    end
    
    return true
  end

  ##
  # Here we manage the ./configure step (or equivalent). We need 
  # to give ./configure (or autogen.sh, or whatever) the correct options 
  # so files are to be placed later in the right directories, so doc files 
  # and man pages are all in the same common location, etc.
  # Don't forget too that it's here where we interact with the user in 
  # case there are optionnal dependencies.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def configure(verbose=true)
    cmd = "./configure --prefix=#{$BUILD_PREFIX} --sysconfdir=#{$BUILD_SYSCONFDIR} --localstatedir=#{$BUILD_LOCALSTATEDIR} --mandir=#{$BUILD_MANDIR} --infodir=#{$BUILD_INFODIR} --enable-static-link --with-bash-malloc=no"
    verbose_redirect = "| tee #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure"
    silent_redirect = "> #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure 2>&1"

    # if we chain commands with pipe for verbose is true, then want to get
    # the configure command exit status with the following.
    verbose_results = %x/exit ${PIPESTATUS[0]}/

    # setup command.
	
    if verbose
      cmd = "#{cmd} #{verbose_redirect}; #{verbose_results}"
    else
      cmd = "#{cmd} #{silent_redirect}"
    end

    Dir.chdir("#{$BUILD_LOCATION}/#{@srcDir}")
    
    # set our optimizations before configuring.
    $cflags   = "CFLAGS=" + '"' + $BUILD_CFLAGS + '"'
    puts "Using the following optimizations:  export #{$cflags}\n"

    # now start to configure.
    if !system("export #{$cflags}; export CXXFLAGS='${CFLAGS}'")
      puts "[bash.configure] - configure section failed trying to export #{$cflags}, exit code was #{$?.exitstatus}."
      return false
    end

    if !system(cmd)
      puts "[bash.configure] - configure section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[bash.configure] - configure section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
end 
