# --- CONFIGURATION ---
$ShaderComponents = @{
    "Anime4K-Ultra.glsl" = @(
        "src/FSR-Ani.glsl",
        "src/Anime4K_Thin_AA.glsl"
    )
    "Anime4K-Ultra_Deblur.glsl" = @(
        "src/Save-Native.glsl",
        "src/FSR-Ani.glsl",
        "src/Anime4K_Thin_AA_Deblur.glsl"
    )
    "Anime4K-Ultra_Soft_Deblur.glsl" = @(
        "src/Save-Native.glsl",
        "src/FSR-Ani.glsl",
        "src/Anime4K_Thin_AA_Soft_Deblur.glsl"
    )
    "Anime4K-Ultra_DoG_Deblur.glsl" = @(
        "src/Save-Native.glsl",
        "src/Anime4K_Upscale_Deblur_DoG_x2.glsl",
        "src/Anime4K_Thin_AA_Smooth_Deblur.glsl"
    )
    "Anime4K-Ultra_L_Deblur.glsl" = @(
        "src/Save-Native.glsl",
        "src/Anime4K_Upscale_CNN_x2_L.glsl",
        "src/Anime4K_Thin_AA_Smooth_Deblur.glsl"
    )
}

# --- THE CONSOLIDATED HEADER ---
$FullHeader = @"
// =============================================================================
// Shader: Anime4K-Ultra
// Compiled by: Th-Underscore (2026)
//
// FEATURES:
// - Combines FSR v1.0.2 and Custom Anime4K_Thin w/ De-Aliasing + Deblur
// - Designed specifically to preserve film grain and fine textures
// - Significantly lighter performance than Anime4K (Fast)
//
// CREDITS:
//  - bloc97, for creating Anime4K
//  - agilyd, for porting FSR to GLSL
// =============================================================================
// THIRD-PARTY LICENSES:
//
// 1. Anime4K (MIT) - Copyright (c) 2019-2021 bloc97
// 2. FidelityFX FSR (MIT) - Copyright (c) 2021 Advanced Micro Devices, Inc.
// 3. Anime4K-Ultra (MIT) - Copyright (c) 2026 Th-Underscore
// =============================================================================
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// =============================================================================
"@

# --- BUILD LOGIC ---
$ShaderComponents.GetEnumerator() | ForEach-Object {
    $OutputFile = $_.Key
    $Components = $_.Value
    Write-Host "Building shader: $OutputFile..." -ForegroundColor Cyan

    $FullHeader | Out-File -LiteralPath $OutputFile -Encoding utf8

    foreach ($FileName in $Components) {
        if (Test-Path -Literalpath $FileName) {
            $file = Get-Item -LiteralPath $FileName
            Write-Host "Processing $FileName..." -ForegroundColor Yellow
            
            # Add a visual separator for the code
            "`n`n// " + ("=" * 77) | Out-File -LiteralPath $OutputFile -Append
            "// COMPONENT: $($file.Name)" | Out-File -LiteralPath $OutputFile -Append
            "// " + ("=" * 77) + "`n" | Out-File -LiteralPath $OutputFile -Append

            $Lines = Get-Content -LiteralPath $file
            $FoundCode = $false

            foreach ($Line in $Lines) {
                # Skip all leading comments/empty lines until:
                # - An mpv directive (starts with !)
                # - A preprocessor directive (starts with #)
                # - A code keyword (float, vec, void, in, out)
                if ($Line -match "^\s*(//!|#|float|vec|void|uvec|in\s|out\s|shared)") {
                    $FoundCode = $true
                }

                if ($FoundCode) {
                    $Line | Out-File -LiteralPath $OutputFile -Append
                }
            }
        } else {
            Write-Warning "File not found: $FileName"
        }
    }

    Write-Host "Success! Final shader saved to $OutputFile" -ForegroundColor Green
}