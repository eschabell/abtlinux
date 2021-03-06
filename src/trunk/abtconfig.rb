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

# global requires.
require 'fileutils'
require 'ftools'
require 'find'
require 'logger'
require 'digest/sha1'

# need this path here first before loading our project requires.
$DEFAULT_PREFIX = "/usr/local"
$ABT_LIBS       = File.join($DEFAULT_PREFIX, "var", "lib", "abt")
$LOAD_PATH.unshift $ABT_LIBS

# project requires.
require 'abtdownloadmanager'
require 'abtlogmanager'
require 'abtpackagemanager'
require 'abtpackage'
require 'abtdepengine'
require 'abtqueuemanager'
require 'abtreportmanager'
require 'abtsystemmanager'
require 'abtusage'

# default paths / locations.
$ABT_LOGS           = File.join($DEFAULT_PREFIX, "var", "log", "abt")
$ABT_CACHES         = File.join($DEFAULT_PREFIX, "var", "spool", "abt")
$ABT_STATE          = File.join($DEFAULT_PREFIX, "var", "state", "abt")
$ABT_TMP            = "/tmp/abt"
$ABT_CONFIG         = File.join($DEFAULT_PREFIX, "etc", "abt")
$ABT_LOCAL_CONFIG   = File.join($DEFAULT_PREFIX, "etc", "abt", "local")
$ABTNEWS_LOG        = File.join($ABT_LOGS, "news.log")
$BUILD_LOCATION		  = File.join($DEFAULT_PREFIX, "usr", "src")
$JOURNAL            = File.join($ABT_LOGS, "journal.log")  # use logger.info.
$PACKAGE_INSTALLED  = File.join($ABT_STATE, "installed")
$PACKAGE_CACHED     = File.join($ABT_STATE, "cached")
$PACKAGE_PATH       = File.join($ABT_CACHES, "packages")
$SOURCES_REPOSITORY = File.join($ABT_CACHES, "sources")


# default config options.
#
$ABT_VERSION           = "0.3"
$BUILD_ARCH            = "-march=pentium2"      # i686, pentium II.
$BUILD_SIZE            = "-Os"                  # optimize for size.
$BUILD_NODEBUG         = "-fomit-frame-pointer" # removes debug info.
$BUILD_SPEEDY          = "-pipe"                # faster compile, pipes into next function instead of temp files.
$BUILD_CFLAGS          = "#{$BUILD_ARCH} #{$BUILD_SIZE} #{$BUILD_SPEEDY} #{$BUILD_NODEBUG}" # all our build options.
$BUILD_PREFIX          = File.join($DEFAULT_PREFIX, "usr")
$BUILD_SYSCONFDIR      = File.join($DEFAULT_PREFIX, "etc")
$BUILD_LOCALSTATEDIR   = File.join($DEFAULT_PREFIX, "var")
$BUILD_MANDIR          = File.join($DEFAULT_PREFIX, "usr", "share", "man")
$BUILD_INFODIR         = File.join($DEFAULT_PREFIX, "usr", "share", "info")

$REMOVE_BUILD_SOURCES  = true
$TIMESTAMP             = Time.now.strftime( "%Y-%m-%d %H:%M:%S (%Z)" )
$PAGER_DEFAULT         = "less -R -E -X -f"
$LOG_LEVEL             = "Logger::DEBUG"
$ABTLINUX_PACKAGES     = "https://svn2.assembla.com/svn/abtlinux/src/trunk/packages"

# default URL listing.
#
$ABTNEWS            = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?1.2"
$ABTNEWS_POSTS      = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?7.2"
$ABTNEWS_THREADS    = "http://abtlinux.org/e107_plugins/rss_menu/rss.php?6.2"

$APACHE_URL         = "http://www.ibiblio.org/pub/mirrors/apache"
$CTAN_URL           = "ftp://tug.ctan.org/tex-archive"
$GNOME_URL          = "ftp://ftp.gnome.org/pub/GNOME"
$GNU_URL            = "http://ftp.gnu.org/gnu"
$KDE_URL            = "ftp://ftp.kde.org/pub/kde"
$KERNEL_URL         = "ftp://ftp.kernel.org"
$SOURCEFORGE_URL    = "http://osdn.dl.sourceforge.net/sourceforge"
$SOURCEFORGE_URL    = "http://belnet.dl.sourceforge.net/sourceforge"
$XFREE86_URL        = "ftp://ftp.xfree86.org/pub/XFree86"
