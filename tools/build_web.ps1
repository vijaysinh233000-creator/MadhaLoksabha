param(
  [string]$EnvironmentFile = ".env.local"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $EnvironmentFile)) {
  throw "Environment file not found: $EnvironmentFile"
}

$voterFinderEnv = @{}
Get-Content -LiteralPath $EnvironmentFile | ForEach-Object {
  if ($_ -match '^([^#=]+)=(.*)$') {
    $voterFinderEnv[$matches[1].Trim()] = $matches[2].Trim()
  }
}

$voterFinderUrl = $voterFinderEnv['SUPABASE_URL']
$voterFinderPublicKey = $voterFinderEnv['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY']
if (-not $voterFinderPublicKey) {
  $voterFinderPublicKey = $voterFinderEnv['SUPABASE_PUBLISHABLE_KEY']
}

if (-not $voterFinderUrl -or -not $voterFinderPublicKey) {
  throw "SUPABASE_URL and a Supabase publishable key are required"
}

# Deliberately pass only browser-safe values. SUPABASE_SECRET_KEY must never be
# supplied to Flutter because dart-defines are compiled into the web bundle.
flutter build web --release --no-pub `
  "--dart-define=SUPABASE_URL=$voterFinderUrl" `
  "--dart-define=SUPABASE_PUBLISHABLE_KEY=$voterFinderPublicKey"
