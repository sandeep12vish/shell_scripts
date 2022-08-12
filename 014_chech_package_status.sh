#!/bin/sh

if ! rpm -qa | grep -qw $package_name$; then
    yum install $package_name
fi
