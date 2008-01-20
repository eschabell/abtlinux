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

# Check and install our library files.
#
$ABTLINUX_CLASS_LIBS = "https://abtlinux.svn.sourceforge.net/svnroot/abtlinux/src/trunk/libs"

if (! File.directory?('/var/lib/abt') || Dir["/var/lib/abt"].empty?)
  puts "\nMissing needed AbTLinux library files at /var/lib/abt"
  puts "\nMaybe time for an abt update? Let us try to fix it for you!\n"

  # check for root login.
  if (Process.uid != 0)
    puts "\nMust be root to fix library files."
    exit
  else
    system("svn co #{$ABTLINUX_CLASS_LIBS} /var/lib/abt/")
  end

  $LOAD_PATH.unshift '/var/lib/abt/'
end

# Load our central configuration file.
#
$ABTLINUX_MAIN_CONFIG = "https://abtlinux.svn.sourceforge.net/svnroot/abtlinux/src/trunk/abtconfig.rb"

if File.exist?("/etc/abt/abtconfig.rb")
	$LOAD_PATH.unshift '/etc/abt/'
  load 'abtconfig.rb'
else
  # missing configuration file, do some abt update?
  puts "\nMissing our main configuration file at /etc/abt/abtconfig.rb"
  puts "\nMaybe time for an abt update? Let us try to fix it for you!\n"
  
	# check for root login.	
  if (Process.uid != 0)
      puts "\nMust be root to fix configuration files."
			exit
	else
  	["/etc/abt", "/etc/abt/local"].each { |dir|
    	if (! File.directory?(dir))
      	FileUtils.mkdir_p(dir)
      	puts "Created directory: #{dir}."
    	end
  	}
  	system("svn export #{$ABTLINUX_MAIN_CONFIG} /etc/abt/abtconfig.rb")
	end

	$LOAD_PATH.unshift '/etc/abt/'
	load 'abtconfig.rb'

	if File.exist?("/etc/abt/local/localconfig.rb")
		$LOAD_PATH.unshift '/etc/abt/local/'
		load 'localconfig.rb'
	end
end


##
# Setup needed classes and get ready to parse arguments.
##
manager    = AbtPackageManager.new
reporter   = AbtReportManager.new
downloader = AbtDownloadManager.new
system     = AbtSystemManager.new
options    = Hash.new
show       = AbtUsage.new

# deal with usage request.
if (ARGV.length == 0 || (ARGV.length == 1 && (ARGV[0] == '--help' || ARGV[0] == '-h'  || ARGV[0].downcase == 'help')))
  show.usage("all")
  exit
end

# login as root for the rest.
manager.root_login(ARGV)

# setup timestamp.
logger     = Logger.new($JOURNAL)     # initializes all needed paths.
logger.datetime_format = "%Y-%m-%d %H:%M:%S "

# TODO: used only until refactoring done.
myLogger   = AbtLogManager.new

# And loading local file if found.
if File.exist?("/etc/abt/local/localconfig.rb")
  load '/etc/abt/local/localconfig.rb'
end


# parse arguments.
case ARGV[0]
  
  # abt [ -i | install ] <package>
when "install", "-i"
  if (ARGV.length == 2 && File.exist?("#{$PACKAGE_PATH}#{ARGV[1]}.rb"))
    options['package'] = ARGV[1]
    logger.info("Starting to install #{options['package']}")
    
    # return if already installed.
    if (system.package_installed(options['package']))
      puts "\n*** Package #{options['package']} is installed, might want to try reinstall? ***"
      puts "\n\tabt reinstall #{options['package']}\n\n"
      logger.info("Completed install of #{options['package']}.")
      exit
    end
    
    if (manager.install_package(options['package']))
      puts "\n\n"
      puts "*** Completed install of #{options['package']}. ***"
      puts "\n\n"
      logger.info("Completed install of #{options['package']}.")
      
      if (myLogger.cache_package(options['package']))
        puts "\n\n"
        puts "*** Completed caching of package #{options['package']}. ***"
        puts "\n\n"
        logger.info("Caching completed for package #{options['package']}.")
      else
        logger.info("Caching of package #{options['package']} failed.")
      end
    else
      puts "*** #{options['package'].capitalize} install failed, see journal. ***"
    end
  else
    show.usage("packages")
    exit
  end
  
