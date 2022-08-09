#!/bin/bash
#send email 
Recipient=”sandeep12vish@gmail.com.com”
Subject=”Greeting”
Message=”Hi there!”
`mail -s $Subject $Recipient <<< $Message`
