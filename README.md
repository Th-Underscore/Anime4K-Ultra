# Anime4K-Ultra

Custom mpv/libplacebo GLSL shaders combining [FidelityFX FSR v1.0.2](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) with a heavily modified [Anime4K](https://github.com/bloc97/Anime4K/blob/master/glsl/Experimental-Effects/Anime4K_Thin_HQ.glsl) line-thinning pipeline.

Designed to preserve film grain and fine texture while producing sharper lines than stock Anime4K — at a fraction of the performance cost.

## Shaders

| File | Description |
|------|-------------|
| `Anime4K-Ultra.glsl` | FSR upscale + line thinning + de-aliasing |
| `Anime4K-Ultra_Deblur.glsl` (Recommended) | Above + post-warp deblur pass + resolution scaling |

The `src/` folder contains the individual components. `Anime4K_Thin_AA[_Deblur].glsl` can be used standalone (without FSR) — it will fall back to source resolution.

## Usage

### mpv

Copy the desired `.glsl` file(s) to your mpv shaders folder and add to `mpv.conf`:
```
glsl-shaders="~~/shaders/Anime4K-Ultra_Deblur.glsl"
```

### ffmpeg / Anime4K-Batch

For batch upscaling to disk, see [Anime4K-Batch](https://github.com/Th-Underscore/Anime4K-Batch).

## Building from source

Requires PowerShell. Run `Build-Shaders.ps1` from the repository root to recompile the combined shaders from `src/`.

## Credits

- [bloc97](https://github.com/bloc97) — Anime4K
- [agilyd](https://github.com/agyild) — FSR GLSL port
- [AMD](https://github.com/GPUOpen-Effects/FidelityFX-FSR) — FidelityFX FSR

## License

MIT — see [LICENSE.txt](LICENSE.txt)
