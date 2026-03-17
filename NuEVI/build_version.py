import subprocess
import random


def get_build_version():
    try:
        commit = subprocess.check_output(
            ["git", "rev-parse", "--short", "HEAD"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except Exception:
        commit = "unknown"

    try:
        dirty = subprocess.call(
            ["git", "diff", "--quiet"], stderr=subprocess.DEVNULL
        ) != 0 or subprocess.call(
            ["git", "diff", "--cached", "--quiet"], stderr=subprocess.DEVNULL
        ) != 0
    except Exception:
        dirty = False

    if dirty:
        suffix = format(random.randint(0, 0xFF), '02x')
        return f"{commit}-{suffix}"
    return commit


version = get_build_version()

if __name__ == "__main__":
    print(version)
else:
    Import("env")
    env.Append(CPPDEFINES=[("BUILD_VERSION", f'\\"{version}\\"')])
