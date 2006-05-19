#!/usr/bin/ruby -w

##
# Manager.rb 
#
# Manager is super class for all other AbTLinux manager classes to inherit
# from.
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

class Manager

	attr_reader :managerType
	
  protected
  
  private
  
  public

	##
	# Constructor that sets the type of manager being created.
	#
	# <b>PARAM</b> <i>String</i> - the name of the manager type being created.
	# <b>RETURN</b> <i>Manager</i> - an initialized Manager object. 
	##
	def initialize( type )
		@managerType = type
	end
  
end
