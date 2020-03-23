#!/bin/sh

yum install -y scap-security-guide

oscap xccdf eval --remediate --fetch-remote-resources --profile xccdf_org.ssgproject.content_profile_stig-rhel7-disa --results /tmp/results.xml /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml > ~/oscap-output.txt
