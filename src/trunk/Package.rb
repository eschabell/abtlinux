#!/usr/bin/ruby -w

##
# Package.rb 
#
# Package class provides an interface to package creation within AbTLinux. By
# inheriting from this class (class Fortune < Package) one picks up all
# supported standard functions for the abt package manager to make use of the
# new package.
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

class Package
  
  protected
  
  private
  
  public

    attr_reader :NAME, :VERSION, :SRCFILE, :SRCDIR, :SRCURL, :INTEGRITY
    attr_reader :URL, :LICENSE, :DESCRIPTION
    
    ##
    # Provides all the data needed for this package.
    #
    # <b>RETURNS:</b>  <i>hash</i> - Contains all package attributes (constants).
    ##
    def details
    end
    
    ##
    # Preliminary work will happen here such as downloading the tarball, 
    # unpacking it, downloading and applying patches.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if completes sucessfully, otherwise false.
    ##
    def pre
    end
    
    ##
    # Here we manage the ./configure step (or equivalent). We need to give ./configure 
    # (or autogen.sh, or whatever) the correct options so files are to be placed later in the 
    # right directories, so doc files and man pages are all in the same common location, etc. 
    # Don't forget too that it's here where we interact with the user in case there are optionnal 
    # dependencies.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
    ##
    def configure
    end
    
    ##
    # Here is where the actual builing of the software starts, for example running 'make'.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
    ##
    def build
    end
    
    ##
    # Any actions needed before the installation can occur will happen here, such as creating
    # new user accounts, dealing with existing configuration files, etc.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
    ##
    def preinstall
    end
  
    ##
    # All files to be installed are installed here.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
    ##
    def install
    end
    
    ##
    # Last bits of installation. adding the service for automatic start in init.d for example.
    #
    # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
    ##
    def post
    end
  
end