when "reinstall", "-ri"
  if (ARGV.length == 2 && File.exist?("#{$PACKAGE_PATH}#{ARGV[1]}.rb"))
    options['package'] = ARGV[1]
    logger.info("Starting to reinstall #{options['package']}")
    
   if (manager.reinstall_package(options['package']))
      puts "\n\n"
      puts "*** Completed reinstall of #{options['package']}. ***"
      puts "\n\n"
      logger.info("Completed reinstall of #{options['package']}.")
    else
      puts "\n*** Unable to reinstall package #{options['package'].capitalize}, see why in the journal. ***"
    end    
  else
    show.usage("packages")
    exit
  end
  
when "remove", "-r"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    puts "Starting to remove #{options['package']}."
    logger.info("Starting to remove #{options['package']}.")
    
    # return if not installed.
    if (!(system.package_installed(options['package'])))
      puts "\n\n"
      puts "*** No need to remove #{options['package']}, it was not installed! ***"
      puts "\n\n"
    	logger.info("Unabel to complete removal of #{options['package']}.")
      exit
    end

    # is installed, remove package.
    if (manager.remove_package(options['package']))
      puts "\n\n"
      puts "*** Completed removal of #{options['package']}. ***"
      puts "\n\n"
    	logger.info("Unabel to complete removal of #{options['package']}.")
    end  
    
		puts "\n*** Unable to completed removal of #{options['package']}, see why in the journal. ***"
    logger.info("Unabel to complete removal of #{options['package']}.")
  else
    puts "\n*** Unable to completed removal of #{options['package']}, see why in the journal. ***"
    logger.info("Unabel to complete removal of #{options['package']}.")
    show.usage("packages")
    exit
  end

##
# [POSTPONED FEATURE, TO BE ADDED AT LATER VERSION/DATE]
##
#when "downgrade", "-dg"
#  if (ARGV.length == 3)
#    options['version'] = ARGV[1]
#    options['package'] = ARGV[2]
#    # downgrade pkg implementation.
#    print "Downgradinging package : #{options['package']} "
#    puts  "to version : #{options['version']}"
#  else
#    show.usage("packages")
#    exit
#  end
  
when "freeze", "-f"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    logger.info("Starting freeze of package : #{options['package']}")
		puts "\nAttempting to freeze package #{options['package']}."
		if (!manager.freeze_package(options['package']))
			puts "\nUnable to freeze package #{options['package']}, see journal for details."
		end
    
		logger.info("Completed (un)freeze of package : #{options['package']}")
		puts "\nCompleted freeze of package : #{options['package']}"
  else
    show.usage("packages")
    logger.info("Completed (un)freeze of package : #{options['package']}")
    exit
  end
  
when "search", "-s"
  if (ARGV.length == 2)
    options['searchString'] = ARGV[1]
    logger.info("Starting search of package descriptions for : #{options['searchString']}")
    searchResults = reporter.search_package_descriptions(options['searchString'].chomp)
    if (searchResults.empty?)
      puts "\nNothing found matching your search query."
      exit
    else
      # we have results hash!
      puts "\nSearch results for : #{options['searchString']} "
      puts "===================="
      searchResults.each_pair { |name, description| puts "#{name} \t: #{description}"  }
    end
    
    logger.info("Completed search of package descriptions for : #{options['searchString']}")
  else
    show.usage("queries")
    exit
  end
  
  # abt -v | --version
when "-v", "--version"
  if (ARGV.length == 1)
    puts "Abt Package Manager version is : #{$ABT_VERSION}"
  else
    show.usage("queries")
    exit
  end
  
  # abt show-details <package>
when "show-details"
  if (ARGV.length == 2 && File.exist?($PACKAGE_PATH + ARGV[1] + ".rb"))
    options['pkg'] = ARGV[1]
    logger.info("Starting show details for #{options['pkg']}")
    
    if (reporter.show_package_details(options['pkg']))
      logger.info("Completed show details for #{options['pkg']}")
    else
      puts "Problems processing the details for #{options['pkg']}."
    end
  else
    show.usage("queries")
  end
  
