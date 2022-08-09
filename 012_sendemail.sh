#!/bin/bash
#send email 
Recipient=”abc@testmail.com”
Subject=”Greeting”
Message=”Hi there!”
`mail -s $Subject $Recipient <<< $Message`
