#Este script sube los archivos de una carpeta particular a un sub-bucket en S3 y elimina los archivos del origen.
#Si falla envía un mail indicando el error.

# Definir las variables
$fecha = Get-Date -Format "yyyyMMdd"
$parentBucketName = "backups-databases"
$childBucketName = "backup"+$fecha
$childBucketPrefix = "$childBucketName/"
$s3Path = "s3://$parentBucketName/$childBucketPrefix"
$backupFolder = "F:\backup"

# Parámetros del correo electrónico
$SMTPServer = "smtp.gmail.com"
$From = "mail@mail.com"
$To = "maildonderecibo@mail.com"
$Subject = "Failed to upload backup files to Amazon S3"
$Body = "It's suggested to access the server and verify why this problem occurred."
$SMTPUsername = "mail@mail.com"
$SMTPPassword = "######################"
$SMTPPort = 587

try {

# Crear el bucket
    Write-Output "Creando el bucket $bucketName"
    New-S3Bucket -BucketName "$parentBucketName/$childBucketPrefix" -Region us-east-1 

#Sincronizar los archivos de backups
    Write-Output "Sincronizando archivos de backups hacia el bucket"
    aws s3 sync $backupFolder $s3Path


# Eliminar los archivos de backups de la carpeta origen
    Write-Output "Eliminando archivos de backups de la carpeta origen"
    Remove-Item $backupFolder\* -Recurse -Force
    
    }

catch {

# Envía correo electrónico si ocurre un error
    Send-MailMessage -SMTPServer $SMTPServer -From $From -To $To -Subject $Subject -Body $Body -Port $SMTPPort -UseSsl -Credential (New-Object System.Management.Automation.PSCredential($SMTPUsername, (ConvertTo-SecureString $SMTPPassword -AsPlainText -Force)))
    Write-Host "Ha ocurrido un error al intentar crear el bucket en S3."
    
    }
