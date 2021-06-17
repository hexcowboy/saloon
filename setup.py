from setuptools import setup

setup(
    name="saloon",
    version="0.1.0",
    py_modules=["saloon"],
    install_requires=[
        "click",
    ],
    entry_points={
        "console_scripts": [
            "saloon = cli.main:cli",
        ],
    },
)
