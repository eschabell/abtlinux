#!/bin/bash
#===============================================================================
#
#         FILE:  docgen.sh
#
#        USAGE:  ./docgen.sh 
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

TEMPLATE="./abttemplate.rb";
FILES="abtdepengine.rb
		abtdownloadmanager.rb
		abtlogmanager.rb
		abtpackage.rb
		abtpackagemanager.rb
		abtqueuemanager.rb
		abtreportmanager.rb
		abtsystemmanager.rb
		abtusage.rb
		testabtdepengine.rb
		testabtdownloadmanager.rb
		testabtlogmanager.rb
		testabtpackage.rb
		testabtpackagemanager.rb
		testabtqueuemanager.rb
		testabtreportmanager.rb
		testabtsystemmanager.rb
		";

# run the actual doc generation.
rdoc	--diagram                               \
		--template $TEMPLATE                    \
		--fileboxes                             \
		--inline-source                         \
		--line-numbers                          \
		--main AbtPackageManager                \
		--title "AbTLinux Package Manager API"  \
		$FILES

# remove old tarball and refresh with new docs.
#rm ./doc.tar.bz2
#tar cf doc.tar ./doc
#bzip2 doc.tar

# end docGen.sh
