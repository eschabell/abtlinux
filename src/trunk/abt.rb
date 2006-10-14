#!/usr/bin/ruby -w

##
# abt.rb 
#
# The central package manager script to run all ABout Time Linux tasks. 
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
require 'AbtPackageManager'
require 'AbtLogManager'
require 'AbtReportManager'
require 'optparse'

class AbtUsage

    def usage
        puts "Usage: abt.rb [options]\n\n"
        
        puts "packages:"
		puts "  -i,  install     [package]\t\tInstall given package."
		puts "  -ri, reinstall   [package]\t\tReinstall given package."
		puts "  -r,  remove      [package]\t\tRemove given package."
		puts "  -dg, downgrade   [version] [package]\tDowngrade given package to given version."
		puts "  -f,  freeze      [package]\t\tHolds given package at current version, prevents upgrades."
		puts
		puts "queries:"
		puts "  -s,  search      [string | regexp ]\tSearch package descriptions for given input."
		puts "  show-details     [package]\t\tShow give package details."
		puts "  show-build       [package]\t\tShow build log of given package."
		puts "  show-depends     [package]\t\tShow the dependency tree of given package."
		puts "  show-files       [package]\t\tShow all installed files from given package."
		puts "  show-owner       [file]\t\tShow the package owning given file."
        puts "  show-installed\t\t\tShow list of all installed packages."
		puts "  show-frozen\t\t\t\tShow list of all frozen packages."
		puts "  show-untracked\t\t\tShow all files on system not tracked by AbTLinux."
		puts "  show-journal\t\t\t\tShow the system journal."
		puts "  show-iqueue\t\t\t\tShow the contents of the install queue."
		puts "  show-patches\t\t\t\tShow the current available patches for installed package tree."
		puts
		puts "generation:"
		puts "  show-updates\t\tShow a package listing with available update versions."
		puts "  html\t\t\tGenerate HTML page from installed packages:"
        puts "  \t\t\t\t(package name with hyperlink to package website and version installed)"
        puts
        puts "downloads:"
        puts "  -d,  download     [package]\t\tRetrieve given package sources."
        puts "  -u,  update       [package]|[tree]\tUpdate given package or tree from AbTLinux repository."
        puts "  -n,  news\t\t\t\tDisplays newsfeed from AbTLinux website."
        puts
        puts "fix:"
        puts "  purge-src\t\t\t\tRemove source caches for packages no longer installed."
        puts "  purge-logs\t\t\t\tRemove log files for packages no longer installed."
        puts "  verify-files      [package]\t\tInstalled files are verified for given package."
        puts "  verify-symlinks   [package]\t\tSymlinks verified for given package."
        puts "  verify-deps       [package]\t\tDependency tree is verified for given package."
        puts "  verify-integrity  [package]\t\tVerify integrity of installed files for given package."
        puts "  fix               [package]\t\tGiven package is verified and fixed if needed."
	end
end

	##
	# Parsing our options.
	##
	options = Hash.new()
	show = AbtUsage.new();
	
	if ( ARGV.length == 0 )
		show.usage
	end
	
	case ARGV[0]
		
	when "install", "-i"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Installing package : " + options['package']
		else
			show.usage
			exit
		end
		
		
	when "reinstall", "-ri"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Reinstalling package : " + options['package']
		else
			show.usage
			exit
		end
		
	when "remove", "-r"
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Removing package : " + options['package']
		else
			show.usage
			exit
		end
		
	when "downgrade", "-dg"
		if ( ARGV.length == 3 )
		    options['version'] = ARGV[1]
			options['package'] = ARGV[2]
			puts "Downgradinging package : " + options['package'] + " to version : " + options['version']
		else
			show.usage
			exit
		end
		
	when "freeze", "-f"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Holdinging package : " + options['package'] + " at the current version."
		else
			show.usage
			exit
		end
		
	when "search", "-s"  
		if ( ARGV.length == 2 )
			options['searchString'] = ARGV[1]
			puts "Searching package descriptions for : " + options['searchString']
		else
			show.usage
			exit
		end

    when "show-details"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display details for package : " + options['package']
		else
			show.usage
			exit
		end

    when "show-build"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display build log for package : " + options['package']
		else
			show.usage
			exit
		end


    when "show-depends"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display dependency tree for package : " + options['package']
		else
			show.usage
			exit
		end

    when "show-files"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Display installed files from package : " + options['package']
		else
			show.usage
			exit
		end

    when "show-owner"  
		if ( ARGV.length == 2 )
			options['fileName'] = ARGV[1]
			puts "Display owning package for file : " + options['fileName']
		else
			show.usage
			exit
		end

    when "show-installed"  
		puts "Display all installed packages."

    when "show-frozen"  
		puts "Display all packages frozen at current version."

    when "show-untracked"  
		puts "Display all files on system not tracked by AbTLinux."

    when "show-journal"  
		puts "Display system log with AbTLinux activity."

    when "show-iqueue"  
		puts "Display contents of install queue."

    when "show-patches"  
		puts "Display currently available patches for installed package tree."

    when "show-updates"  
		puts "Display package listing with available update versions."

    when "html"
        puts "Generate HTML page from installed packages:"
        puts "  (package name with hyperlink to package website and version installed)"

    when "news", "-n"
        puts "Display AbTLinux website newsfeed."
                
    when "download", "-d"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Retrieve sources for package : " + options['package']
		else
			show.usage
			exit
		end
		
    when "update", "-u"  
		if ( ARGV.length == 2 )
			options['updateItem'] = ARGV[1]
			puts "Updating this item (either package or a package tree : " + options['updateItem']
		else
			show.usage
			exit
		end

    when "purge-src"
        puts "Remove source caches for packages no longer installed."

    when "purge-logs"
        puts "Remove log files for packages no longer installed."

    when "verify-files"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Installed files verified for package : " + options['package']
		else
			show.usage
			exit
		end

    when "verify-symlinks"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Symlinks verified for package : " + options['package']
		else
			show.usage
			exit
		end

    when "verify-deps"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Symlinks verified for package : " + options['package']
		else
			show.usage
			exit
		end
        
    when "verify-integrity"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Verifiy the integrity of installed files for package : " + options['package']
		else
			show.usage
			exit
		end

    when "fix"  
		if ( ARGV.length == 2 )
			options['package'] = ARGV[1]
			puts "Package : " + options['package'] + " is verified and checked if needed."
		else
			show.usage
			exit
		end
    end # case
	
	#puts 'DEBUG: options are -'
	#puts 'package => ' + options['package']
	#puts 'DEBUG: argv is -'
	#puts ARGV[0]
	#puts ARGV[1]
	#puts 'DEBUG: number of args are -'
	#puts ARGV.length