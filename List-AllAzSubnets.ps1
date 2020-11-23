<#
 .Synopsis
  List All Subnets in a Subscription along with SubnetPrefix,SubnetNSG,VNET,Location,UDR,ResourceGroup,Subscription,DDoS.
 
 .Description
  List All Subnets in a Subscription along with SubnetPrefix,SubnetNSG,VNET,Location,UDR,ResourceGroup,Subscription,DDoS.
 
 .Parameter Port
  None.
 
 .Example
   #List All NSGs along with the Security Rules for a Subscription.
   List-AllAzSubnets
#>

#------------------------------------------------------------------------------   
#   
#    
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT   
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT   
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS   
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR    
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.   
#   
#------------------------------------------------------------------------------  



$vnet1 = $null 
$vnet1 = Get-AzVirtualNetwork

$outtest = @()
$c = $vnet1.Subnets.id.Count
$subnet1 = @()
$rg1 = @()
$vnetname = @()
$subid = @()
$subpre = @()
$SubnetNSG = @()
$loc = @()
$DDoS = @()
$UDR = @()

if($c -eq 1){$vnet1}
Else{

For($i=0; $i -lt $c; $i++){
$subnet1 += $vnet1.Subnets.id[$i].Split("/")[10]
$rg1 += $vnet1.Subnets.id[$i].Split("/")[4]
$vnetname +=  $vnet1.Subnets.id[$i].Split("/")[8]
$subid += $vnet1.Subnets.id[$i].Split("/")[2]
$subpre += $vnet1.subnets[$i].AddressPrefix

#VNET Specfic Details 
$vnetsubspecific = Get-AzVirtualNetwork -Name $vnetname[$i] -ResourceGroupName $rg1[$i]
$loc += $vnetsubspecific.Location
$DDoS += $vnetsubspecific.DdosProtectionPlan
#

# line for possible null values in Subnet
$SubnetNSG += $vnet1.Subnets[$i].NetworkSecurityGroup.Id | ForEach-Object{$_ -replace ".*/"} #.Split("/")[8]
$UDR += $vnet1.Subnets[$i].RouteTable.id | ForEach-Object{$_ -replace ".*/"}

# Custom object
$outtest += New-Object PSObject -Property @{
Subnet = $subnet1[$i]
Subscription = $subid[$i]
Resourcegroup = $rg1[$i]
Vnet = $vnetname[$i]
Subnetprefix = $subpre[$i]
VNETLocation = $loc[$i]
DDoS = $DDoS[$i]
SubnetNSG = $SubnetNSG[$i]
UDR = $UDR[$i]
}

}

Write-Warning "All attributes are specfic to Subnet only."
$outtest | FT -Property Subnet,SubnetPrefix,SubnetNSG,VNET,Location,UDR,ResourceGroup,Subscription,DDoS
Write-Warning "All attributes are specfic to Subnet only."
}
