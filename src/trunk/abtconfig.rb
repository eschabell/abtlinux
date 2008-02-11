#!/usr/bin/ruby -w
$DEFAULT_PREFIX = "/usr/local"
$LOAD_PATH.unshift "#{$DEFAULT_PREFIX}/var/lib/abt/"
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
require 'abtdownloadmanager'
require 'abtlogmanager'
require 'abtpackagemanager'
require 'abtpackage'
require 'abtdepengine'
require 'abtqueuemanager'
require 'abtreportmanager'
require 'abtsystemmanager'
require 'abtusage'

require 'fileutils'
require 'find'
require 'logger'
require 'digest/sha1'

# default paths / locations.
$ABT_LOGS           = "#{$DEFAULT_PREFIX}/var/log/abt"
$ABT_CACHES         = "#{$DEFAULT_PREFIX}/var/spool/abt"
$ABT_STATE          = "#{$DEFAULT_PREFIX}/var/state/abt"
$ABT_TMP            = "/tmp/abt"
$ABT_CONFIG         = "#{$DEFAULT_PREFIX}/etc/abt"
$ABT_LIBS           = "#{$DEFAULT_PREFIX}/var/lib/abt"
$ABT_LOCAL_CONFIG   = "#{$DEFAULT_PREFIX}/etc/abt/local"
$ABTNEWS_LOG        = "#{$ABT_LOGS}/news.log"
$BUILD_LOCATION		  = "#{$DEFAULT_PREFIX}/usr/src"
$JOURNAL            = "#{$ABT_LOGS}/journal.log"  # use logger.info.
$PACKAGE_INSTALLED  = "#{$ABT_STATE}/installed"
$PACKAGE_CACHED     = "#{$ABT_STATE}/cached"
$PACKAGE_PATH       = "#{$ABT_CACHES}/packages"
$SOURCES_REPOSITORY = "#{$ABT_CACHES}/sources"


# default config options.
#
$ABT_VERSION           = "0.2"
$BUILD_ARCH            = "-march=pentium2"      # i686, pentium II.
$BUILD_SIZE            = "-Os"                  # optimize for size.
$BUILD_NODEBUG         = "-fomit-frame-pointer" # removes debug info.
$BUILD_SPEEDY          = "-pipe"                # faster compile, pipes into next function instead of temp files.
$BUILD_CFLAGS          = "#{$BUILD_ARCH} #{$BUILD_SIZE} #{$BUILD_SPEEDY} #{$BUILD_NODEBUG}" # all our build options.
$BUILD_PREFIX          = "#{$DEFAULT_PREFIX}/usr"
$BUILD_SYSCONFDIR      = "#{$DEFAULT_PREFIX}/etc"
$BUILD_LOCALSTATEDIR   = "#{$DEFAULT_PREFIX}/var"
$BUILD_MANDIR          = "#{$DEFAULT_PREFIX}/usr/share/man"
$BUILD_INFODIR         = "#{$DEFAULT_PREFIX}/usr/share/info"

$REMOVE_BUILD_SOURCES  = true
$TIMESTAMP             = Time.now.strftime( "%Y-%m-%d %H:%M:%S (%Z)" )
$PAGER_DEFAULT         = "less -R -E -X -f"
$LOG_LEVEL             = "Logger::DEBUG"
$ABTLINUX_PACKAGES     = "https://abtlinux.svn.sourceforge.net/svnroot/abtlinux/src/trunk/packages"

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
$SOURCEFORGE_URL    = "http://belnet.dl.sourceforge.net/sourceforge"
$XFREE86_URL        = "ftp://ftp.xfree86.org/pub/XFree86"
