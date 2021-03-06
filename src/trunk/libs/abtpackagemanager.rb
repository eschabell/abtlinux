#!/usr/bin/ruby -w

##
# abtpackagemanager.rb
#
# AbtPackageManager class will take care of the installation, removal, updating,
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
class AbtPackageManager
  
  protected
  
  private
  
  ##
  # Attempts to roll back a type of action. Current supported types are
  # install. Removes installed files and logs as needed.
  #
  # <b>PARAM</b> <i>String</i> - the type of rollback option to attempt.
  # <b>PARAM</b> <i>Array</i> - The details of the package for which the
  # rollback action is being called.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the action rolls back, otherwise
  # false.
  ##
  def roll_back(type, details)
    log_file = File.join($PACKAGE_INSTALLED, details['Source location'])
    
    case type
    when "install"
      log_file = log_file + "#{details['Source location']}.install"
      
      file = File.new(log_file, "r")
      while (line = file.gets)
        if (File.file?(line.chomp))
          File.delete(line.chomp)
        end
      end
      file.close
      
      # cleanup install log as it is incomplete.
      File.delete(log_file)
    else
      return false
    end
    
    return true
  end


  public
  
  ##
  # Constructor for AbtPackageManager.
  #
  # <b>RETURN</b> <i>AbtPackageManager</i> - an initialized 
  # AbtPackageManager object.
  ##
  def initialize
  end
  
  ##
  # Installs a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be installed.
  # <b>PARAM</b> <i>boolean</i> - true for verbose output from the process,
  # otherwise false. Default is true.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is installed, otherwise
  # false.
  ##
  def install_package(package, verbose=true)
    require "#{$PACKAGE_PATH}/#{package}"
    sw = eval("#{package.capitalize}.new")
    queuer = AbtQueueManager.new
    logger = Logger.new($JOURNAL)
		system = AbtSystemManager.new
    
    # TODO: refactor my_logger:
    my_logger = AbtLogManager.new
    
    # get package details.
    details = sw.details
    
		# check for frozen.
		if (system.package_frozen(package))
			logger.info "Package #{package} is frozen, can not proceed with install package call."
			puts "\nPackage #{package} is frozen, can not proceed with install package call."
			return false
		end

    # TODO:  check deps
    
    # add to install queue.
    puts "\n*** Adding #{package} to the INSTALL QUEUE. ***" if (verbose)
    
    if (!queuer.action_package_queue(package, "install", "add"))
      logger.info("Failed to add #{package} to install queue.")
      return false
    end

    # pre section.
    puts "\n*** Processing the PRE section for #{package}. ***" if (verbose)
    
    if (!sw.pre)
      logger.info("Failed to process pre-section in the package description of #{package}.")
      logger.info("Pre-section of #{package}, failure is related to downloading problems.")
      return false
    else
      logger.info("Finished #{package} pre section.")
    end
    
    # configure section.
    puts "\n*** Processing the CONFIGURE section for #{package}. ***" if (verbose)
    
    if (!sw.configure(verbose))
      logger.info("Failed to process configure section in the package description of #{package}.")
      return false
    else
      logger.info("Finished #{package} configure section.")
    end
    
    # build section.
    puts "\n*** Processing the BUILD section for #{package}. ***" if (verbose)
    
    if (!sw.build(verbose))
      logger.info("Failed to process build section in the package description of #{package}.")
      return false
    else
      if (!my_logger.log_package_build(sw.name.downcase)) 
        logger.info("Failed to create a package build log.")
        return false
      end
      logger.info("Finished #{package} build section.")
    end
    
    # preinstall section.
    puts "\n*** Processing the PREINSTALL section for #{package}. ***" if (verbose)
    
    if (!sw.preinstall)
      logger.info("Failed to process preinstall section in the package description of #{package}.")
      return false
    else
      logger.info("Finished #{package} preinstall section.")
    end
    
    # install section.
    puts "\n*** Processing the INSTALL section for #{package}. ***" if (verbose)

    if (!sw.install)
      # rollback installed files if any and remove install log.
      logger.info("Failed to process install section in the package description of #{package}.")
      my_logger.log_package_install(sw.name.downcase)
      logger.info("***Starting rollback of #{package} install and removing install log.")
      roll_back("install", details)
      return false
    else
      my_logger.log_package_install(sw.name.downcase)
      my_logger.log_package_integrity(sw.name.downcase)
      
      # cleanup tmp files from installwatch.
      File.delete("#{$ABT_TMP}/#{details['Source location']}.watch")

      logger.info("Finished #{package} install section.")
    end
    
    # post section.
    puts "\n*** Processing the POST section for #{package}. ***" if (verbose)
    
    if (!sw.post)
      logger.info("Failed to process post section in the package description of #{package}.")
      return false
    else
      logger.info("Finished #{package} post section.")
    end
    
    # clean out build sources.        
    puts "\n*** Cleaning up the sources for #{package}. ***" if (verbose)
    
    if (!sw.remove_build)
      logger.info("Failed to remove the build sources for #{package}.")
      #return false  # commented out as this is not a reason to fail.
    end
    
    # remove pacakge from install queue.
    if (!queuer.action_package_queue(sw.name.downcase, "install", "remove"))
      logger.info("Failed to remove #{sw.name.downcase} from install queue.")
    end
    
    return true # install completed!
  end
  
  # TODO: add install_cached_package(package)
  
  ##
  # Reinstalls a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be reinstalled.
  # <b>PARAM</b> <i>Boolean</i> - query the user if false (default), otherwise true and skip query.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is reinstalled, 
  # otherwise false.
  ##
  def reinstall_package(package, automated_build=false)
    logger = Logger.new($JOURNAL)
    manager = AbtPackageManager.new
		system   = AbtSystemManager.new
    
		# check for frozen.
		if (system.package_frozen(package))
			logger.info "Package #{package} is frozen, can not proceed with reinstall package call."
			puts "\nPackage #{package} is frozen, can not proceed with reinstall package call."
			return false
		end

		# check if already installed.
    if (system.package_installed(package))

			if !automated_build
      	puts "\n*** Package #{package} is already installed! ***\n"
      	puts "Are you sure you want to proceed with a reinstall? (y/n)"
      
      	while answer = STDIN.gets
        	answer.chomp!
        	if answer == "y"
          	break
        	elsif answer == "n"
          	exit
        	else 
          	puts "Are you sure you want to reinstall #{package}? (y/n)"
        	end
      	end
			end
    else
      puts "\n*** Package #{package} is not installed, we will install it for you now! ***\n"
    end
 
    if (install_package(package))
      puts "\n\n"
      puts "*** Completed reinstall of #{package}. ***"
      puts "\n\n"
      logger.info("Completed reinstall of #{package}.")
      
      if (manager.cache_package(package))
        puts "\n\n"
        puts "*** Completed caching of package #{package}. ***"
        puts "\n\n"
        logger.info("Caching completed for package #{package}.")
        return true
      else
        logger.info("Caching of package #{package} failed.")
      end
    end
      
    return false
  end
  
  ##
  # Removes a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be removed.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is removed, otherwise
  # false.
  ##
  def remove_package(package)
    require "#{$PACKAGE_PATH}/#{package}"
    sw = eval("#{package.capitalize}.new")
    # TODO: refactor my_logger.
    my_logger = AbtLogManager.new
    logger = Logger.new($JOURNAL)
		system = AbtSystemManager.new
    
    # get package details.
    details = sw.details
    
		# check for frozen.
		if (system.package_frozen(package))
			logger.info "Package #{package} is frozen, can not proceed with remove package call."
			puts "\nPackage #{package} is frozen, can not proceed with remove package call."
			return false
		end

    # TODO: something with possible /etc or other configure files before removal, check maybe integrity for changes since install?

    # remove listings in install log.
    install_log = my_logger.get_log(package, 'install')

    # only process install log if it exists, continue on with 
    # journal log warning.
    if File.exist?(install_log)
      IO.foreach(install_log) do |line|
        if File.exist?(line.chomp)
          FileUtils.rm(line.chomp)
          logger.info("Removed file #{line.chomp} from #{package} install log.")
        else
          logger.info("Unable to remove #{line.chomp} from #{package} install log, does not exist.")
          # do not return false, removed is ok, just put warning in journal log.
        end
      end
      
      logger.info("Removed files from #{File.basename(install_log)} for #{package}.")
    else
      puts "Install log missing for #{package}, see journal..."
      logger.info("Install log was missing for #{package}...")
      logger.info("...continuing to remove package from install listing, but might have files still installed on system.")
    end
      
          
    # remove entry in install listing.
    FileUtils.remove_dir(File.join($PACKAGE_INSTALLED, details['Source location']))    
    logger.info("Removed entry from installed packages.")
    return true
  end
  
  ##
  # Downgrades a given package. [POSTPONED FEATURE, TO BE ADDED AT LATER VERSION/DATE]
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be downgraded.
  #
  # <b>PARAM</b> <i>String</i> - the version number to be downgraded to.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is downgraded, otherwise
  # false.
  ##
