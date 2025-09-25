#! /usr/bin/env python3

import sys
import subprocess

from dataclasses import dataclass

def pixelate(img_path, *, width, height):
    proc = subprocess.Popen(["convert", "-scale", f"{width}x{height}!", f"{img_path}", "PPM:-"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (out, err) = proc.communicate(timeout=1)
    if err != b"":
        print(f"Error: {err}")
        sys.exit(1)
    return out

# \x1b[48;2;<r>;<g>;<b>m
# \x1b[37m (white fg)
# \x1b[30m (black fg)

def as_integer(val, what):
    try:
        return int(val)
    except:
        print(f"'{val}' cannot be interpreted as an integer {what}")
        sys.exit(1)

@dataclass
class Args:
    width: int
    height: int
    path: str
    threshold: int
    commit: bool
    allow_enclaves: bool
    post_transform: list[str]

def parse_args():
    width = None
    height = None
    threshold = None
    image_path = None
    commit = None
    allow_enclaves = None
    post_transform = []
    args = sys.argv[1:][::-1]
    while len(args) > 0:
        arg = args.pop()
        if arg == '--commit':
            commit = True
        elif arg == '--no-enclaves':
            allow_enclaves = False
        elif arg.startswith('--flush:'):
            for action in arg.removeprefix("--flush:").split(","):
                match action:
                    case "left": post_transform.push("flush:left")
                    case "right": post_transform.push("flush:right")
                    case "top": post_transform.push("flush:top")
                    case "bottom": post_transform.push("flush:bottom")
                    case _:
                        print(f"'{action}' is not a valid flush action")
                        sys.exit(1)
        elif '%' in arg:
            if threshold is not None:
                print("Threshold must be defined at most once.")
                print(f"Received '{threshold}%' and '{arg}'")
                sys.exit(1)
            threshold = as_integer(arg[:-1], "percentage")
            if threshold < 0 or threshold > 100:
                print(f"'{threshold}%' should be between 0% and 100%")
                sys.exit(1)
        elif '.' in arg:
            for ext in ("png", "ppm", "svg", "pdf"):
                if arg.endswith(f".{ext}"):
                    break
            else:
                print(f"Warning: the extension of '{arg}' is not guaranteed to be supported.")
            if image_path is not None:
                print("Image must be defined at most once.")
                print(f"Received '{image_path}' and '{arg}'")
                sys.exit(1)
            image_path = arg
        elif 'x' in arg:
            tup = arg.split('x')
            if len(tup) != 2:
                print(f"'{arg}' is interpreted to be the dimensions and must be in the format `WxH`.")
                sys.exit(1)
            (w,h) = tup
            width = as_integer(w, "width")
            height = as_integer(h, "height")
        else:
            print(f"Cannot infer the meaning of '{arg}'")
            sys.exit(1)

    if threshold is None: threshold = 50
    if width is None: width = 10
    if height is None: height = 10
    if commit is None: commit = False
    if allow_enclaves is None: allow_enclaves = True
    if image_path is None:
        print("Must specify an input image")
        sys.exit(1)
    return Args(path=image_path, width=width, height=height, threshold=threshold, commit=commit, post_transform=post_transform, allow_enclaves=allow_enclaves)

def ansi_bg_true(r, g, b):
    return lambda tt: f"\x1b[48;2;{r};{g};{b}m{tt}\x1b[0m"

def ansi_fg_true(r, g, b):
    return lambda tt: f"\x1b[38;2;{r};{g};{b}m{tt}\x1b[0m"

def small_color_delta(v, d):
    if v >= 128:
        return v - d
    else:
        return v + d

@dataclass
class BW:
    is_white: bool

    def display(self, parity=True):
        chan = 255 if self.is_white else 0
        delta = 30 if parity else 60
        bg = ansi_bg_true(chan, chan, chan)
        val = small_color_delta(chan, delta)
        fg = ansi_fg_true(val, val, val) 
        return bg(fg("   "))

    def write_ascii(self):
        if self.is_white:
            return ' '
        else:
            return '#'


@dataclass
class Gray:
    level: int

    def display(self, parity=True):
        percent = round((self.level / 255) * 100)
        delta = 30 if parity else 60
        bg = ansi_bg_true(self.level, self.level, self.level)
        val = small_color_delta(self.level, delta)
        fg = ansi_fg_true(val, val, val) 
        return bg(fg(f"{percent:>3}"))

    def threshold(self, percent):
        this = round((self.level / 255) * 100)
        return BW(this >= percent)

@dataclass
class RGB:
    r: int
    g: int
    b: int

    @staticmethod
    def from_bytes(bb):
        (r, g, b) = bb
        return RGB(r, g, b)

    def display(self, parity=True):
        rx = hex(self.r // 16)[2:]
        gx = hex(self.g // 16)[2:]
        bx = hex(self.b // 16)[2:]
        bg = ansi_bg_true(self.r, self.g, self.b)
        delta = 30 if parity else 60
        fg = ansi_fg_true(
            small_color_delta(self.r, delta),
            small_color_delta(self.g, delta),
            small_color_delta(self.b, delta),
        )
        return bg(fg(f"{rx}{gx}{bx}"))

    def average(self):
        return Gray(round((self.r + self.g + self.b) / 3))


@dataclass
class Pixel:
    data: RGB | Gray

    @staticmethod
    def from_bytes(bb):
        return Pixel(RGB.from_bytes(bb))

    def display(self, parity=True):
        return self.data.display(parity=parity)

    def average(self):
        return Pixel(self.data.average())

    def threshold(self, percent):
        return Pixel(self.data.threshold(percent))

    def write_ascii(self):
        return self.data.write_ascii()

@dataclass
class Image:
    pixels: list[list[Pixel]]

    @staticmethod
    def from_bytes_rgb255(bb, *, width, height):
        return Image([[Pixel.from_bytes(bb[p:p+3]) for j in range(width) for p in [(i * width + j) * 3]] for i in range(height)])

    def display(self):
        accum = ""
        for (i, line) in enumerate(self.pixels):
            for (j, pixel) in enumerate(line):
                accum += pixel.display(parity=(i+j)%2==0)
            accum += "\n"
        return accum

    def average(self):
        return Image([[px.average() for px in line] for line in self.pixels])

    def threshold(self, percent):
        return Image([[px.threshold(percent) for px in line] for line in self.pixels])

    def write_ascii(self, target):
        txt = "\n".join(["".join([px.write_ascii() for px in line]) for line in self.pixels])
        with open(target, 'w') as f:
            f.write(txt)

def main():
    args = parse_args()
    (bhead, bdims, bscale, body) = pixelate(args.path, width=args.width, height=args.height).split(b"\n")
    assert bhead == b'P6'
    assert bdims == bytes(f"{args.width} {args.height}", "utf8")
    assert bscale == b'255'
    assert len(body) == args.width * args.height * 3

    img = Image.from_bytes_rgb255(body, width=args.width, height=args.height)
    print(img.display())
    img = img.average()
    print(img.display())
    img = img.threshold(args.threshold)
    print(img.display())

    if args.commit:
        dest = args.path + ".contour"
        print(f"Writing result to {dest}")
        img.write_ascii(args.path + ".contour")

if __name__ == "__main__":
    main()
