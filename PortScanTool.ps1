<#
Zachary Anthony
Lab 02- Part 5 - Port Scan tool
Takes in txt file in the following format:
IP
PORTS
IE. IP = 192.168.0.1 || 192.168.0.1-192.168.0.5 ||
PORT = 20 || 1-200 || 1,2,3
#>



#Import input file
$IP_LIST = Get-Content C:\ScriptFiles\Pt.txt

#Pull Number of lines out the file 
$LoadFileInfo = $IP_LIST | Measure-Object
$num_IP_lines = $LoadFileInfo.Count

$pointer = 0

while ($pointer -lt $num_IP_lines){
    $curr = (Get-Content C:\ScriptFiles\Pt.txt)[$pointer]
    $port = (Get-Content C:\ScriptFiles\Pt.txt)[$pointer+1]


    ###################
    #Error Handling. Breaks loop if the even lines in the input
    #file are IP addresses and not properly formatted ports or
    #attempt to test unexisting ports (< 65535)
    ###################
    #$Portcompar =  [convert]::ToInt32($port, 10)
    [int32]$HighestPort = [convert]::ToInt32(65535, 10)
    

    if($port -notlike '*,*' -or $port -notlike '*-*'){
        if($port -like '*.*' -or $port -gt $HighestPort){
            echo "Incorrect input file syntax"`n"It should be:"`n"IP (123.456.789.123 || 123.456.789.123-123.456.789.125)"`n"Port (80 || 80-200 && < 65535) "
            break
        }
    }

    
    #####################
    #Handles if IP like xxx.xxx.xxx.xxx-xxx.xxx.xxx.xxx
    #####################

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


        while ($Left -le $Right){

        ########################
        #If statement handles if there is a range or IP XXX-XXX and a Range of ports X-X
        ########################

            if ($port -like '*-*'){
                #Split string into two addresses on the - character
                $Spot = $port.IndexOf("-")
                $LeftPortA = $port.Substring(0, $Spot)
                $RightPortA = $port.Substring($Spot+1)
                #echo $curr
                #echo $LeftPort
                #echo $RightPort
            
                #Convert last octect to integer for comparison
                [int]$LeftPort = [convert]::ToInt32($LeftPortA, 10)

                #Converts to Integer for comparison
                [int]$RightPort = [convert]::ToInt32($RightPortA, 10)
                

                while ($LeftPort -le $RightPort){
                    $loopIP = $RestOfLeft + '.' + $Left
                    try {
                        Write-Host("Testing $loopip on Port $leftport") 
                        #$Object = New-Object system.Net.Sockets.TcpClient
                        #$Connection = $Object.Connect($curr,$port) 
                        $t = New-Object Net.Sockets.TcpClient
                        $t.Connect($loopip,$leftport)
                            if($t.Connected)
                            {
                                "Port $leftPort is open on $loopip"
                            }
                            else
                            {
                                "Port $leftPort is closed on $loopip"
                            }

                        }
                        catch {
                        "Port $leftport is closed on $loopip"
                        }
                    $LeftPort++

                }
                $left++
            }

            ###############################
            #Handles if Port Range like X,X,X,X.....
            ###############################

            elseif($port -like '*,*'){
                $countA = 1
                $y = 0
                $separatorA = ','
                $option = [System.StringSplitOptions]::RemoveEmptyEntries
                $outputX = $port.split($SeparatorA, $option)
                $NumPortsX = $outputX.count


                while($CountA -le $NumPortsX){
                    $TestPortX = $outputX[$y]
                    $loopIPX = $RestOfLeft + '.' + $Left
                    
                    try {
                        Write-Host("Testing $loopIPX on Port $testportx") 
                        #$Object = New-Object system.Net.Sockets.TcpClient
                        #$Connection = $Object.Connect($curr,$port) 
                        $t = New-Object Net.Sockets.TcpClient
                        $t.Connect($loopipX,$testportx)
                            if($t.Connected)
                            {
                                "Port $testPortx is open on $loopipx"
                            }
                            else
                            {
                                "Port $testPortx is closed on $loopipx"
                            }

                        }
                        catch {
                        "Port $testportx is closed on $loopipx"
                        }
                    $y++
                    $countA++
                }
                $left++
            }
            
            ##########################
            # Else Handles a Range of IP XXX-XXX and one single port
            ##########################
            
            else{
                while($left -le $right){
                    $loopIP = $RestOfLeft + '.' + $Left
                    try {
                        Write-Host("Testing $loopip on Port $port") 
                        #$Object = New-Object system.Net.Sockets.TcpClient
                        #$Connection = $Object.Connect($curr,$port) 
                        $t = New-Object Net.Sockets.TcpClient
                        $t.Connect($loopip,$port)
                            if($t.Connected)
                            {
                                "Port $Port is open on $loopip"
                            }
                            else
                            {
                                "Port $Port is closed on $loopip"
                            }

                        }
                        catch {
                        "Port $port is closed on $loopip"
                        }
                $Left++
                }
            }
            }
        }


    ####################
    #Handles if IP like xxx.xxx.xxx.xxx/24 or xxx.xxx.xxx.xxx/16
    ####################
    Elseif($curr -like '*/*'){
        $Point = $curr.IndexOf("/")
        $BeginningofString = $curr.Substring(0, $Point)
        $mask = $curr.Substring($Point+1)
            
        #Pulls of the last octect, returns the base
        $part3 = $BeginningofString.LastIndexOf(".")
        $Base = $Beginningofstring.Substring(0, $part3)
        echo $curr
        echo $mask

        ##########################
        #If mask is /24
        ##########################
        if ($mask -like "24"){
            $Start = 0
            $End = 255

            #Loops through testing the base with 0-255 (xxx.xxx.xxx.0-255)
            while ($Start -le $End){
                $loopIP1 = $base + '.' + $Start
                try {
                    Write-Host("Testing $loopip1 on Port $port") 
                    #$Object = New-Object system.Net.Sockets.TcpClient
                    #$Connection = $Object.Connect($curr,$port) 
                    $t = New-Object Net.Sockets.TcpClient
                    $t.Connect($loopip1,$port)
                        if($t.Connected)
                        {
                            "Port $Port is open on $loopip1"
                        }
                        else
                        {
                            "Port $Port is closed on $loopip1 "
                        }

                    }
                    catch {
                    "Port $port is closed on $loopip1 "
                    
                    }
                $start++
            }
        }

        ########################
        # Handles if mask like /16
        ########################

        elseif ($mask -like "16"){
            $StartA = 0
            $StartB = 0
            $endB = 255

            #Pulls 3rd octect off of base
            $part4 = $base.LastIndexOf(".")
            $base2 = $BeginningofString.Substring(0, $part4)

            #Loops through each address XXX.XXX.0-255.0-255
            while ($StartA -le $endB){
                $startA++
                $startB = 0
                while ($StartB -le $end){
                    $loopip2 = $base2 + '.' + $StartA + '.' + $StartB                       

                    #If connection is successful, output the IP to a txt file
                    try {
                        Write-Host("Testing $loopip2 on Port $port") 
                        #$Object = New-Object system.Net.Sockets.TcpClient
                        #$Connection = $Object.Connect($curr,$port) 
                        $t = New-Object Net.Sockets.TcpClient
                        $t.Connect($loopip2,$port)
                            if($t.Connected)
                            {
                                "Port $Port is open on $loopip2"
                            }
                            else
                            {
                                "Port $Port is closed on $loopip2"
                            }

                        }
                        catch {
                        "Port $port is closed on $loopip2"
                        }

                    $StartB++
                }
                
            }
                
        } 
    }

    #####################
    #Handle if just one IP xxx.xxx.xxx.xxx
    #####################

    else{

        ################
        #If-While pair Handles one IP and a range of ports XXX-XXX
        #################

        if ($port -like '*-*'){
        #Split string into two addresses on the - character
        $Spot = $port.IndexOf("-")
        $LeftPort = $port.Substring(0, $Spot)
        $RightPort = $port.Substring($Spot+1)
            
        #Convert last octect to integer for comparison
        [int]$LeftPort = [convert]::ToInt32($LeftPort, 10)

        #Converts to Integer for comparison
        [int]$RightPort = [convert]::ToInt32($RightPort, 10)

        while ($LeftPort -le $RightPort){
            try {
                Write-Host("Testing $curr on Port $leftport") 
                #$Object = New-Object system.Net.Sockets.TcpClient
                #$Connection = $Object.Connect($curr,$port) 
                $t = New-Object Net.Sockets.TcpClient
                $t.Connect($curr,$leftport)
                    if($t.Connected)
                    {
                        "Port $leftPort is open on $curr"
                    }
                    else
                    {
                        "Port $leftPort is closed on $curr "
                    }

                }
                catch {
                "Port $leftport is closed on $curr "
                }
          $LeftPort++
          }
    }

        ####################
        #Handles if Port range is X,X,X...
        ####################

        Elseif($port -like '*,*'){
            $countAA = 1
            $i = 0
            $separatorA = ', '
            $option = [System.StringSplitOptions]::RemoveEmptyEntries
            $outputA = $port.split($SeparatorA, $option)
            $NumPortsA = $outputA.count
 
            while($CountAA -le $NumPortsa){
                $TestPort = $outputA[$i]

            try {
                Write-Host("Testing $curr on Port $testport") 
                #$Object = New-Object system.Net.Sockets.TcpClient
                #$Connection = $Object.Connect($curr,$port) 
                $t = New-Object Net.Sockets.TcpClient
                $t.Connect($curr,$testport)
                    if($t.Connected)
                    {
                        "Port $testPort is open on $curr"
                    }
                    else
                    {
                        "Port $testPort is closed on $curr "
                    }

                }
                catch {
                "Port $testport is closed on $curr "
                }
                $i++
                $countAA++
            }
                
    }

    ########################
    #Handles one IP and One Port
    ########################

        else{
            try {
                Write-Host("Testing $curr on Port $port") 
                #$Object = New-Object system.Net.Sockets.TcpClient
                #$Connection = $Object.Connect($curr,$port) 
                $t = New-Object Net.Sockets.TcpClient
                $t.Connect($curr,$port)
                    if($t.Connected)
                    {
                        "Port $Port is open on $curr"
                    }
                    else
                    {
                        "Port $Port is closed on $curr "
                    }

                }
                catch {
                "Port $port is closed on $curr "
                }
        }
    }
    $pointer+=2
}