#  def downgrade_package(package, version)
#		system = AbtSystemManager.new
#    logger = Logger.new($JOURNAL)
#
#		# check for frozen.
#		if (system.package_frozen(package))
#			logger.info "Package #{package} is frozen, can not proceed with downgrade package call."
#			puts "\nPackage #{package} is frozen, can not proceed with downgrade package call."
#			return false
#		end
#
#    return false
#  end
  
  ##
  # Freezes a given package. If successful will add give package to the frozen
  # list. If the given package is already frozen, it will be released.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be frozen.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is frozen, otherwise
  # false.
  ##
  def freeze_package(package)
		require "#{$PACKAGE_PATH}/#{package}"
    sw       = eval("#{package.capitalize}.new")
    logger   = Logger.new($JOURNAL)
		system   = AbtSystemManager.new
    
		if (system.package_installed(package))
			if (system.package_frozen(package))
    		logger.info("Package #{package} is already frozen!")

				# package already frozen, need to un-freeze by removing frozen.log
				# file.
				FileUtils.rm(File.join($PACKAGE_INSTALLED, sw.srcDir, "frozen.log"))
				puts "\nPackage #{package} was frozen, it has now been relased for use."
				logger.info "Package #{package} released : removed file #{$PACKAGE_INSTALLED}/#{sw.srcDir}/frozen.log"
			else
				# place file in $PACKAGE_INSTALLED frozen.log with date.
				frozen = File.open(File.join($PACKAGE_INSTALLED, sw.srcDir, "frozen.log"), "w")
				frozen.puts "#{$TIMESTAMP}"
				frozen.close
  			logger.info("Package #{package} is now frozen.")
  		end

			return true
		end
    
    logger.info("Package #{package} is not installed, unable to freeze it.")
    return false
  end
  
  ##
  # Provides for a log through for root access using su.
  #
  # <b>PARAM</b> <i>Array</i> - the arguments passed to abt.
  #
  # <b>RETURN</b> <i>void</i>
  ##
  def root_login(arguments)
    if (Process.uid != 0)
      args = ""
			puts "\nYou need to be root for accessing the requested functionality.\n"
      puts "\nEnter root password:"
      
      for i in 0...ARGV.length
        args = args + " " + ARGV[i]
      end
      
      system('su -c "./abt ' + args + '" root')
      exit
    end
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
  def cache_package(package)
    system = AbtSystemManager.new
    logger = AbtLogManager.new
    
    if (system.package_installed(package))
      sw            = eval("#{package.capitalize}.new")
      cached_dir    = File.join($PACKAGE_CACHED, sw.srcDir)
      source_path   = File.join($SOURCES_REPOSITORY, File.basename(sw.srcUrl))
      source_file   = File.basename(sw.srcUrl)
      install_log   = logger.get_log(package, 'install')
      build_log     = logger.get_log(package, 'build')
      configure_log = logger.get_log(package, 'configure')
      integrity_log = logger.get_log(package, 'integrity')
      package_file  = File.join($PACKAGE_PATH, "#{package}.rb")
      
      
      FileUtils.mkdir_p(cached_dir)

      # collect package source.
      if (FileTest::exist?(source_path))
        FileUtils.copy_file(source_path, File.join(cached_dir, source_file))
        puts "\nCaching copy of #{package} source."
      else
        puts "\nUnable to cache copy of #{package} source."
      end
        
      # collect package install log. 
      if (FileTest::exist?(install_log))
        FileUtils.copy_file(install_log, File.join(cached_dir, "#{sw.srcDir}.install"))
        puts "\nCaching copy of #{package} install log."
      else
        puts "\nUnable to cache copy of #{package} install log."
      end
      
      # collect package build log. 
      if (FileTest::exist?(build_log))
        FileUtils.copy_file(build_log, File.join(cached_dir, "#{sw.srcDir}.build"))
        puts "\nCaching copy of #{package} build log."
      else
        puts "\nUnable to cache copy of #{package} build log."
      end
      
      # collect package configure log. 
      if (FileTest::exist?(configure_log))
        FileUtils.copy_file(configure_log, File.join(cached_dir, "#{sw.srcDir}.configure"))
        puts "\nCaching copy of #{package} configure log."
      else
        puts "\nUnable to cache copy of #{package} configure log."
      end

      # collect package integrity log.
      if (FileTest::exist?(integrity_log))
        FileUtils.copy_file(integrity_log, File.join(cached_dir, "#{sw.srcDir}.integrity"))
        puts "\nCaching copy of #{package} integrity log."
      else
        puts "\nUnable to cache copy of #{package} integrity log."
      end
      
      # collect package description (class file).
      if (FileTest::exist?(package_file))
        FileUtils.copy_file(package_file, File.join(cached_dir, "#{package}.rb"))
        puts "\nCaching copy of #{package} package description."
      else
        puts "\nUnable to cache copy of #{package} package description, from location #{package_file}"
      end
      
      # tar and bzip this directory (package-cache-version.tar.bz2) 
      Dir.chdir($PACKAGE_CACHED)
      if (system("tar -cf #{sw.srcDir}.tar #{sw.srcDir}") &&
            system("bzip2 -f #{sw.srcDir}.tar"))
        # last but not least, remove our tarball directory
        FileUtils.rm_rf(cached_dir)
        return true
      end
    end
    
    return false  # package not installed, can't cache it.
  end
  
end
