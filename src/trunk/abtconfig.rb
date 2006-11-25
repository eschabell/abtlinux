#!/usr/bin/ruby -w

##
# abtconfig.rb 
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

# default paths / locations.
$PACKAGE_PATH       = "./packages/"
$SOURCES_REPOSITORY = "/var/spool/abt/sources"
$BUILD_LOCATION     = "/usr/src"
$ABT_LOGS           = "/var/log/abt"
$JOURNAL            = "#{$ABT_LOGS}/journal.log"


# default config options.
#
$ABT_VERSION           = "0.1"
$BUILD_ARCHITECTURE    = "x86_64"
$BUILD_OPTIMIZATIONS   = "strip"
$DEFAULT_PREFIX        = "/usr/local"
$REMOVE_BUILD_SOURCES  = false
$TIMESTAMP             = Time.now.strftime( "%Y-%m-%d %H:%M:%S (%Z)" )
$PAGER_DEFAULT         = "less -R -E -X -f"


# default URL listing.
#
$ABTNEWS            = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?1.2"
$ABTNEWS_POSTS      = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?7.2"
$ABTNEWS_THREADS    = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?6.2"

$APACHE_URL         = "http://www.ibiblio.org/pub/mirrors/apache"
$CTAN_URL           = "ftp://tug.ctan.org/tex-archive"
$GNOME_URL          = "ftp://ftp.gnome.org/pub/GNOME"
$GNU_URL            = "ftp://ftp.gnu.org/pub/gnu"
$KDE_URL            = "ftp://ftp.kde.org/pub/kde"
$KERNEL_URL         = "ftp://ftp.kernel.org"
$SOURCEFORGE_URL    = "http://osdn.dl.sourceforge.net/sourceforge"
$XFREE86_URL        = "ftp://ftp.xfree86.org/pub/XFree86"
