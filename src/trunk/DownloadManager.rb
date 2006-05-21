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

class DownloadManager

  protected
  
  private
  
  public

	##
	# Constructor for the DownloadManager class.
	#
	# <b>RETURN</b> <i>DownloadManager</i> - an initialized DownloadManager object. 
	##
	def initialize
	end

	##
	# Downloads a given package source.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package for which the source
	# is to be downloaded.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the package source has been
	# downloaded, otherwise false.
	##
	def retrievePackageSource( packageName )
	end
  
	##
	# Downloads a given pacakge tree.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package tree to be retrieved.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the package tree is retrieved, otherwise
	# false.
	##
	def retrievePackageTree( packageTreeName )
	end
  
	##
	# Retrieves the AbTLinux news feed.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the AbTLinux news feed has been
	# retrieved, otherwise false.
	##
	def retrieveNewsFeed
	end
  
	##
	# Updates a given package with available patches (version updates).
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be updated.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the given package has been updated,
	# otherwise false.
	##
	def updatePackage
	end
  
	##
	# Updates the package tree.
	#
	# <b>RETURN</b> <i>boolean</i> - True if the package tree has been updated,
	# otherwise false.
	##
	def updatePackageTree
	end
  
end
