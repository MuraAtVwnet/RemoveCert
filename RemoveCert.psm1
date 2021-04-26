###############################################
# 期限の切れた証明書を削除する
###############################################
function RemoveExpiredCertificate([string]$ThumbprintString, [switch]$CheckOnly){
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


function RemoveCert([String]$ComputerName, [String]$ThumbprintString){
	Invoke-Command -ScriptBlock $function:RemoveExpiredCertificate -ComputerName $ComputerName -ArgumentList $ThumbprintString
}


function CheckCert([String]$ComputerName, [String]$ThumbprintString){
	Invoke-Command -ScriptBlock $function:RemoveExpiredCertificate -ComputerName $ComputerName -ArgumentList $ThumbprintString, "-CheckOnly"
}
