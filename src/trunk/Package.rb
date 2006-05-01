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

	def details
	end
	
	def pre
	end
  
  def configure
  end
  
  def build
  end
  
  def preinstall
  end
  
  def install
  end

  def post
  end
  
end
