#!/usr/bin/ruby -w

##
# ReportManager.rb 
#
# ReportManager class handles all sort of report and query generation within
# the AbTLinux system.
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

class ReportManager

  protected
  
  private
  
  public

	##
	# Constructor for the Reportmanager.
	#
	# <b>RETURN</b> <i>ReportManager</i> - an initialized Report1Manager object. 
	##
	def initialize
	end

	##
	# Display all data for a given package.
	#
	# <b>PARAM</b> <i>String</i> - Package name.
	#
	# <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
	# false.
	##
	def showPackageDetails( package )
	end

	##
	# Display all packages installed and tracked by AbTLinux.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showInstalledPackages
	end

	##
	# Display the contents of the requested log for a given package. Possible
	# log types are; install, build and integrity.
	#
	# <b>PARAM</b> <i>String</i> - Package name.
	#
	# <b>PARAM</b> <i>String</i> - log type.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showPackageLog( package, logType )
		# install log
		# build log
		# integrity log
	end

	##
	# Display a list of the packages found in the frozen list.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showFrozenPackages
	end

	##
	# Provides access to dependency checking via the AbTLinux DepEngine. (This
	# portal to the DepEngine will be expanded in apart sub-project, more
	# details at a later date.)
	#
	# <b>PARAM</b> <i>String</i> - Package name.
	#
	# <b>RETURN</b> <i>hash</i> - Empty hash if no problems found, otherwise
	# hash of problem files and their encountered errors.
	##
	def showPackageDependencies( package ) 
	end

	##
	# Display all files not part of any installed AbTLinux package. This
	# delivers a list of files that are not tracked by AbTLinux package
	# management.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showUntrackedFiles
	end
	
	##
	# Display the AbTLinux journal file.
	#
	# <b>RETURN</b> <i>void.</i> 
	##
	def showJournal
	end
  
	##
	# Display the name of the package(s) that own the given file.
	#
	# <b>PARAM</b> <i>String</i> - a file name.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showFileOwner( file )
	end
  
	##
	# Searches the installed package trees package descriptions for matching
	# occurrances of the given search text.
	# 
	# <b>PARAM</b> <i>String</i> - a search text.
	#
	# <b>RETURN</b> <i>hash</i> - a hash of the search results, keys are package
	# names and values are matching descriptions.
	##
	def searchPackageDescriptions( searchText )
	end

	##
	# Displays the contents of the current queue based on the given queue.
	# 
	# <b>PARAM</b> <i>String</i> - the type of queue to display such as install
	# queue.
	#
	# <b>RETURN</b> <i>void.</i>
	##
	def showQueue( queueType )
	end

	##
	# Reports available updates for a given package or package tree based on the
	# current system.
	# 
	# <b>PARAM</b> <i>String</i> - the target of the update check, either a
	# package name or a package tree name.
	#
	# <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
	# false.
	##
	def showUpdates( target )
	end
	
	##
	# Generates an HTML page of installed packages from installed packages list.
	# 
	# <b>RETURN</b> <i>void.</i>
	##
	def generateHTMLPackageListing
	end

end
