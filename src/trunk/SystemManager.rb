#!/usr/bin/ruby -w

##
# SystemManager.rb 
#
# SystemManager class handles all aspects of the AbTLinux system. It takes
# care of such tasks as cleanup, fixing, verification and management of
# settings within the system.
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

class SystemManager

  protected
  
  private
  
  public

	##
	# Constructor for the System manager
	#
	# <b>RETURN</b> <i>SystemManager</i> - an initialized SystemManager object. 
	##
	def initialize
	end

	##
	# Removes all sources for packages that are not currently installed. Makes
	# use of install listing to determine package sources to keep.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
	# false.
	##
	def cleanupPackageSources
	end

	##
	# All logs for packages not in install list are cleaned off the system.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
	# false.
	##
	def cleanupLogs
	end

	##
	# Checks if files from given package install list are actually installed.
	# 
	# <b>PARAM</b> <i>String</i> - Package name.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if no installed files are missing, otherwise
	# false.
	##
	def verifyInstalledFiles( package )
	end

	##
	# Checks if given packages installed symlinks are broken or missing.
	# 
	# <b>PARAM</b> <i>String</i> - Package name.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if no symlinks found missing or broken, otherwise
	# false.
	##
	def verifySymlinks( package )
	end

	##
	# Checks the given packages dependencies for missing or broken dependencies.
	# 
	# <b>PARAM</b> <i>String</i> - Package name.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if dependencies intact, otherwise
	# false.
	##
	def verifyPackageDepends( package )
	end

	##
	# Checks the given packages installed files against the integrity log for
	# changes to installed files.
	# 
	# <b>PARAM</b> <i>String</i> - Package name.
	# 
	# <b>RETURN</b> <i>hash</i> - Empty hash if no problems found, otherwise
	# hash of problem files and their encountered errors.
	##
	def verifyPackageIntegrity( package ) 
	end

	##
	# Fixes the given package.
	# 
	# <b>PARAM</b> <i>String</i> - Package name.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
	# false.
	##
	def fixPackage( package )
	end
	
	##
	# Sets the URI of a central repository for pre-compiled packages.
	#
	# <b>PARAM</b> <i>String</i> - the URI where the central repository is
	# located.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if the URI is set, otherwise false.
	##
	def setCentralRepo( uri )
	end
  
	##
	# Sets the location where the package tree is to be downloaded from, can be
	# set to a local location.
	#
	# <b>PARAM</b> <i>String</i> - the location of the package tree.
	# 
	# <b>RETURN</b> <i>boolean</i> - True if the package tree location is set, otherwise
	# false.
	##
	def setPackageTreeLocation( location )
	end
  
end
