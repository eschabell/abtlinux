#!/usr/bin/ruby -w

##
# abtqueuemanager.rb
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
  # <b>RETURN</b> <i>AbtQueueManager</i> - an initialized 
  # AbtQueueManager object.
  ##
  def initialize
  end
  
  ##
  # Add/Remove a given package to the given queue. 
  # If adding a package already in the queue then it will not
  # be added twice and return succes.
  #
  # <b>PARAM</b> <i>String</i> - the package to be added/removed.
  # <b>PARAM</b> <i>String</i> - the queue.
  #
  # <b>RETURN</b> <i>boolean</i> - true if action succeeds, otherwise false.
  ##
  def action_package_queue(package, queue, action="add")
    require 'fileutils'
    logger = Logger.new($JOURNAL)
    queue_file = ""  # used to hold the queue location.
    
    # want to name install queue differently from log files.
    if (queue == 'install')
      queue_file = File.join($ABT_LOGS, "#{queue}.queue")
    else
      queue_file = File.join($ABT_LOGS, "#{queue}.log")
    end
    
    if (action == "add")
      if (log = File.new(queue_file, File::WRONLY|File::APPEND|File::CREAT, 0644))
        # pickup queue contents to ensure no duplicates.
        checking_queue = IO.readlines(queue_file)
        
        # check if package exists, otherwise add.
        if (!checking_queue.collect{ |i| i.split('|')[0] }.include?(package))
          log.puts "#{package}|#{$TIMESTAMP}"
          logger.info("Added #{package} to #{queue} queue.")
        else
          logger.info("Did not add #{package} to #{queue}, already exists.")
        end
        
        log.close
        return true
      end
    end
    
    if (action == "remove")
      # remove entry from given queue.
      if (
          log = File.new(queue_file, File::WRONLY|File::APPEND|File::CREAT, 0644))
        # use temp file to filter out entry to be removed.
        temp = File.new(queue_file + ".tmp", "a+")
        
        # now check for line to be removed.
        IO.foreach(queue_file) do |line|
          entry_name = line.split('|')[0]
          if (entry_name != package.downcase)
            temp.puts line
          end
        end
        
        temp.close
        FileUtils.mv(temp.path, queue_file)
      end
      
      log.close
      return true
    end
    
    logger.info("Failed to open #{queue_file}.")
    return false
  end  
end
