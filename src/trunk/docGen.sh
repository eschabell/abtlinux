#!/bin/bash
#===============================================================================
#
#         FILE:  docGen.sh
#
#        USAGE:  ./docGen.sh 
#
#  DESCRIPTION:  Generates AbTLinux Package Manager API documentation.
#
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Eric D. Schabell <erics@abtlinux.org> 
#      VERSION:  1.0
#      CREATED:  05/14/2006 10:31:24 AM CEST
#     REVISION:  ---
#===============================================================================

FILES=Package.rb

rdoc --diagram --inline-source --line-numbers --title "AbTLinux Package Manager API" $FILES