when "show-config"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    if !system.package_installed(options['package'])
      puts "\nThe package #{options['package']} is not installed, can't show the configure log."
      exit
    end

    puts "\nDisplay configure log for package : #{options['package']}"
    puts "===============================\n"
    reporter.show_package_log(options['package'], "configure")
  else
    show.usage("queries")
    exit
  end
  
when "show-build"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    if !system.package_installed(options['package'])
      puts "\nThe package #{options['package']} is not installed, can't show the build log."
      exit
    end

    puts "\nDisplay build log for package : #{options['package']}"
    puts "===============================\n"
    reporter.show_package_log(options['package'], "build")
  else
    show.usage("queries")
    exit
  end

  when "show-install"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    if !system.package_installed(options['package'])
      puts "\nThe package #{options['package']} is not installed, can't show the install log."
      exit
    end

    puts "\nDisplay install log for package : #{options['package']}"
    puts "===============================\n"
    reporter.show_package_log(options['package'], "install")
  else
    show.usage("queries")
    exit
  end

  when "show-integrity"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    if !system.package_installed(options['package'])
      puts "\nThe package #{options['package']} is not installed, can't show the integrity log."
      exit
    end

    puts "\nDisplay integrity log for package : #{options['package']}"
    puts "=================================\n"
    reporter.show_package_log(options['package'], "integrity")
  else
    show.usage("queries")
    exit
  end

when "show-depends"
  if (ARGV.length == 2 && File.exist?($PACKAGE_PATH + ARGV[1] + ".rb"))
    options['pkg'] = ARGV[1]
    logger.info("Starting show depends for #{options['pkg']}")
    if (reporter.show_package_dependencies(options['pkg']))
      logger.info("Completed show depends for #{options['pkg']}")
    else
      puts "Problems showing the depends for #{options['pkg']}."
    end
  else
    show.usage("queries")
    exit
  end
  
when "show-files"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    if !system.package_installed(options['package'])
      puts "\nThe package #{options['package']} is not installed, can't show it's installed files."
      exit
    end

    puts "\nDisplay installed files from package : #{options['package']}"
    puts "====================================\n"
    reporter.show_package_log(options['package'], "install")
  else
    show.usage("queries")
    exit
  end
  
when "show-owner"
  if (ARGV.length == 2)
    options['fileName'] = ARGV[1]
    # FIXME : display a file owner implementation.
    puts "Display owning package for file : " + options['fileName']
  else
    show.usage("queries")
    exit
  end
  
when "show-installed"
  if (ARGV.length == 1)
    reporter.show_installed_packages()
  else
    show.usage("queries")
    exit
  end
  
when "show-frozen"
  if (ARGV.length == 1)
    logger.info("Starting display of frozen packages.")
    frozenResults = reporter.show_frozen_packages
    if (frozenResults.empty?)
      puts "\n\nNothing is frozen at this time.\n\n"
    	logger.info("Completed display of frozen packages.")
      exit
    else
      # we have results hash!
			puts "\n\n\t========================"
			puts "\tAbTLinux frozen packages"
			puts "\t========================"
			puts "\nPackage name: \t\tFrozen since:"
			puts "============\t\t============="
      frozenResults.each_pair { |name, timestamp| puts "#{name} \t\t#{timestamp}"  }
    end
		
		#puts "==========================================="
		puts "\n\n"
    logger.info("Completed display of frozen packages.")
  else
    show.usage("queries")
    exit
  end
 
when "show-untracked"
  # FIXME : show untracked files implementation.
  puts "Display all files on system not tracked by AbTLinux."
  show.usage("queries")
  
  # abt show-journal
when "show-journal"
  reporter.show_journal($JOURNAL)
  
when "show-iqueue"
  reporter.show_queue("install")
  
when "show-patches"
  # FIXME : show patches implementation.
  puts "Display currently available patches for installed package tree."
  show.usage("queries")
  
when "show-updates"
  # FIXME : show updates implementation.
  puts "Display package listing with available update versions."
  show.usage("generation")
  
