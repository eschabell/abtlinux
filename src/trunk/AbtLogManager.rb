#!/usr/bin/ruby -w

##
# AbtLogManager.rb 
#
# AbtLogManager class handles all aspects of logging and access to existing logs
# within the AbTLinux system.
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
class AbtLogManager

protected
 
  ##
  # Provides logging of the integrity of all installed files for the given
  # package. Will be called as part of the logging done during the install
  # phase.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  # 
  # <b>RETURN</b> <i>boolean</i> - True if integrity log created successfully,
  # otherwise false.
  ##
  def logPackageIntegrity( package )
  end
 
	
private

public

  ##
  # Constructor for the AbtLogManager. It ensures all needed logs paths are 
  # initialized.
  #  
  #
  # <b>RETURN</b> <i>AbtLogManager</i> - an initialized AbtLogManager object. 
  ##
  def initialize
	  if ( !File.directory?( $ABT_LOGS ) )
		  FileUtils.mkdir_p( $ABT_LOGS )  
		  self.logToJournal( "Created directory: #{$ABT_LOGS}." )
	  end

	  if ( !File.directory?( $ABT_CACHES ) )
		  FileUtils.mkdir_p( $ABT_CACHES )
		  self.logToJournal( "Created directory: #{$ABT_CACHES}." )
	  end

	  if ( !File.directory?( $BUILD_LOCATION ) )
		  FileUtils.mkdir_p( $BUILD_LOCATION )
		  self.logToJournal( "Created directory: #{$BUILD_LOCATION}." )
	  end
	  if ( !File.directory?( $PACKAGE_INSTALLED ) )
		  FileUtils.mkdir_p( $PACKAGE_INSTALLED )
		  self.logToJournal( "Created directory: #{$PACKAGE_INSTALLED}." )
	  end
	  if ( !File.directory?( $SOURCES_REPOSITORY ) )
		  FileUtils.mkdir_p( $SOURCES_REPOSITORY )
		  self.logToJournal( "Created directory: #{$SOURCES_REPOSITORY}." )
	  end
  end

  ##
  # Provides logging of all files installed by given package. Should be called
  # as part of the install phase of the build.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  # 
  # <b>RETURN</b> <i>boolean</i> - True if install log created successfully,
  # otherwise false.
  ##
  def logPackageInstall( package )
  end

  ##
  # Provides logging of all output produced during the build phase of the
  # given package. Should be called as part of the install phase of the build.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  # 
  # <b>RETURN</b> <i>boolean</i> - True if build log created successfully,
  # otherwise false.
  ##
  def logPackageBuild( package )
  end

  ##
  # Provides a complete log of the given packages build. Includes everything
  # needed to duplicate the build at a later date.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  # 
  # <b>RETURN</b> <i>boolean</i> - True if package cache created successfully,
  # otherwise false.
  ##
  def cachePackage( package )
  end

  ##
  # Provides logging of given message to the AbTLinux journal. Message logged
  # with date timestamp.
  # 
  # <b>PARAM</b> <i>String</i> - Message to be added to the log.
  # 
  # <b>RETURN</b> <i>boolean</i> True if logged, otherwise false.
  ##
  def logToJournal( message )
	  if ( log = File.new( $JOURNAL, File::WRONLY|File::APPEND|File::CREAT, 0644 ) )
			log.puts "#{$TIMESTAMP} : #{message}" 
			log.close
			return true
		end

		return false
  end
end
