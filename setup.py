import pathlib

from setuptools import find_packages, setup

# The directory containing this file
HERE = pathlib.Path(__file__).parent

# The text of the README file
README = (HERE / "README.md").read_text()

with open("requirements.txt") as f:
    install_requires = f.read().strip().split("\n")

setup(
    name="saloon",
    description="A pentester's Docker container that does some really nasty things",
    long_description=README,
    long_description_content_type="text/markdown",
    url="https://github.com/hexcowboy/saloon",
    author="hexcowboy <hex@cowboy.dev",
    version="0.1.2",
    license="MIT",
    py_modules=["saloon"],
    packages=find_packages(),
    install_requires=install_requires,
    entry_points={
        "console_scripts": [
            "saloon = cli.main:cli",
        ],
    },
)
