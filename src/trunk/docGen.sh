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

TEMPLATE="./abtTemplate.rb";
FILES="AbtPackageManager.rb 
       AbtPackage.rb 
			 AbtDownloadManager.rb 
			 AbtSystemManager.rb
			 AbtLogManager.rb
			 AbtReportManager.rb
			 AbtQueueManager.rb
			 AbtDepEngine.rb
			 TestAbtDepEngine.rb
			 TestAbtPackage.rb
			 ";

# run the actual doc generation.
rdoc 	--diagram                               \
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
