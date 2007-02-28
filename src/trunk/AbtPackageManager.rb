#!/usr/bin/ruby -w

##
# AbtPackageManager.rb
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
  
  public
  
  ##
  # Constructor for AbtPackageManager.
  #
  # <b>RETURN</b> <i>AbtPackageManager</i> - an initialized AbtPackageManager object.
  ##
  def initialize
  end
  
  ##
  # Installs a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be installed.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is installed, otherwise
  # false.
  ##
  def installPackage( package )
    require package
    sw = eval( "#{package.capitalize}.new" )
    queuer = AbtQueueManager.new
    logger = AbtLogManager.new
    
    # get package details.
    details = sw.details
    
    # TODO:  check deps
    
    # add to install queue.
    puts "\n*** Adding #{package} to the INSTALL QUEUE. ***"
    if ( !queuer.addPackageToQueue( package, "install" ) )
      logger.logToJournal( "Failed to add #{package} to install queue." )
      return false
    end
    
    # pre section.
    puts "\n*** Processing the PRE section for #{package}. ***"
    if ( !sw.pre )
      logger.logToJournal( "Failed to process pre-section in the package description of #{package}." )
      return false
    else
      logger.logToJournal( "DEBUG: finished #{package} pre section." )
    end
    
    # configure section.
    puts "\n*** Processing the CONFIGURE section for #{package}. ***"
    if ( !sw.configure )
      logger.logToJournal( "Failed to process configure section in the package description of #{package}." )
      return false
    else
      logger.logToJournal( "DEBUG: finished #{package} configure section." )
    end
    
    # build section.
    puts "\n*** Processing the BUILD section for #{package}. ***"
    if ( !sw.build )
      logger.logToJournal( "Failed to process build section in the package description of #{package}." )
      return false
    else
      if ( !logger.logPackageBuild( sw.name.downcase ) ) 
        logger.logToJournal( "Failed to create a package build log." )
        return false
      end
      logger.logToJournal( "DEBUG: finished #{package} build section." )
    end
    
    # preinstall section.
    puts "\n*** Processing the PREINSTALL section for #{package}. ***"
    if ( !sw.preinstall )
      logger.logToJournal( "Failed to process preinstall section in the package description of #{package}." )
      return false
    else
      logger.logToJournal( "DEBUG: finished #{package} preinstall section." )
    end
    
    # install section.
    puts "\n*** Processing the INSTALL section for #{package}. ***"
    if ( !sw.install )
      logger.logToJournal( "Failed to process install section in the package description of #{package}." )
      return false
    else
      logger.logPackageInstall( sw.name.downcase )
      logger.logToJournal( "DEBUG: finished #{package} install section." )
    end
    
    
    # TODO: finish up the following steps per install scenario:
    #
    # post section
    # remove build sources.
    #
    puts "\n*** Cleaning up the sources for #{package}. ***"
    if ( !sw.removeBuild )
      logger.logToJournal( "Failed to remove the build sources for #{package}." )
      #return false  # commented out as this is not a reason to fail.
    end
    
    return true
  end
  
  ##
  # Reinstalls a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be reinstalled.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is reinstalled, otherwise
  # false.
  ##
  def reinstallPackage( package )
  end
  
  ##
  # Removes a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be removed.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is removed, otherwise
  # false.
  ##
  def removePackage( package )
  end
  
  ##
  # Downgrades a given package.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be downgraded.
  #
  # <b>PARAM</b> <i>String</i> - the version number to be downgraded to.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is downgraded, otherwise
  # false.
  ##
  def downgradePackage( package, version )
  end
  
  ##
  # Freezes a given package. If successful will add give package to the frozen
  # list.
  #
  # <b>PARAM</b> <i>String</i> - the name of the package to be frozen.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package is frozen, otherwise
  # false.
  ##
  def freezePackage( package )
  end
  
  ##
  # Provides for a log through for root access using su.
  #
  # <b>PARAM</b> <i>Array</i> - the arguments passed to abt.
  #
  # <b>RETURN</b> <i>void</i>
  ##
  def rootLogin( arguments )
    if ( Process.uid != 0 )
      args = ""
      puts "\nEnter root password:"
      
      for i in 0...ARGV.length
        args = args + " " + ARGV[i]
      end
      
      system( 'su -c "./abt ' + args + '" root' )
      exit
    end
  end
end
