﻿###############################################
# 期限の切れた証明書を削除する
###############################################
function RemoveExpiredCertificate{
	[string]$ThumbprintString = $Args[0]
	[switch]$CheckOnly = $Args[1]
	$ThumbprintOrg = $ThumbprintString
	$Thumbprint = $ThumbprintOrg -replace " ",""
	$Certs = dir Cert:\LocalMachine\my
	[array]$Tergets = $Certs |? Thumbprint -eq $Thumbprint
	$Tergets | Select PSParentPath, Issuer, NotAfter
	if( -not $CheckOnly ){
		foreach( $Terget in $Tergets ){
			if( $Terget.NotAfter -lt (Get-Date) ){
				$CertPath = Join-path $Terget.PSParentPath $Terget.PSChildName
				echo "Expired certificate : $CertPath"
				Remove-Item $CertPath
			}
		}
	}
}


function RemoveCert([String]$ThumbprintString, [String]$ComputerName){
	if($ComputerName -eq [String]$null){
		RemoveExpiredCertificate $ThumbprintString $false
	}
	else{
		Invoke-Command -ScriptBlock $function:RemoveExpiredCertificate -ComputerName $ComputerName -ArgumentList $ThumbprintString, $false
	}
}


function CheckCert([String]$ThumbprintString, [String]$ComputerName ){
	if($ComputerName -eq [String]$null){
		RemoveExpiredCertificate $ThumbprintString $true
	}
	else{
		Invoke-Command -ScriptBlock $function:RemoveExpiredCertificate -ComputerName $ComputerName -ArgumentList $ThumbprintString, $true
	}
}
