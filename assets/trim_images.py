#!/usr/bin/env python3
import argparse
import os
import sys
import time

try:
    from PIL import Image
except ImportError as exc:
    print("Pillow is required. Install with: pip install Pillow", file=sys.stderr)
    raise SystemExit(1) from exc


SUPPORTED_EXTENSIONS = {"png", "jpeg"}


def is_supported_image(path):
    ext = os.path.splitext(path)[1].lower().lstrip(".")
    return ext in SUPPORTED_EXTENSIONS


def iter_image_files(path):
    if os.path.isfile(path):
        if is_supported_image(path):
            yield path
        return

    if os.path.isdir(path):
        for root, _dirs, files in os.walk(path):
            for name in files:
                full_path = os.path.join(root, name)
                if is_supported_image(full_path):
                    yield full_path
        return

    raise ValueError(f"Not a file or directory: {path}")


def trim_image(path, padding):
    with Image.open(path) as img:
        if "A" not in img.getbands():
            return False

        alpha = img.getchannel("A")
        bbox = alpha.getbbox()
        if bbox is None:
            return False

        left, top, right_excl, bottom_excl = bbox
        right = right_excl - 1
        bottom = bottom_excl - 1
        width, height = img.size

        right_margin = (width - 1) - right
        bottom_margin = (height - 1) - bottom
        trim_x = max(0, min(left, right_margin) - padding)
        trim_y = max(0, min(top, bottom_margin) - padding)

        if trim_x == 0 and trim_y == 0:
            return False

        new_left = trim_x
        new_right = (width - 1) - trim_x
        new_top = trim_y
        new_bottom = (height - 1) - trim_y
        crop_box = (new_left, new_top, new_right + 1, new_bottom + 1)

        cropped = img.crop(crop_box)
        cropped.save(path, format="PNG")
        print(f"Trim image:(w:{trim_x} h:{trim_y} {os.path.abspath(path)})")
        return True


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Trim transparent borders while keeping the image center aligned."
    )
    parser.add_argument("path", help="File or directory to process")
    parser.add_argument(
        "padding",
        nargs="?",
        default=0,
        type=int,
        help="Padding to keep around content (pixels)",
    )
    return parser.parse_args(argv)


def main(argv):
    args = parse_args(argv)
    start = time.time()
    for path in iter_image_files(args.path):
        trim_image(path, args.padding)
    elapsed_ms = int((time.time() - start) * 1000)
    print(f"TIME:{elapsed_ms}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
