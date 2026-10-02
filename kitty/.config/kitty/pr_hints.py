# Custom kitty hints kitten: find GitHub PR/issue refs like `#25639`,
# `tbean-org/bean#25639` or `bean#25639` on screen and open them in the browser.
#
# Mapped in kitty.conf:
#   map kitty_mod+p>p kitten hints --customize-processing pr_hints.py
#
# A bare `#NNNN` defaults to DEFAULT_REPO. `/pull/N` on GitHub redirects to
# `/issues/N` when N is an issue, so one URL shape covers both.
import re

DEFAULT_REPO = "tbean-org/bean"
DEFAULT_OWNER = DEFAULT_REPO.split("/")[0]

# owner/repo#N | repo#N | #N   (2-7 digits, word-bounded so `#ff00aa` / `#4.` are skipped)
PATTERN = re.compile(r"(?<![\w/])(?:(?P<owner>[\w.-]+)/)?(?P<repo>[\w.-]+)?#(?P<num>\d{2,7})\b")


def mark(text, args, Mark, extra_cli_args, *a):
    for idx, m in enumerate(PATTERN.finditer(text)):
        start, end = m.span()
        mark_text = text[start:end].replace("\n", "").replace("\0", "")
        yield Mark(idx, start, end, mark_text, m.groupdict())


def _url(g):
    owner = g.get("owner") or DEFAULT_OWNER
    repo = g.get("repo") or DEFAULT_REPO.split("/")[1]
    return f"https://github.com/{owner}/{repo}/pull/{g['num']}"


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    for match, g in zip(data["match"], data["groupdicts"]):
        if match:
            boss.open_url(_url(g))
