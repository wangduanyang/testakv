$kv=Get-AzureRMKeyVault|Where-Object {$_.ResourceGroupName -eq "ContosoKeyVaultHSM"}
$certificateName = "TestCertificate"

$certPolicy = New-AzureKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" `
                                                                -SubjectName "CN=contoso.com" `
                                                                -IssuerName "Self" `
                                                                -ValidityInMonths 12 `
                                                                -RenewAtNumberOfDaysBeforeExpiry 30 `
                                                                -ReuseKeyOnRenewal
Add-AzureKeyVaultCertificate -VaultName $kv.VaultName -Name $certificateName -CertificatePolicy $certPolicy

$certificate = Get-AzureKeyVaultCertificate -VaultName $kv.VaultName -Name $certificateName
while($certificate.Certificate -eq $null)
{
     Write-Host "Waiting for Certificate generation.."
     Start-Sleep -m 10000
    $certificate = Get-AzureKeyVaultCertificate -VaultName $kv.VaultName -Name $certificateName
}    

Remove-AzureKeyVaultCertificate -VaultName $kv.VaultName -Name $certificateName -Force
