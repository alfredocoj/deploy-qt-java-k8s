#!/bin/bash

AppVersionDir="/usr/local/appjavaversion"
AppVersionDirRelease="/usr/local/appjavaversion/release"
AppVersionDirReleasePro=$AppVersionDirRelease/pro
AppVersionDirReleaseHom=$AppVersionDirRelease/hom
AppVersionDirReleaseDev=$AppVersionDirRelease/dev

#sudo pwd;

if ! [ -d $AppVersionDir ]
then
	mkdir -p $AppVersionDir;
	chmod 777 $AppVersionDir;
fi

if ! [ -d $AppVersionDirRelease ]
then
	mkdir -p $AppVersionDirRelease;
	chmod 777 $AppVersionDirRelease;
fi

if ! [ -d $AppVersionDirReleasePro ]
then
	mkdir -p $AppVersionDirReleasePro;
	chmod 777 $AppVersionDirReleasePro;
fi

if ! [ -d $AppVersionDirReleaseHom ]
then
	mkdir -p $AppVersionDirReleaseHom;
	chmod 777 $AppVersionDirReleaseHom;
fi

if ! [ -d $AppVersionDirReleaseDev ]
then
	mkdir -p $AppVersionDirReleaseDev;
	chmod 777 $AppVersionDirReleaseDev;
fi