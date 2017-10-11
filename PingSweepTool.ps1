<#
Zach Anthony Powershell IP sweep tool
Lab 02 - Part 3 - Ping Sweep Tool
Takes a line delimited file and pings each address with one packet
Accepts following formats:
    192.168.0.1
    192.168.0.0/24/16
    192.168.0.1-192.168.0.254
Outputs IPs of successful connections to a txt file
#>

#Import input file
$IP_LIST = Get-Content C:\ScriptFiles\IP.txt

#Clear Content in existing output file
Clear-Content C:\ScriptFiles\Output.txt

#Pull Number of lines out the file 
$LoadFileInfo = $IP_LIST | Measure-Object
$num_IP_lines = $LoadFileInfo.Count

#Loop through File pinging Each IP

$pointer = 0

    #Count number of lines in input file, loop through each line with
    #curr being the line currently being pointed to.
    while ($pointer -lt $num_IP_lines){
        echo "----------------------------------------------"
        $curr= (Get-Content C:\ScriptFiles\IP.txt)[$pointer]
        Write-Host "Testing $curr"

        #This if-while loop pair handles the XXX.XXX.XXX.XXX-XXX.XXX.XXX.XXX IP range input format
        if ($curr -like '*-*'){
            #Split string into two addresses on the - character
            $Spot = $curr.IndexOf("-")
            $LeftHost = $curr.Substring(0, $Spot)
            $RightHost = $curr.Substring($Spot+1)

            #Pulls the last octect of the Left address from the rest of the address
            $part1 = $LeftHost.LastIndexOf(".")
            $LeftBegin = $LeftHost.Substring($part1+1)
            $RestOfLeft = $LeftHost.Substring(0, $part1)
            
            #Convert last octect to integer for comparison
            [int]$Left = [convert]::ToInt32($LeftBegin, 10)
            
            #Pulls the last octect of the Right address from the rest of the address
            $part2 = $RightHost.LastIndexOf(".")
            $RightEnd = $RightHost.Substring($part2+1)
            $RestOfRight = $RightHost.Substring(0, $Part2)

            #Converts to Integer for comparison
            [int]$Right = [convert]::ToInt32($RightEnd, 10)
            
            
            #Tests the - input format, left being the last octect of the 
            #lower address and right being the final address
            while ($Left -le $Right){
                $loopIP = $RestOfLeft + '.' + $Left
                #echo $loopIP
                Write-Host "Testing $loopIP"
                $OutputD = Test-Connection $loopIP -Count 1 -Quiet
                
                    #If the output is successful (Boolean True), then write to the output file,
                    #If it fails, do not write to the file
                    If ($OutputD){
                        write-host "$LoopIP was successful"
                        $FileOutputD = "$LoopIP Was Successful"
                        echo $FileOutputD >> C:\ScriptFiles\Output.txt
                        }
                        Else{
                            echo "$LoopIP failed"
                        }
                $left++
            }
            
           
        }
        #This pair handles the /24 and /16 mask addressing input
        elseif ($curr -like '*/*'){
            
            #Split string into the IP and the mask on the '/' deliminator
            $Point = $curr.IndexOf("/")
            $BeginningofString = $curr.Substring(0, $Point)
            $mask = $curr.Substring($Point+1)
            
            #Pulls of the last octect, returns the base
            $part3 = $BeginningofString.LastIndexOf(".")
            $Base = $Beginningofstring.Substring(0, $part3)

            #Sets up for /24 addressing
            if ($mask -like "24"){
                $Start = 0
                $End = 255

                #Loops through testing the base with 0-255 (xxx.xxx.xxx.0-255)
                while ($Start -le $End){
                    $loopIP1 = $Base + '.' + $Start
                    Write-Host "Testing $loopIP1"
                    $OutputC = Test-Connection $loopIP1 -Count 1 -Quiet
                    
                    #If the connection is successful output IP to file, if not do nothing
                    If ($OutputC){
                        write-host "$LoopIP1 was successful"
                        $FileOutputC = "$LoopIP1 Was Successful"
                        echo $FileOutputC >> C:\ScriptFiles\Output.txt
                        }
                        Else{
                            echo "$LoopIP1 failed"
                        }
                    $start++
                }
            }

            #Handles the /16 addressing
            elseif ($mask -like "16"){
                $StartA = 0
                $StartB = 0
                $end = 255

                #Pulls 3rd octect off of base
                $part4 = $base.LastIndexOf(".")
                $base2 = $BeginningofString.Substring(0, $part4)

                #Loops through each address XXX.XXX.0-255.0-255
                while ($StartA -le $end){
                    $startA++
                    $startB = 0

                    while ($StartB -le $end){
                        $loopip2 = $base2 + '.' + $StartA + '.' + $StartB
                        Write-host "Testing $loopip2"                        
                        $OutputB = Test-Connection $loopip2 -Count 1 -Quiet

                        #If connection is successful, output the IP to a txt file
                        If ($OutputB){
                            write-host "$LoopIP2 was successful"
                            $FileOutputB = "$LoopIP2 Was Successful"
                            echo $FileOutputB >> C:\ScriptFiles\Output.txt
                        }
                        Else{
                            echo "$LoopIP2 failed"
                        }

                        $StartB++
                    }
                
                }
                
            }   
        }

        #Basic xxx.xxx.xxx.xxx handling statement, If the line being pointed to does
        #not have a '-' or '/' format, it will hit this statement. If an address is incomplete
        #it will still hit this statement, but will always produce a 'False' boolean output
        #and will not be written to the output file.
        else{
            $OutputA = Test-Connection $curr -Count 1 -Quiet
            
            #If succsesful, write to output file
            If ($OutputA){
                write-host "$curr was successful"
                $FileOutputA = "$curr Was Successful"
                echo $FileOutputA >> C:\ScriptFiles\Output.txt
            }
            Else{
                echo "$curr failed"
            }
        }
        
        #Increment pointer to the next line in the input file
        $pointer++
    }