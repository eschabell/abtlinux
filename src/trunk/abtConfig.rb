#!/usr/bin/ruby -w

##
# abtConfig.rb 
#
# The system configuration for the abt package manager.
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
$PACKAGE_PATH				= "./packages/"
$SOURCES_REPOSITORY	= "/var/spool/abt/sources"

$ABTNEWS            = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?1.2"
$ABTNEWS_THREADS    = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?6.2"
$ABTNEWS_POSTS      = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?7.2"
$MAX_NEWS_ITEMS     = 10  # shows last 10 items

$JOURNAL_PATH       = "/var/log/abt"
$JOURNAL            = "#{$JOURNAL_PATH}/journal.log"
