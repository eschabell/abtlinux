#!/usr/bin/ruby -w

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
require 'abtconfig'

##
# Setup needed classes and get ready to parse arguments.
##
manager    = AbtPackageManager.new
logger     = AbtLogManager.new     # initializes all needed paths.
reporter   = AbtReportManager.new
downloader = AbtDownloadManager.new
system     = AbtSystemManager.new
options    = Hash.new
show       = AbtUsage.new

# deal with usage request.
if ( ARGV.length == 0 )
  show.usage( "all" )
end

# login as root for the rest.
manager.root_login( ARGV )

# parse arguments.
case ARGV[0]
  
  # abt [ -i | install ] <package>
when "install", "-i"
  if ( ARGV.length == 2 && File.exist?( "#{$PACKAGE_PATH}#{ARGV[1]}.rb" ) )
    options['package'] = ARGV[1]
    logger.to_journal( "Starting to install #{options['package']}" )
    
    # return if already installed.
    if ( system.package_installed( options['package'] ) )
      puts "\n*** Package #{options['package']} is installed, might want to try reinstall? ***"
      puts "\n\tabt reinstall #{options['package']}\n\n"
      logger.to_journal( "Completed install of #{options['package']}." )
      exit
    end
    
    if ( manager.install_package( options['package'] ) )
      puts "\n\n"
      puts "*** Completed install of #{options['package']}. ***"
      puts "\n\n"
      logger.to_journal( "Completed install of #{options['package']}." )
      
      if ( logger.cache_package( options['package'] ) )
        puts "\n\n"
        puts "*** Completed caching of package #{options['package']}. ***"
        puts "\n\n"
        logger.to_journal( "Caching completed for package #{options['package']}." )
      else
        logger.to_journal( "Caching of package #{options['package']} failed.")
      end
    else
      puts "*** #{options['package'].capitalize} install failed, " +
          "see journal. ***"
    end
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
    puts "Starting to remove #{options['package']}."
    logger.to_journal( "Starting to remove #{options['package']}." )
    
    # return if not installed.
    if ( !( system.package_installed( options['package'] ) ) )
      puts "\n\n"
      puts "*** No need to remove #{options['package']}, it was not installed! ***"
      puts "\n\n"
      logger.to_journal( "Completed removal of #{options['package']}." )
      exit
    end

    # is installed, remove package.
    if ( manager.remove_package( options['package'] ) )
      puts "\n\n"
      puts "*** Completed removal of #{options['package']}. ***"
      puts "\n\n"
      logger.to_journal( "Completed removal of #{options['package']}." )
    end  
  else
    show.usage( "packages" )
    exit
  end
  
when "downgrade", "-dg"
  if ( ARGV.length == 3 )
    options['version'] = ARGV[1]
    options['package'] = ARGV[2]
    print "Downgradinging package : #{options['package']} "
    puts  "to version : #{options['version']}"
  else
    show.usage( "packages" )
    exit
  end
  
when "freeze", "-f"
  if ( ARGV.length == 2 )
    options['package'] = ARGV[1]
    puts "Holdinging package : #{options['package']} at current version."
  else
    show.usage( "packages" )
    exit
  end
  
when "search", "-s"
  if ( ARGV.length == 2 )
    options['searchString'] = ARGV[1]
    puts "Searching package descriptions for : #{options['searchString']}"
  else
    show.usage( "queries" )
    exit
  end
  
  # abt -v | --version
when "-v", "--version"
  if ( ARGV.length == 1 )
    puts "Abt Package Manager version is : #{$ABT_VERSION}"
  else
    show.usage( "queries" )
    exit
  end
  
  # abt show-details <package>
when "show-details"
  if ( ARGV.length == 2 && File.exist?( $PACKAGE_PATH + ARGV[1] + ".rb" ) )
    options['pkg'] = ARGV[1]
    logger.to_journal( "Starting show details for #{options['pkg']}" )
    
    if ( reporter.show_package_details( options['pkg'] ) )
      logger.to_journal( "Completed show details for #{options['pkg']}" )
    else
      puts "Problems processing the details for #{options['pkg']}."
    end
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
  
  # abt show-journal
when "show-journal"
  reporter.show_journal( $JOURNAL )
  
when "show-iqueue"
  reporter.show_queue( "install" )
  
when "show-patches"
  puts "Display currently available patches for installed package tree."
  show.usage( "queries" )
  
when "show-updates"
  puts "Display package listing with available update versions."
  show.usage( "generation" )
  
when "html"
  puts "Generate HTML page from installed packages:"
  puts "  (package name with link to package website/version installed)"
  show.usage( "generation" )
  
  # abt news | -n
when "news", "-n"
  logger.to_journal( "Starting to retrieve AbTLinux news." )
  
  # abtlinux.org news feeds.
  puts "\n"
  if ( !downloader.retrieve_news_feed( $ABTNEWS ) )
    puts "Failed to retrieve the AbTLinux news feed."
  end
  
  puts "\n"
  if ( !downloader.retrieve_news_feed( $ABTNEWS_THREADS, false ) )
    puts "Failed to retrieve the AbTLinux forum threads news feed."
  end
  
  puts "\n"
  if ( !downloader.retrieve_news_feed( $ABTNEWS_POSTS, false ) )
    puts "Failed to retrieve the AbTLinux new posts news feed."
  end
  
  # display the file contents.
  reporter.show_journal( $ABTNEWS_LOG )
  
  logger.to_journal( "Completed the retrieval of AbTLinux news." )
  
  # abt [-d | download ] <package>
when "download", "-d"
  if ( ARGV.length == 2 && File.exist?( $PACKAGE_PATH + ARGV[1] + ".rb" ) )
    options['pkg'] = ARGV[1]
    logger.to_journal( "Starting to download " + options['pkg'] )
    
    manager = AbtDownloadManager.new
    
    if ( manager.retrieve_package_source( options['pkg'], $SOURCES_REPOSITORY ) )
      logger.to_journal( "Finished download for " + options['pkg'] )
      puts  "\n";
      print "Downloading of #{options['pkg']} to #{$SOURCES_REPOSITORY} "
      puts  "completed."
      puts  "\n\n"
    else
      logger.to_journal( "FAILURE to download " + options['pkg'] )
      puts  "\n"
      puts "DOWNLOADING - failed to download source for #{options['pkg']}"
      puts "\n\n"
    end
  else
    show.usage( "downloads" )
    exit
  end
  
when "update", "-u"
  if ( ARGV.length == 2 )
    options['updateItem'] = ARGV[1]
    puts "Updating item : #{options['updateItem']}"
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
    options['pkg'] = ARGV[1]
    print "Verifiy integrity of installed files for "
    puts  "package : #{options['pkg']}"
  else
    show.usage( "fix" )
    exit
  end
  
when "fix"
  if ( ARGV.length == 2 )
    options['pkg'] = ARGV[1]
    puts "Package : #{options['pkg']} is verified and checked if needed."
  else
    show.usage( "fix" )
    exit
  end
  
when "build-location"
  if ( ARGV.length == 2 )
    options['buildHost'] = ARGV[1]
    print "Sets global location for retrieving cached build packages "
    puts  "to : #{options['buildHost']}"
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
  
else
  show.usage( "all" )
end # case ARGV[0].
