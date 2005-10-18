#!/bin/bash


/usr/bin/find ./abtlinux-www/ -type f -exec /usr/bin/sed -i 's/ with //' {} \;
/usr/bin/find ./abtlinux-www/ -type f -exec /usr/bin/sed -i 's/KPresenter//' {} \;
