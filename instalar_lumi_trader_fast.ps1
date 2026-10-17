param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ModelName = "lumi-trader-fast:4b"
$BaseModel = "qwen3:4b-instruct"
$AnalystModel = "qwen3:14b"
$TemplateMarker = "LUMI_FAST_ULTRA_V4"
$BaseMarker = "BASE_MODEL=QWEN3_4B_INSTRUCT"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Modelfile = Join-Path $ScriptDir "Modelfile.lumi-trader-fast"

function Write-Step([string]$Text) { Write-Host "[LUMI] $Text" -ForegroundColor Cyan }
function Write-Ok([string]$Text) { Write-Host "[LUMI] OK: $Text" -ForegroundColor Green }
function Write-Warn([string]$Text) { Write-Host "[LUMI] AVISO: $Text" -ForegroundColor Yellow }

if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "[LUMI] ERRO: comando 'ollama' nao encontrado no PATH." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $Modelfile)) {
    Write-Host "[LUMI] ERRO: Modelfile nao encontrado: $Modelfile" -ForegroundColor Red
    exit 1
}

try {
    $models = (& ollama list 2>$null | Out-String)
} catch {
    Write-Host "[LUMI] ERRO: Ollama nao respondeu. Inicie o Ollama e execute o BAT novamente." -ForegroundColor Red
    exit 1
}

if ($models -notmatch [regex]::Escape($BaseModel)) {
    Write-Step "Base FAST $BaseModel nao encontrada; baixando..."
    & ollama pull $BaseModel
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $models = (& ollama list 2>$null | Out-String)
}

$installed = $models -match [regex]::Escape($ModelName)
$needsRebuild = [bool]$Force -or (-not $installed)
$currentModelfile = ""

if ($installed -and -not $needsRebuild) {
    try {
        $currentModelfile = (& ollama show --modelfile $ModelName 2>$null | Out-String)
    } catch {
        $needsRebuild = $true
    }

    if ($currentModelfile -notmatch [regex]::Escape($TemplateMarker) -or $currentModelfile -notmatch [regex]::Escape($BaseMarker)) {
        Write-Warn "Lumi anterior detectada; aplicando protocolo ULTRA-FAST automaticamente."
        $needsRebuild = $true
    }
}

if ($needsRebuild) {
    Write-Step "Criando $ModelName com base $BaseModel (ULTRA-FAST / JSON compacto)..."
    & ollama create $ModelName -f $Modelfile
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LUMI] ERRO: falha ao criar $ModelName." -ForegroundColor Red
        exit $LASTEXITCODE
    }
} else {
    Write-Ok "$ModelName ja usa qwen3:4b-instruct + $TemplateMarker; nenhuma recriacao necessaria."
}

try {
    $validated = (& ollama show --modelfile $ModelName 2>$null | Out-String)
} catch {
    Write-Host "[LUMI] ERRO: nao foi possivel validar $ModelName apos a instalacao." -ForegroundColor Red
    exit 2
}

if ($validated -notmatch [regex]::Escape($TemplateMarker) -or $validated -notmatch [regex]::Escape($BaseMarker)) {
    Write-Host "[LUMI] ERRO: a Lumi FAST INSTRUCT nao passou na validacao do marcador." -ForegroundColor Red
    exit 3
}

if ($needsRebuild) {
    Write-Step "Executando teste rapido de JSON da nova Lumi..."
    $smokePrompt = 'Retorne somente: {"a":"h","c":80,"r":"l","x":"wk"}'
    try {
        $smokeText = (& ollama run $ModelName $smokePrompt 2>$null | Out-String).Trim()
        $smokeJson = $smokeText | ConvertFrom-Json
        if ([string]$smokeJson.a -notin @('c','p','h')) { throw "action compacta invalida" }
        if ($null -eq $smokeJson.c) { throw "confidence ausente" }
        if ([string]$smokeJson.r -notin @('l','m','h')) { throw "risk compacto invalido" }
        Write-Ok "teste ULTRA JSON aprovado: $($smokeJson.a) / $($smokeJson.c)% / risco $($smokeJson.r)."
    } catch {
        Write-Host "[LUMI] ERRO: modelo criado, mas o teste JSON falhou: $($_.Exception.Message)" -ForegroundColor Red
        exit 4
    }
}

Write-Ok "$ModelName validado: qwen3:4b-instruct + protocolo ULTRA-FAST sem thinking."
if ($models -match [regex]::Escape($AnalystModel)) {
    Write-Ok "$AnalystModel disponivel para analise profunda."
} else {
    Write-Warn "$AnalystModel nao instalado; isso nao impede o trader FAST de operar."
}
exit 0
