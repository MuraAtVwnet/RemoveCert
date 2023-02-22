■ これは何?
リモートコンピューター証明書を拇印で指定し、期限が切れていたら削除します これは何?


■ 使い方
PowerShell プロンプトで以下コマンド入力すると、証明書の期限を確認し、期限が切れていたら削除をします

RemoveCert 証明書の拇印 リモートコンピューター名

削除はせずに、証明書の確認だけをする場合は、CheckCert を使います

CheckCert 証明書の拇印 リモートコンピューター名


証明書の拇印だけを渡すと、localhost を対象にします


■ インストールの仕方
PowerShell プロンプトで install.ps1 を実行してください


■ Uninstall 方法
uninstall.ps1 を実行して下さい
(問い合わせが来たら Enter)

■ 動作確認環境
Windows PowerShell 5.1 On Windows
PowerShell Core 7.3.2 On Windows

■ リポジトリ
https://github.com/MuraAtVwnet/RemoveCert
git@github.com:MuraAtVwnet/RemoveCert.git


■ Web Site
PowerShell で有効期限が迫った証明書を探す
http://www.vwnet.jp/Windows/WS19/2021030401/AutoEnrollment64.htm

