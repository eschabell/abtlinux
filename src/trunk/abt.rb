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
require "AbtPackageManager"
require "AbtLogManager"
require "AbtReportManager"
require 'optparse'

##
# Parsing our options.
##
options = {}
ARGV.options do |options|
  options.on_tail('-h', '--help', 'Print this help information'){puts options; exit}
  options.on('-q', '--quiet', 'be verry quiet') do
    puts "OK, I'm being very, very, very quiet... can't you tell?"
  end
  options.on('-v', '--verbose', 'Run verbosely'){|v| puts "Option to be verbose passed"}
     
  options.parse!
end