when "html"
  # FIXME : generate html installed pkgs implementation.
  puts "Generate HTML page from installed packages:"
  puts "  (package name with link to package website/version installed)"
  show.usage("generation")
  
  # abt news | -n
when "news", "-n"
  logger.info("Starting to retrieve AbTLinux news.")
  
  # abtlinux.org news feeds.
  puts "\n"
  if (!downloader.retrieve_news_feed($ABTNEWS))
    puts "Failed to retrieve the AbTLinux news feed."
  end
  
  puts "\n"
  if (!downloader.retrieve_news_feed($ABTNEWS_THREADS, false))
    puts "Failed to retrieve the AbTLinux forum threads news feed."
  end
  
  puts "\n"
  if (!downloader.retrieve_news_feed($ABTNEWS_POSTS, false))
    puts "Failed to retrieve the AbTLinux new posts news feed."
  end
  
  # display the file contents.
  reporter.show_journal($ABTNEWS_LOG)
  
  logger.info("Completed the retrieval of AbTLinux news.")
  
  # abt [-d | download ] <package>
when "download", "-d"
  if (ARGV.length == 2 && File.exist?($PACKAGE_PATH + ARGV[1] + ".rb"))
    options['pkg'] = ARGV[1]
    logger.info("Starting to download " + options['pkg'])
    
    manager = AbtDownloadManager.new
    
    if (manager.retrieve_package_source(options['pkg'], $SOURCES_REPOSITORY))
      logger.info("Finished download for " + options['pkg'])
      puts  "\n";
      print "Downloading of #{options['pkg']} to #{$SOURCES_REPOSITORY} "
      puts  "completed."
      puts  "\n\n"
    else
      logger.info("FAILURE to download " + options['pkg'])
      puts  "\n"
      puts "DOWNLOADING - failed to download source for #{options['pkg']}"
      puts "\n\n"
    end
  else
    show.usage("downloads")
    exit
  end
  
when "update", "-u"
  if (ARGV.length == 2)

      if (ARGV[1].length > 0 || ARGV[1] == "tree" || ARGV[1].downcase == "abtlinux")
        if ARGV[1].downcase == "tree" || ARGV[1].downcase == "abtlinux"
          options['updateItem'] = "AbTLinux"

          puts "Start updating package tree : #{options['updateItem']}."
          logger.info "Start updating package tree : #{options['updateItem']}."
          
          if downloader.update_package_tree(options['updateItem'])
              puts "Updated package tree : #{options['updateItem']}."
          else
              puts "Unable to update package tree : #{options['updateItem']}."
              logger.error "Unable to update package tree : #{options['updateItem']}."
              logger.info("Finished updating package tree : #{options['updateItem']}.")
              exit
          end

          logger.info("Finished updating package tree : #{options['updateItem']}.")
          
        else
          # assuming package to be updated.
          options['updateItem'] = ARGV[1].downcase

          puts "Start updating package : #{options['updateItem']}."
          logger.info "Start updating package : #{options['updateItem']}."
          
          if downloader.update_package(options['updateItem'])
              puts "Updated package : #{options['updateItem']}."
          else
              puts "Unable to update package : #{options['updateItem']}."
              logger.error "Unable to update package : #{options['updateItem']}."
              logger.info("Finished updating package : #{options['updateItem']}")
              exit
          end
          
          logger.info("Finished updating package : #{options['updateItem']}")                    
        end
      else
        show.usage("downloads")
        exit
      end
  else
      show.usage("downloads")
      exit      
  end
  
when "purge-src"
  if (ARGV.length == 1)
    logger.info("Starting to purge sources from packages that are not installed.")
    if (system.cleanup_package_sources)
      puts "\nPurged sources from packages that are not installed."
      logger.info("Finished purging sources from packages that are not installed.")
    else
      puts "\nUnable to complete a purge of sources from packages that are not installed, see journal."
      logger.info("Cleanup of package sources encountered problems, see journal.")
    end
  else  
    show.usage("fix")
    exit
  end
  
