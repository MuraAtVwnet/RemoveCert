###############################################
# 期限の切れた証明書を削除する
###############################################
function RemoveExpiredCertificateCore{
	[string]$ThumbprintString = $Args[0]
	[switch]$CheckOnly = $Args[1]
	$ThumbprintOrg = $ThumbprintString
	$Thumbprint = $ThumbprintOrg -replace " ",""
	$Certs = Get-ChildItem Cert:\LocalMachine -Recurse
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
		RemoveExpiredCertificateCore $ThumbprintString $false
	}
	else{
		Invoke-Command -ScriptBlock $function:RemoveExpiredCertificateCore -ComputerName $ComputerName -ArgumentList $ThumbprintString, $false
	}
}


function CheckCert([String]$ThumbprintString, [String]$ComputerName ){
	if($ComputerName -eq [String]$null){
		RemoveExpiredCertificateCore $ThumbprintString $true
	}
	else{
		Invoke-Command -ScriptBlock $function:RemoveExpiredCertificateCore -ComputerName $ComputerName -ArgumentList $ThumbprintString, $true
	}
}


###############################################
# 期限の切れた証明書をリストアップする
###############################################
function ListExpiredCertificateCore{
	$ToDay = Get-Date
	[array]$Certs = Get-ChildItem Cert:\LocalMachine -Recurse
	[array]$Certs = $Certs |? NotAfter -ne $null
	[array]$Tergets = $Certs |? NotAfter -lt $ToDay | Sort-Object NotAfter
	$Tergets | FT NotAfter, Issuer, Thumbprint
}


function ListExpiredCert([String]$ComputerName){
	if($ComputerName -eq [String]$null){
		ListExpiredCertificateCore
	}
	else{
		Invoke-Command -ScriptBlock $function:ListExpiredCertificateCore -ComputerName $ComputerName
	}
}

###############################################
# 期限の切れた証明書を削除する
###############################################
function RemoveAllExpiredCertificateCore{
	$ToDay = Get-Date
	[array]$Certs = Get-ChildItem Cert:\LocalMachine -Recurse
	[array]$Certs = $Certs |? NotAfter -ne $null
	[array]$Tergets = $Certs |? NotAfter -lt $ToDay | Sort-Object NotAfter
	$Tergets | FT NotAfter, Issuer, Thumbprint

	foreach( $Terget in $Tergets ){
		if( $Terget.NotAfter -lt (Get-Date) ){
			$CertPath = Join-path $Terget.PSParentPath $Terget.PSChildName
			Remove-Item $CertPath
		}
	}
}


function RemoveAllExpiredCert([String]$ComputerName){
	if($ComputerName -eq [String]$null){
		RemoveAllExpiredCertificateCore
	}
	else{
		Invoke-Command -ScriptBlock $function:RemoveAllExpiredCertificateCore -ComputerName $ComputerName
	}
}
