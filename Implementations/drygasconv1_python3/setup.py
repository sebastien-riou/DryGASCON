import setuptools


setuptools.setup(
    name="drysponge",
    version="1.0.4",
    author="Sebastien Riou",
    author_email="matic@nimp.co.uk",
    description="DryGASCON reference implementation",
    long_description = """
    DryGASCON reference implementation
    """,
    long_description_content_type="text/markdown",
    url="https://github.com/sebastien-riou/DryGASCON",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
)
