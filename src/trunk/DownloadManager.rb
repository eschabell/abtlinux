#!/usr/bin/ruby -w

##
# DownloadManager.rb 
#
# DownloadManager class handles all downloading of components needed for
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

class DownloadManager < Manager

  protected
  
  private
  
  public

	##
	# Constructor that sets the type of manager being created.
	#
	# <b>RETURN</b> <i>DownloadManager</i> - an initialized DownloadManager object. 
	##
	def initialize
		@managerType = "DownloadManager"
	end

	##
	# Downloads a given package source.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package for which the source
	# is to be downloaded.
	# <b>RETURN</b> <i>boolean</i> - True if the package source has been
	# downloaded, otherwise false.
	##
	def retreiveSource( packageName )
	end
  
	##
	# Downloads a given pacakge tree.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package tree to be retrieved.
	# <b>RETURN</b> <i>boolean</i> - True if the package tree is retrieved, otherwise
	# false.
	##
	def retrieveTree( packageTreeName )
	end
  
	##
	# Retrieves the AbTLinux news feed.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the AbTLinux news feed has been
	# retrieved, otherwise false.
	##
	def retrieveNews
	end
  
end
