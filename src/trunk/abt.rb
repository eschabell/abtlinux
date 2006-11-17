#!/usr/bin/ruby -wI./packages

##
# abt.rb 
#
# The central package manager script to run all ABout Time Linux tasks. 
# 
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright July 2006, GPL.
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
require 'abtConfig'
require 'AbtPackageManager'
require 'AbtLogManager'
require 'AbtReportManager'
require 'AbtDownloadManager'
require 'AbtUsage'
require 'fileutils'
require 'net/http'
require 'uri'
require 'rss/1.0'
require 'rss/2.0'
require 'optparse'



##
# Setup needed classes and get ready 
# to parse arguments.
##
manager     = AbtPackageManager.new
logger      = AbtLogManager.new
options     = Hash.new()
show        = AbtUsage.new()

# deal with usage request.
if ( ARGV.length == 0 )
	show.usage( "all" )
end

# login as root for the rest.
manager.rootLogin( ARGV )

# parse arguments.
case ARGV[0]

	when "install", "-i"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Installing package : " + options['package']
		else
			show.usage( "packages" )
			exit
		end
	
	when "reinstall", "-ri"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Reinstalling package : " + options['package']
		else
			show.usage( "packages" )
			exit
		end
	
	when "remove", "-r"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Removing package : " + options['package']
		else
			show.usage( "packages" )
			exit
		end
	
	when "downgrade", "-dg"
		if ( ARGV.length == 3 )
		    options['version'] = ARGV[1]
			options['package'] = ARGV[2]
			puts "Downgradinging package : " + options['package'] + " to version : " + options['version']
		else
			show.usage( "packages" )
			exit
		end
	
	when "freeze", "-f"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Holdinging package : " + options['package'] + " at the current version."
		else
			show.usage( "packages" )
			exit
		end
		
	when "search", "-s"  
		if ( ARGV.length == 2 )
			options['searchString'] = ARGV[1]
			puts "Searching package descriptions for : " + options['searchString']
		else
			show.usage( "queries" )
			exit
		end
	
	when "show-details"  
		if ( ARGV.length == 2 && File.exist?( $PACKAGE_PATH + ARGV[1] + ".rb" ) )
			options['package'] = ARGV[1]
			logger.logToJournal( "Starting to show details for " + options['package'] )
			
			require options['package']                                # pickup called package class.
			package = eval( options['package'].capitalize + '.new' )  # evaluates package.new methode dynamically.
			details = package.details

			puts "|====================================="
			puts "| Package name\t:#{details['Package name']}"
			details.delete( "Package name" )
			puts "| Version\t: #{details['Version']}"
			details.delete( "Version" )
			puts "| Homepage\t: #{details['Homepage']}"
			details.delete( "Homepage" )
			puts "| Executable\t: #{details['Executable']}"
			details.delete( "Executable" )
			puts "| Source uri\t: #{details['Source uri']}"
			details.delete( "Source uri" )
			puts "| Description\t: #{details['Description']}"
			details.delete( "Description" )
			puts "|====================================="
			puts "|====================================="

			details.each do |name, value| 
				print "| #{name}\t"
				if ( name.length < 14 )
					print "\t"
				end
				puts ": #{value}"
			end

			puts "|====================================="
			logger.logToJournal( "Completed show details for " + options['package'] )
		else
			show.usage( "queries" )
		end
	
	when "show-build"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display build log for package : " + options['package']
		else
			show.usage( "queries" )
			exit
		end


	when "show-depends"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display dependency tree for package : " + options['package']
		else
			show.usage( "queries" )
			exit
		end
	
	when "show-files"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display installed files from package : " + options['package']
		else
			show.usage( "queries" )
			exit
		end

	when "show-owner"  
		if ( ARGV.length == 2 )
			options['fileName'] = ARGV[1]
			puts "Display owning package for file : " + options['fileName']
		else
			show.usage( "queries" )
			exit
		end
	
	when "show-installed"  
		puts "Display all installed packages."
		show.usage( "queries" )
	
	when "show-frozen"  
		puts "Display all packages frozen at current version."
		show.usage( "queries" )
	
	when "show-untracked"  
		puts "Display all files on system not tracked by AbTLinux."
		show.usage( "queries" )

	when "show-journal"  
		if ( File.exist?( $JOURNAL ) )
			puts "\n\nAbTLinux journal:"
			puts "================="
			log = IO.readlines( $JOURNAL )
			log.each{ |line| puts line }
			puts "\n\n"
		else
			puts "AbTLinux journal is empty at this time."
		end
	
	when "show-iqueue"  
		puts "Display contents of install queue."
		show.usage( "queries" )
	
	when "show-patches"  
		puts "Display currently available patches for installed package tree."
		show.usage( "queries" )
	
	when "show-updates"  
		puts "Display package listing with available update versions."
		show.usage( "generation" )
	
	when "html"
	  puts "Generate HTML page from installed packages:"
	  puts "  (package name with hyperlink to package website and version installed)"
		show.usage( "generation" )
	
	# abt news | -n
	when "news", "-n"
		logger.logToJournal( "Starting to retrieve AbTLinux news." )

		# pick up the abtlinux.org news feed.
		news = Net::HTTP.get( URI.parse( $ABTNEWS ) )

		# display the feed neatly.
		rss = nil
		begin
			rss = RSS::Parser.parse(news, false)
			rescue RSS::Error
		end 

		if ( rss.nil? )
			puts $ABTNEWS + " is not RSS 1.0/2.0."
		else
			puts "\n\n"
			puts "======================="
			puts "= News from AbTLinux: ="
			puts "======================="
			puts "\n"
			
			itemCount = 0  # only printing three items.
			rss.items.each do |item|
				itemCount += 1
				if ( itemCount <= $MAX_NEWS_ITEMS )
					# format some of the item data.
					author      = item.author.split( '<' )
					description = item.description.sub( '[/html]', '' )
				
					puts "************************************"
					puts "Date   : #{item.date}"
					puts "Author : #{author[0]}"
					puts "Link   : #{item.link}"
					puts "Title  : #{item.title}"
					puts "\n#{description}"
					puts "************************************\n\n"
				end
			end
		end
		logger.logToJournal( "Completed the retrieval of AbTLinux news." )
            
	# abt [-d | download ] <package>
	when "download", "-d"  
		if ( ARGV.length == 2 && File.exist?( $PACKAGE_PATH + ARGV[1] + ".rb" ) )
			options['package'] = ARGV[1]
			logger.logToJournal( "Starting to download " + options['package'] )

			if ( !File.directory?( $SOURCES_REPOSITORY ) )
				FileUtils.mkdir_p( $SOURCES_REPOSITORY ) # initialize directory.
				logger.logToJournal( "Had to initialize directory - " + $SOURCES_REPOSITORY )
			end

			manager = AbtDownloadManager.new

			if ( manager.retrievePackageSource( options['package'], $SOURCES_REPOSITORY ) )
				logger.logToJournal( "Finished download for " + options['package'] )
				puts "\nDownloading of " + options['package'] + " to " + $SOURCES_REPOSITORY + " completed.\n\n"
			else
				logger.logToJournal( "FAILURE to download " + options['package'] )
				puts "\nDOWNLOADING - failed to download source for " + options['package'] + "\n\n"
			end

		else
			show.usage( "downloads" )
			exit
		end
		
	when "update", "-u"  
		if ( ARGV.length == 2 )
			options['updateItem'] = ARGV[1]
			puts "Updating this item (either package or a package tree : " + options['updateItem']
		else
			show.usage( "downloads" )
			exit
		end

	when "purge-src"
	  puts "Remove source caches for packages no longer installed."
		show.usage( "fix" )
	
	when "purge-logs"
	  puts "Remove log files for packages no longer installed."
		show.usage( "fix" )
	
	when "verify-files"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Installed files verified for package : " + options['package']
		else
			show.usage( "fix" )
			exit
		end
	
	when "verify-symlinks"  
		if ( ARGV.length == 2 )
		options['package'] = ARGV[1]
		puts "Symlinks verified for package : " + options['package']
	else
		show.usage( "fix" )
		exit
	end

	when "verify-deps"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Symlinks verified for package : " + options['package']
		else
			show.usage( "fix" )
			exit
		end
	    
	when "verify-integrity"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Verifiy the integrity of installed files for package : " + options['package']
		else
			show.usage( "fix" )
			exit
		end

	when "fix"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Package : " + options['package'] + " is verified and checked if needed."
		else
			show.usage( "fix" )
			exit
		end
	
	when "build-location"  
		if ( ARGV.length == 2 )
			options['buildHost'] = ARGV[1]
			puts "Sets global location for retrieving cached build packages to : " + options['buildHost']
		else
			show.usage( "maintenance" )
			exit
		end

	when "package-repo"
	  # sort out that we have enough args.
	  case ARGV.length
	
			# add or remove called.
	    when 3
	    	options['repoAction'] = ARGV[1]
				options['repoUri'] = ARGV[2]
	    
	    # list called.
	    when 2
	      if ( ARGV[1] == "list" )
					options['repoAction'] = ARGV[1]
	      else
					show.usage( "maintenance" )
	        exit
	      end
	
	    else
				show.usage( "maintenance" )
	      exit		    
		end # case ARGV.length.
		
		# hook location based on action.
		case options['repoAction']
	
			when "add"
		    puts "Adding package repository : " + options['repoUri']
			
			when "remove"
		    puts "Remove package repository : " + options['repoUri']
		
			when "list"
	    	puts "Display listing of package repositories."
	    
			else
				show.usage( "maintenance" )
	    	exit  
		end # case repoAction.
end # case ARGV[0].