when "verify-files"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    logger.info("Starting verifcation of files for package : #{options['package']}.")

    if system.verify_installed_files(options['package'])
      puts "\nInstalled files verified for package : #{options['package']}"
      logger.info("Finished verifcation of files for package : #{options['package']}.")
      exit
    end
    
    logger.info("Finished verifcation of files for package : #{options['package']}.")
    puts "/nInstalled files verification for package : #{options['package']} failed, see journal."
  else
    show.usage("fix")
    exit
  end
  
when "verify-symlinks"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    # FIXME : verify symlinks for pkg implementation.
    puts "Symlinks verified for package : " + options['package']
  else
    show.usage("fix")
    exit
  end
  
when "verify-deps"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    # FIXME : verify deps for pkg implementation.
    puts "Symlinks verified for package : " + options['package']
  else
    show.usage("fix")
    exit
  end
  
when "verify-integrity"
  if (ARGV.length == 2)
    options['package'] = ARGV[1]
    logger.info("Starting verification of files for package : #{options['package']}.")

    integrityHash = system.verify_package_integrity(options['package'])
    if integrityHash.empty?
      puts "\nInstalled files integrity check completed without problems being detected for package : #{options['package']}"
      logger.info("Finished verification of files for package : #{options['package']}.")
      exit
    end
    
    integrityHash.each_pair {|file, problem| 
      puts "Problem with #{file} from package #{problem}"
      logger.info("Problem with #{file} from package #{problem}.")
    }
    
    puts "/nInstalled files integrity check failed for package : #{options['package']} failed, see journal."
  else
    show.usage("fix")
    exit
  end
  
when "fix"
  if (ARGV.length == 2)
    options['pkg'] = ARGV[1]
    # FIXME : fix package impelmentation.
    puts "Package : #{options['pkg']} is verified and checked if needed."
  else
    show.usage("fix")
    exit
  end
  
when "build-location"
  if (ARGV.length == 2)
    options['buildHost'] = ARGV[1]
    # FIXME : set global cache build location implementation.
    print "Sets global location for retrieving cached build packages "
    puts  "to : #{options['buildHost']}"
  else
    show.usage("maintenance")
    exit
  end
  
when "package-repo"
  
  case ARGV.length
    
    # add or remove called.
  when 3
    options['repoAction'] = ARGV[1]
    options['repoUri'] = ARGV[2]
    
    # list called.
  when 2
    # FIXME: implements this.
    if (ARGV[1] == "list")
      options['repoAction'] = ARGV[1]
      logger.info "TODO: Listing package repositories."
    elsif ARGV[1] == "add" || ARGV[1] == "remove"
      # add, remove or update default repo.
      options['repoAction'] = ARGV[1]
      options['repoUri']    = ""
    else
      show.usage("maintenance")
      exit
    end
    
  else
    show.usage("maintenance")
    exit
  end # case ARGV.length.

  logger.info("Starting package-repo : #{options['repoAction']}.")    
    
  # hook location based on action.
  case options['repoAction']
    
  when "add"
    if options['repoUri'].length > 0
        puts "Adding package repository : " + options['repoUri']
        if downloader.retrieve_package_tree(options['repoUri'])
            puts "Added package tree : #{options['repoUri']}."
        else
            puts "Unable to add package tree : #{options['repoUri']}."
            logger.error "Unable to add package tree : #{options['repoUri']}."
            logger.info("Finished package-repo : #{options['repoAction']}.")
            exit
        end
    else
        puts "Adding package repository : Default AbTLinux Package Tree"
        if downloader.retrieve_package_tree
            puts "Added package tree : Default AbTLinux Package Tree."
        else
            puts "Unable to add package tree : Default AbTLinux Package Tree."
            logger.error "Unable to add package tree : Default AbTLinux Package Tree."
            logger.info("Finished package-repo : #{options['repoAction']}.")
            exit
        end
    end

    when "remove"
    # FIXME: implement this.
      if options['repoUri'].length > 0
          puts "Removing package repository : " + options['repoUri']
      else
          puts "Removing package repository : Default AbTLinux Package Tree"
      end
    
  when "list"
    # FIXME: implement this.
    puts "TODO: Display listing of package repositories."
    
  else
    show.usage("maintenance")
    exit
  end # case repoAction.
  
  logger.info("Finished package-repo : #{options['repoAction']}.")
  
else
  show.usage("all")
end # case ARGV[0].
