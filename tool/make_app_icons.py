"""Draws STAKA's Android launcher icons and splash logo.

The mark is the hang-tag glyph from the website's wordmark
(`web/components/wordmark.tsx`, viewBox 16 x 22): cream on the header's
forest green. Run from `mobile/` after changing it:

    python tool/make_app_icons.py

Needs Pillow (`pip install pillow`). Writes into android/app/src/main/res
and docs/branding/. iOS icons are not generated yet (no Mac to build on).
"""

from pathlib import Path

from PIL import Image, ImageDraw

FOREST_800 = (0x24, 0x42, 0x2A, 255)  # website header / app forest800
CREAM = (0xF2, 0xE8, 0xCF, 255)  # app cream
WHITE = (255, 255, 255, 255)

RES = Path("android/app/src/main/res")
DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
SUPERSAMPLE = 8


def tag_mask(height_px: int) -> Image.Image:
    """The tag glyph (hole cut out) as an L mask, `height_px` tall."""
    scale = height_px * SUPERSAMPLE / 22
    w, h = round(16 * scale), round(22 * scale)
    mask = Image.new("L", (w, h), 0)
    d = ImageDraw.Draw(mask)
    s = lambda v: v * scale  # noqa: E731
    # Body with rounded bottom corners, then the clipped top over it.
    d.rounded_rectangle((0, s(3), w - 1, h - 1), radius=s(2), fill=255)
    d.polygon(
        [(s(3), 0), (s(13), 0), (s(16), s(3)), (s(16), s(6)), (0, s(6)), (0, s(3))],
        fill=255,
    )
    r = s(1.8)
    d.ellipse((s(8) - r, s(6) - r, s(8) + r, s(6) + r), fill=0)
    return mask.resize((round(w / SUPERSAMPLE), round(h / SUPERSAMPLE)), Image.LANCZOS)


def paste_centered(canvas: Image.Image, mask: Image.Image, colour) -> None:
    layer = Image.new("RGBA", mask.size, colour)
    x = (canvas.width - mask.width) // 2
    y = (canvas.height - mask.height) // 2
    canvas.paste(layer, (x, y), mask)


def shaped_background(size: int, round_icon: bool) -> Image.Image:
    big = size * SUPERSAMPLE
    mask = Image.new("L", (big, big), 0)
    d = ImageDraw.Draw(mask)
    if round_icon:
        d.ellipse((0, 0, big - 1, big - 1), fill=255)
    else:
        d.rounded_rectangle((0, 0, big - 1, big - 1), radius=big * 0.22, fill=255)
    mask = mask.resize((size, size), Image.LANCZOS)
    icon = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    icon.paste(Image.new("RGBA", (size, size), FOREST_800), (0, 0), mask)
    return icon


def legacy_icon(size: int, round_icon: bool) -> Image.Image:
    """Pre-Android 8 launchers: the whole icon in one picture."""
    icon = shaped_background(size, round_icon)
    paste_centered(icon, tag_mask(round(size * 0.54)), CREAM)
    return icon


def adaptive_layer(size: int, colour) -> Image.Image:
    """Android 8+ foreground (108 dp canvas; launchers show the middle 72)."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    paste_centered(layer, tag_mask(round(size * 50 / 108)), colour)
    return layer


def write(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, optimize=True)


def main() -> None:
    for name, factor in DENSITIES.items():
        folder = RES / f"mipmap-{name}"
        write(legacy_icon(round(48 * factor), False), folder / "ic_launcher.png")
        write(legacy_icon(round(48 * factor), True), folder / "ic_launcher_round.png")
        layer = round(108 * factor)
        write(adaptive_layer(layer, CREAM), folder / "ic_launcher_foreground.png")
        write(adaptive_layer(layer, WHITE), folder / "ic_launcher_monochrome.png")
        # Splash logo for Android 11 and older (Android 12+ uses the
        # foreground layer through the system splash screen).
        splash = Image.new("RGBA", (round(96 * factor),) * 2, (0, 0, 0, 0))
        paste_centered(splash, tag_mask(round(72 * factor)), CREAM)
        write(splash, RES / f"drawable-{name}" / "splash_logo.png")

    write(legacy_icon(1024, False), Path("docs/branding/staka-icon-1024.png"))
    print("Icons written.")


if __name__ == "__main__":
    main()
