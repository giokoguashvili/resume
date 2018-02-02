$file = "README"
$fileName = "$file.md"
$uri = "http://www.markdowntopdf.com/app/upload"
$outputFileName = "Giorgi Koguashvili CV.pdf"
$currentPath = Convert-Path .
$filePath="$currentPath\$fileName"

$fileBin = [System.IO.File]::ReadAlltext($filePath)
$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"
$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"",
    "Content-Type: application/octet-stream$LF",
    $fileBin,
    "--$boundary--$LF"
) -join $LF

$response = Invoke-RestMethod -Uri $uri -Method Post -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines
echo $response

Start-Sleep -s 1

$url = "http://www.markdowntopdf.com/app/download/$($response.foldername)/$file"
echo $url
Invoke-WebRequest -Uri $url -OutFile $outputFileName
