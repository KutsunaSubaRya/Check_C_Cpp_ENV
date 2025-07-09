# PowerShell script version of check_env.bat with color output (source in subfolder)

$SRC_DIR = "check_env_source_code"

Write-Host ""
Write-Host "[INFO] Checking gcc and g++ version..." -ForegroundColor Cyan
Write-Host "----------------------------------------"
gcc --version
g++ --version
Write-Host "----------------------------------------"

# Compile version checkers
Write-Host ""
Write-Host "[STEP] Compiling c_version.c (C standard version)..." -ForegroundColor Yellow
gcc "$SRC_DIR\c_version.c" -o "$SRC_DIR\c_version.exe"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to compile c_version.c" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP] Compiling cpp_version.cpp (C++ standard version)..." -ForegroundColor Yellow
g++ "$SRC_DIR\cpp_version.cpp" -o "$SRC_DIR\cpp_version.exe"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to compile cpp_version.cpp" -ForegroundColor Red
    exit 1
}

# Run and capture version info
$C_STD = & "$SRC_DIR\c_version.exe"
$CPP_STD = & "$SRC_DIR\cpp_version.exe"

Write-Host "[INFO] Detected C standard: $C_STD" -ForegroundColor Cyan
Write-Host "[INFO] Detected C++ standard: $CPP_STD" -ForegroundColor Cyan

# Compile main test programs
Write-Host ""
Write-Host "[STEP] Compiling C test (gnu99 + static + -lm)..." -ForegroundColor Yellow
gcc -g -O2 -std=gnu99 -static -lm "$SRC_DIR\c_env_test_gnu99_static.c" -o "$SRC_DIR\c_test.exe"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to compile C test" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP] Compiling C++ test (gnu++11 + static + -lm)..." -ForegroundColor Yellow
g++ -g -O2 -std=gnu++11 -static -lm "$SRC_DIR\cpp_env_test_gnupp11_static.cpp" -o "$SRC_DIR\cpp_test.exe"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to compile C++ test" -ForegroundColor Red
    exit 1
}

# Run tests
Write-Host ""
Write-Host "[RUN] Running C test:" -ForegroundColor Gray
$c_out = & "$SRC_DIR\c_test.exe"
Write-Host $c_out

Write-Host "[RUN] Running C++ test:" -ForegroundColor Gray
$cpp_out = & "$SRC_DIR\cpp_test.exe"
Write-Host $cpp_out

# Validate version compatibility
Write-Host ""
Write-Host "[VERIFY] Verifying backward compatibility (gnu99 / gnu++11)..." -ForegroundColor Cyan

if ($c_out -eq "1.41" -and $cpp_out -eq "1.41") {
    Write-Host "[PASS] Compiler successfully ran legacy-standard programs - backward compatibility verified." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Legacy standard program failed to run as expected." -ForegroundColor Red
}

# Cleanup generated files
Write-Host ""
Write-Host "[CLEANUP] Deleting generated executables..." -ForegroundColor Cyan
Remove-Item -Force `
    "$SRC_DIR\c_version.exe", `
    "$SRC_DIR\cpp_version.exe", `
    "$SRC_DIR\c_test.exe", `
    "$SRC_DIR\cpp_test.exe" `
    -ErrorAction SilentlyContinue

Write-Host "[DONE] All executable files deleted." -ForegroundColor Green
Write-Host ""
pause
