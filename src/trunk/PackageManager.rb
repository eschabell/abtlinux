#!/usr/bin/ruby -w

##
# PackageManager.rb 
#
# PackageManager class will take care of the installation, removal, updating,
# downgrading and freezing of AbTLinux software packages.
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

class PackageManager < Manager

  protected
  
  private
  
  public

	##
	# Constructor that sets the type of manager being created.
	#
	# <b>RETURN</b> <i>PackageManager</i> - an initialized PackageManager object. 
	##
	def initialize
		@managerType = "Package Manager"
	end

	##
	# Installs a given package.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be installed.
	# <b>RETURN</b> <i>boolean</i> - True if the package is installed, otherwise
	# false.
	##
	def install( packageName )
	end
  
	##
	# Reinstalls a given package.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be reinstalled.
	# <b>RETURN</b> <i>boolean</i> - True if the package is reinstalled, otherwise
	# false.
	##
	def reinstall( packageName )
	end
  
	##
	# Removes a given package.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be removed.
	# <b>RETURN</b> <i>boolean</i> - True if the package is removed, otherwise
	# false.
	##
	def remove( packageName )
	end
  
	##
	# Downgrades a given package.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be downgraded.
	# <b>PARAM</b> <i>String</i> - the version number to be downgraded to.
	# <b>RETURN</b> <i>boolean</i> - True if the package is downgraded, otherwise
	# false.
	##
	def downgrade( packageName, verison )
	end
  
	##
	# Freezes a given package. If successful will add give package to the frozen
	# list.
	#
	# <b>PARAM</b> <i>String</i> - the name of the package to be frozen.
	# <b>RETURN</b> <i>boolean</i> - True if the package is frozen, otherwise
	# false.
	##
	def remove( packageName )
	end
  
end
