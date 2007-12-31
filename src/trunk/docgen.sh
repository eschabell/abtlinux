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
FILES="./libs/abtdepengine.rb
		./libs/abtdownloadmanager.rb
		./libs/abtlogmanager.rb
		./libs/abtpackage.rb
		./libs/abtpackagemanager.rb
		./libs/abtqueuemanager.rb
		./libs/abtreportmanager.rb
		./libs/abtsystemmanager.rb
		./libs/abtusage.rb
		./tests/testabtdepengine.rb
		./tests/testabtdownloadmanager.rb
		./tests/testabtlogmanager.rb
		./tests/testabtpackage.rb
		./tests/testabtpackagemanager.rb
		./tests/testabtqueuemanager.rb
		./tests/testabtreportmanager.rb
		./tests/testabtsystemmanager.rb
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
