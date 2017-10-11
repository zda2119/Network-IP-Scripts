# Network-IP-Scripts

## Ping Sweep Tool

This tool will send one single ping request to the given hostname and return a Boolean T or F if it is sucessful or not.
If the host is not up, this tool will wait for time out.
All successful connections are outputed to output.txt (must exist in directory)

This tool takes in a input file in the format of:
192.168.1.0

XXX.XXX.XXX.XXX

XXX.XXX.XXX.XXX-XXX.XXX.XXX.XXX

XXX.XXX.XXX.XXX/24

XXX.XXX.XXX.XXX/16

This file must be located at C:\ScriptFiles\IP.txt (Can be changed in code)


## Port Scan Tool

This tool is an expansion of the Ping Sweep tool above. It takes in given IP addresses and Ports and attempts to connect on them.
If successful, the output is ported to the screen, not an output file.

This tool takes in an input file in the format of:
129.21.72.100

139

129.21.72.100-129.21.72.101

139

129.21.72.100

120-140

129.21.72.100

21,80,139

129.21.72.100-129.21.72.101

21,80,139

This file must be located at C:\ScriptFiles\Pt.txt (Can be changed in code)
