#!/usr/bin/ruby -w

##
# MainenanceManager.rb 
#
# MainenanceManager class handles all downloading of components needed for
# AbTLinux.
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

class MainenanceManager < Manager

  protected
  
  private
  
  public

	##
	# Constructor that sets the type of manager being created.
	#
	# <b>RETURN</b> <i>MainenanceManager</i> - an initialized MainenanceManager object. 
	##
	def initialize
		@managerType = "Mainenance Manager"
	end

	##
	# Sets the URI of a central repository for pre-compiled packages.
	#
	# <b>PARAM</b> <i>String</i> - the URI where the central repository is
	# located.
	# <b>RETURN</b> <i>boolean</i> - True if the URI is set, otherwise false.
	##
	def setCentralRepo( uri )
	end
  
	##
	# Sets the location where the package tree is to be downloaded from, can be
	# set to a local location.
	#
	# <b>PARAM</b> <i>String</i> - the location of the package tree.
	# <b>RETURN</b> <i>boolean</i> - True if the package tree location is set, otherwise
	# false.
	##
	def setPackageTreeLocation( location )
	end
  
end
