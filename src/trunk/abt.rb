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
          puts "  -i,  install     [package]\t\tInstall given package."
          puts "  -ri, reinstall   [package]\t\tReinstall given package."
          puts "  -r,  remove      [package]\t\tRemove given package."
          puts "  -dg, downgrade   [version] [package]\tDowngrade given package to given version."
          puts "  -f,  freeze      [package]\t\tHolds given package at current version, prevents upgrades."
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
        else
            show.usage
            exit
        end
            
    
    when "reinstall", "-ri"
        if ( ARGV.length == 2 )
            options['package'] = ARGV[1]
        else
            show.usage
            exit
        end
    
    when "remove", "-r"
        if ( ARGV.length == 2 )
            options['package'] = ARGV[1]
        else
            show.usage
            exit
        end
    
    when "downgrade", "-dg"
        if ( ARGV.length == 2 )
            options['package'] = ARGV[1]
        else
            show.usage
            exit
        end
    
    when "freeze", "-f"  
        if ( ARGV.length == 2 )
            options['package'] = ARGV[1]
        else
            show.usage
            exit
        end
end

#puts 'DEBUG: options are -'
#puts 'package => ' + options['package']
#puts 'DEBUG: argv is -'
#puts ARGV[0]
#puts ARGV[1]
#puts 'DEBUG: number of args are -'
#puts ARGV.length