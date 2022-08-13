#!/system/bin/sh

# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

# Default status
STATUS=invalid

# Function to read efuse
function efuse_read() {
	local result=invalid
	ewriter 0 0 1 > /dev/null 2>&1

	if [ $? -eq 0 ]; then
		result=$(ewriter 0 0 1 | sed '2!d')
	else
		log -t efuse Reading e-Fuse failed
	fi

	echo $result
}

# Function to write efuse
function efuse_write() {
	log -t efuse Writing e-Fuse
	ewriter 1 0 1 1 > /dev/null 2>&1

	if [ $? -eq 0 ]; then
		log -t efuse Writing e-Fuse succeeded
	else
		log -t efuse Writing e-Fuse failed
	fi
}

# Do an initial e-Fuse read
STATUS=$(efuse_read)

# Log the value in logcat buffer
log -t efuse Initial e-Fuse value: $STATUS
# ...and property
setprop efuse.status $STATUS

# Quit when it matches expected value
if [ $STATUS = "01" ]; then
	log -t efuse No more work needed
	exit 0
fi

# Write e-Fuse
efuse_write

# Perform a second read
STATUS=$(efuse_read)

# Log the value in logcat buffer
log -t efuse Re-read e-Fuse value: $STATUS
# ...and property
setprop efuse.status $STATUS
