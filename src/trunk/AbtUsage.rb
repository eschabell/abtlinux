#!/usr/bin/ruby -I./packages

##
# AbtUsage.rb 
#
# The usage reporting class for AbTLinux.
# 
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright November 2006, GPL.
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
class AbtUsage

	##
	# The main usage method, displays either a given section or all sections.
	#
	# <b>PARAM</b> <i>String</i> - the name of the help section to be shown.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usage( section )
		puts "Usage: abt.rb [options]\n\n"

		case section

		when "packages"
			usagePackages
		
		when "queries"
			usageQueries

		when "generation"
			usageGeneration

		when "downloads"
			usageDownloads

		when "fix"
			usageFix

		when "maintenance"
			usageMaintenance
		
		else
			usagePackages
			usageQueries
			usageGeneration
			usageDownloads
			usageFix
			usageMaintenance
		end
	end

	##
	# The usage information for the packages commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usagePackages
		puts "\npackages:"
		puts "  -i,  install     [package]\t\tInstall given package."
		puts "  -ri, reinstall   [package]\t\tReinstall given package."
		puts "  -r,  remove      [package]\t\tRemove given package."
		puts "  -dg, downgrade   [version] [package]\tDowngrade given package to given version."
		puts "  -f,  freeze      [package]\t\tHolds given package at current version, prevents upgrades.\n"
	end

	##
	# The usage information for the query commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usageQueries
		puts "\nqueries:"
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
		puts "  show-patches\t\t\t\tShow the current available patches for installed package tree.\n"
	end

	##
	# The usage information for the generation commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usageGeneration
		puts "\ngeneration:"
		puts "  show-updates\t\tShow a package listing with available update versions."
		puts "  html\t\t\tGenerate HTML page from installed packages:"
		puts "  \t\t\t\t(package name with hyperlink to package website and version installed)\n"
	end

	##
	# The usage information for the download commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usageDownloads
		puts "\ndownloads:"
		puts "  -d,  download     [package]\t\tRetrieve given package sources."
		puts "  -u,  update       [package]|[tree]\tUpdate given package or tree from AbTLinux repository."
		puts "  -n,  news\t\t\t\tDisplays newsfeeds from AbTLinux website.\n"
	end

	##
	# The usage information for the fix commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usageFix
		puts "\nfix:"
		puts "  purge-src\t\t\t\tRemove source caches for packages no longer installed."
		puts "  purge-logs\t\t\t\tRemove log files for packages no longer installed."
		puts "  verify-files      [package]\t\tInstalled files are verified for given package."
		puts "  verify-symlinks   [package]\t\tSymlinks verified for given package."
		puts "  verify-deps       [package]\t\tDependency tree is verified for given package."
		puts "  verify-integrity  [package]\t\tVerify integrity of installed files for given package."
		puts "  fix               [package]\t\tGiven package is verified and fixed if needed.\n"
	end

	##
	# The usage information for the maintenance commands.
	#
	# <b>RETURN</b> <i>void</i>
	##
	def usageMaintenance
		puts "\nmaintenance:"
		puts "  build-location    [host]\t\tSets global location (default: localhost) for retrieving cached package builds."
		puts "  package-repo      [add|remove|list] [URI]"
		puts "                                        add    - add package repository to list."
		puts "                                        remove - remove a package repository from list."
		puts "                                        list   - display current repository list.\n"
	end
end
