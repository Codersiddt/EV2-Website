$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8765/")
$listener.Start()
Write-Host "Serving at http://localhost:8765/"
$root = "C:\Users\siddh\OneDrive\Ev^2 Web"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = $ctx.Request.Url.LocalPath
    if ($path -eq "/" -or $path -eq "/index.html") {
        $file = "$root\index.html"
    } else {
        $file = $root + $path
    }
    if (Test-Path $file) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ext = [System.IO.Path]::GetExtension($file)
        $ctx.Response.ContentType = if ($ext -eq ".jpg" -or $ext -eq ".jpeg") { "image/jpeg" } elseif ($ext -eq ".png") { "image/png" } elseif ($ext -eq ".glb") { "model/gltf-binary" } else { "text/html; charset=utf-8" }
        $ctx.Response.ContentLength64 = $bytes.Length
        $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $ctx.Response.StatusCode = 404
    }
    $ctx.Response.Close()
}
