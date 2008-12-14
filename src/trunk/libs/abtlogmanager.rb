#!/usr/bin/ruby -w

##
# abtlogmanager.rb
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
  
  private
  
	##
  # Checks if the given install log has any entries that where renamed
  # based on the given collection of entries.
  # 
  # <b>PARAM</b> <i>Hash</i> - A hash of entries that where renamed during the install
  # with hash keys being the original name and the hash values being the new names.
  # <b>PARAM</b> <i>String</i> - Install log to be checked agianst the renamed entries.
  #
  # <b>RETURN</b> <i>void</i>
  ##
	def	check_for_file_renames(renames, install_log)
		# DEBUG: start check for renaming of files during installation.
		#renames.each_pair {|key, value| puts "#{key} is #{value}" }

		# cleanup install log renames.
		install_file = open(install_log, 'r+')
		lines = install_file.readlines
		install_file.close

		# check for changes due to renames.
		#puts "DEBUG: [install_log] read in old install log..."
		new_install = File.new(install_log,'w')
		
		lines.each do |line|
			changed = false  # keep track of renamed lines.
			renames.each_pair do |old, new|
				if line.chomp == old.chomp
					#puts "DEBUG: [CHANGES] detected change at :#{line}"
					new_install.puts new
					changed = true
				end
			end
			
			new_install.puts line if !changed
		end
	end

  public
  
  ##
  # Returns the path to given packages install log.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  # <b>PARAM</b> <i>String</i> - Type of log.
  #
  # <b>RETURN</b> <i>String</i> - Full path to install log.
  ##
  def get_log(package, type)
    require "#{$PACKAGE_PATH}/#{package}"
    sw         = eval("#{package.capitalize}.new")
    details    = sw.details
    
    case type
      
      when 'install'
        log = File.join($PACKAGE_INSTALLED, details['Source location'], "#{details['Source location']}.install")
      
      when 'integrity'
        log = File.join($PACKAGE_INSTALLED, details['Source location'], "#{details['Source location']}.integrity")
          
      when 'tmpinstall'
        log = File.join($ABT_TMP, "#{details['Source location']}.watch")

      when 'build'
        log = File.join($PACKAGE_INSTALLED, details['Source location'], "#{details['Source location']}.build")
          
      when 'configure'
        log = File.join($PACKAGE_INSTALLED, details['Source location'], "#{details['Source location']}.configure")

      else
        log = ""
        
    end        
        
    return log
  end
  
  ##
  # Constructor for the AbtLogManager. It ensures all needed logs paths are
  # initialized.
  #
  #
  # <b>RETURN</b> <i>AbtLogManager</i> - an initialized AbtLogManager object.
  ##
  def initialize
		if (! File.directory?($JOURNAL))
			# logging directory missing, create it!
			FileUtils.mkdir_p($ABT_LOGS)
		end

		logger = Logger.new($JOURNAL)
    [$ABT_LOGS, $ABT_CACHES, $ABT_STATE, $BUILD_LOCATION, $PACKAGE_INSTALLED, $ABT_LIBS,
    $PACKAGE_CACHED, $ABT_TMP, $ABT_CONFIG, $ABT_LOCAL_CONFIG, $SOURCES_REPOSITORY].each { |dir|
      
      if (! File.directory?(dir))
        FileUtils.mkdir_p(dir)
        logger.info("Created directory: #{dir}.")
      end
    }
  end
  
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
  def log_package_integrity(package)
		logger = Logger.new($JOURNAL)
  
    # our log locations.
    install_log = get_log(package, 'install')
    integrity_log = get_log(package, 'integrity')
    
    # get the installed files from the tmp file
    # into our install log.
    if (File.exist?(install_log))
      install_file   = open(install_log, 'r')
      integrity_file = open(integrity_log, 'w')

      # get the integrity for each file, initially just permissions.      
      IO.foreach(install_log) do |line|
				if File.exist?(line.chomp)
					status = File.stat(line.chomp)
					octal  = sprintf("%o", status.mode)
					integrity_file << "#{line.chomp}:#{octal}\n"
				else
					logger.info("[log_package_integrity] - #{line} is not installed, no worries, I will take care of everything...")
				end 
      end
      
      install_file.close
      integrity_file.close
    else
      return false  # no install log!
    end
    
    return true;
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
  def log_package_install(package)
		renames    = Hash.new  # to hold installwatch identified renames.
		duplicates = Hash.new  # to hold entries for duplicate checking.

    # some dirs we will not add to an install log.
    excluded_pattern = Regexp.new("^(/dev|/proc|/tmp|/var/tmp|/usr/src|/sys|#{$DEFAULT_PREFIX}/usr/src)+")
    
    # our log locations.
    install_log = get_log(package, 'install')
    tmpinstall_log = get_log(package, 'tmpinstall')
    
    # get the installed files from the tmp file
    # into our install log.
    if (File.exist?(tmpinstall_log))
      install_file = open(install_log, 'w')
      
      # include only the file names from open calls
      # and not part of the excluded range of directories.
      IO.foreach(tmpinstall_log) do |line|
				if (line.split[1] == 'rename')
					# they renamed the line, save this entry for cleaning
					# after install log is closed. Hash key is the original
					# installed file name, Hash value is the new file name.
					if !(renames.has_key?(line.split[2]))
						renames[line.split[2]] = line.split[3] 
					end
        elsif (line.split[1] == 'open') and File.exist?(line.split[2])
          if !(line.split[2] =~ excluded_pattern)
						# possible install log addition.
						if !duplicates.key?(line.split[2])
							# add to duplicate tracking hash and install log.
							duplicates[line.split[2]] = line.split[2]
							install_file << "#{line.split[2]}\n"
						end
          end
        end 
      end
			
			check_for_file_renames(renames, install_log) if !renames.empty?
    else
      # no tmp install file, thus no install running.
      return false
    end
    
    return true;
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
  def log_package_build(package)
    build_log = get_log(package, 'build')
    
    # make sure the build file exists.
    if (!File.exist?(build_log))
      return false
    end
    
    return true
  end

end
