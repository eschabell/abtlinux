#!/usr/bin/ruby -w

##
# abtdownloadmanager.rb 
#
# AbtDownloadManager class handles all downloading of components needed for
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
class AbtDownloadManager
  
  protected
  
  private
  
  public
  
  ##
  # Constructor for the AbtDownloadManager class.
  #
  # <b>RETURN</b> <i>AbtDownloadManager</i> - an initialized 
  # AbtDownloadManager object. 
  ##
  def initialize
  end
  
  ##
  # Downloads a given package source. If the file already exists, returns
  # true as if download completed.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package for which the source
  # is to be downloaded.
  # <b>PARAM</b> <i>String</i> - the path to the download destination.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package source has been
  # downloaded, otherwise false.
  ##
  def retrieve_package_source( packageName, destination )
    require "#{$PACKAGE_PATH}#{packageName}"
    logger		= Logger.new($JOURNAL)
    package		= eval( packageName.capitalize + '.new' )
    
    if ( File.exist?( "#{destination}/#{File.basename( package.srcUrl )}" ) )
      logger.info( "Download not needed, existing source found for #{packageName}" )
      return true
    end
    
    Dir.chdir( destination )
    if ( system( "wget #{package.srcUrl}" ) )
      logger.info( "Download completed for #{packageName}" )
      return true
    end
    
    return false  # download failed.
  end
  
  ##
  # Downloads a given pacakge tree.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package tree to be retrieved.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package tree is retrieved, 
  # otherwise false.
  ##
  def retrieve_package_tree( packageTreeName )
  end
  
  ##
  # Retrieves the given feed and displays the news items.
  #
  # <b>PARAM</b> <i>String</i> - the uri of the rss news feed to be retrieved.
  # <b>PARAM</b> <i>boolean</i> - default is to emplty the log file,
  # passing 'false' will append to news file.
  # <b>RETURN</b> <i>boolean</i> - True if the AbTLinux news feed has been
  # retrieved, otherwise false.
  ##
  def retrieve_news_feed( uri, cleanLog=true )
    require 'net/http'
    require 'uri'
    require 'rss/1.0'
    require 'rss/2.0'
    newsLog = ""
    logger	= Logger.new( $JOURNAL)
    
    # ensure we have our news logfile.
    if ( cleanLog )
      newsLog = File.new( $ABTNEWS_LOG, "w+" )
    else
      newsLog = File.new( $ABTNEWS_LOG, "a+" )
    end
    
    # pick up the abtlinux.org news feed.
    if ( !news = Net::HTTP.get( URI.parse( uri ) ) )
      logger.info( "Failed to retrieve news feed #{uri}." )
      return false
    end
    
    # display the feeds.
    rss = nil
    begin
      rss  = RSS::Parser.parse(news, false)
    rescue RSS::Error
    end 
    
    if ( rss.nil? )
      logger.info( "Failed to display news feed as feed #{uri} is not RSS 1.0/2.0." )
      return false
    else
      newsLog << "*** #{rss.channel.title} ***\n"
      
      rss.items.each_with_index do |item, itemCount|
        itemCount += 1
        newsLog << "#{itemCount}  #{item.link}  #{item.title}\n" 
      end
    end
    
    newsLog << "\n\n"
    newsLog.close
    return true
    
  end
  
  ##
  # Updates a given package with available patches (version updates).
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be updated.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the given package has been updated,
  # otherwise false.
  ##
  def update_package
  end
  
  ##
  # Updates the package tree.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package tree has been updated,
  # otherwise false.
  ##
  def update_package_tree
  end
  
  ##
  # Validates the sources based on package hash value.
  #
  # <b>PARAM</b> <i>String</i> - security hash value from the packages description.
  # <b>PARAM</b> <i>String</i> - source tarball location to be checked.
  #
  # <b>RETURNS:</b> <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def validated( hashvalue, path )
    logger = Logger.new( $JOURNAL )
    
    if hashvalue == Digest::SHA1.hexdigest( path )
      puts "Source hash validated successfully..."
      logger.info( "Validated sources successfully..." )
      return true
    end

    puts "Source hash failed validation..."
    logger.info( "Validating sources failed..." )
    return false
  end
end
