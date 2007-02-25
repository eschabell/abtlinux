#!/usr/bin/ruby -w

##
# AbtQueueManager.rb
#
# AbtQueueManager class handles all AbTLinux queue interaction.
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
class AbtQueueManager

protected

private

public

  ##
  # Constructor for the AbtQueueManager class.
  #
  # <b>RETURN</b> <i>AbtQueueManager</i> - an initialized AbtQueueManager object.
  ##
  def initialize
  end

  ##
  # Add a given package to the given queue. If package already in
  # the queue then it will not be added twice and return a positive
  # answer.
  #
  # <b>PARAM</b> <i>String</i> - the package to be added to the queue.
  # <b>PARAM</b> <i>String</i> - the queue to add the package to.
  #
  # <b>RETURN</b> <i>boolean</i> - true if package added/exists to/in install
  # queue, otherwise false.
  ##
  def addPackageToQueue( package, queue )
    logger = AbtLogManager.new
    
    # want to name install queue differently from log files.
	if ( queue == 'install' ) 
		queueFile = "#{$ABT_LOGS}/#{queue}.queue"
	else
    	queueFile = "#{$ABT_LOGS}/#{queue}.log"
	end

    if ( log = File.new( queueFile, File::WRONLY|File::APPEND|File::CREAT, 0644 ) )
      # pickup queue contents to ensure no duplicates.
      checkingQueue = IO.readlines( queueFile )

      # check if package exists, otherwise add.
      if ( ! checkingQueue.collect{ |i| i.split( '|' )[0] }.include?( package ) )
        log.puts "#{package}|#{$TIMESTAMP}"
        logger.logToJournal( "Added #{package} to #{queue} queue." )
      else
        logger.logToJournal( "Did not add #{package} to #{queue}, already exists." )
      end

      log.close
      return true
    end

    logger.logToJournal( "Failed to open #{queueFile}." )
    return false
  end
end
