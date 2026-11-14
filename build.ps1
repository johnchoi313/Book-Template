param(
    [ValidateSet('all', 'epub', 'pdf')]
    [string]$Format = 'all'
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$out = Join-Path $root 'output'

function Fail([string]$message) {
    [Console]::Error.WriteLine($message)
    exit 1
}

New-Item -ItemType Directory -Force -Path $out | Out-Null

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Fail "Pandoc is not on PATH. Install it from https://pandoc.org/installing.html"
}

$files = @(
    Get-ChildItem -Path (Join-Path $root 'manuscript') -Filter *.md -Recurse |
        Sort-Object FullName |
        ForEach-Object { $_.FullName }
)

if ($files.Count -eq 0) {
    Fail "No markdown files in manuscript/"
}

function Build-One([string]$fmt) {
    if ($fmt -eq 'pdf' -and -not (Get-Command xelatex -ErrorAction SilentlyContinue)) {
        Fail "PDF builds need XeLaTeX, from TeX Live or MiKTeX. EPUB only: .\build.cmd epub"
    }

    $target = Join-Path $out "book.$fmt"
    $pandocArgs = $files + @(
        '--metadata-file', (Join-Path $root 'metadata.yaml')
        '--from', 'markdown'
        '--top-level-division=chapter'
        '--toc'
        '--toc-depth=1'
        '--output', $target
    )

    if ($fmt -eq 'epub') {
        $pandocArgs += '--epub-chapter-level=1'
    }

    if ($fmt -eq 'pdf') {
        $pandocArgs += @(
            '--pdf-engine=xelatex'
            '-V', 'documentclass=book'
            '-V', 'classoption=11pt'
            '-V', 'classoption=openany'
            '-V', 'geometry:paperwidth=6in'
            '-V', 'geometry:paperheight=9in'
            '-V', 'geometry:margin=0.75in'
        )
    }

    & pandoc @pandocArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "Wrote output/book.$fmt"
}

$formats = @('epub', 'pdf')
if ($Format -ne 'all') { $formats = @($Format) }
foreach ($fmt in $formats) { Build-One $fmt }
