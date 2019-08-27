# DryGASCON
Submission to NIST lightweight crypto competition (https://csrc.nist.gov/Projects/Lightweight-Cryptography/round-1-candidates)

Official specification: https://csrc.nist.gov/CSRC/media/Projects/Lightweight-Cryptography/documents/round-1/spec-doc/drygascon-spec.pdf

This repository contains:
* the same files as the official submission
* additional files such as build scripts

## How to build C implementations ?
From Implementations folder, launch the following command:

    ./all build

This create several executables in the bin folder.

## How to run KAT generation ?
From Implementations folder, launch the following command:

    ./all kat

The following command check consistency between ref and le32 C implementations:

    ./all kat_check

## How to check consistency between C and Python code ?
From drygasconv1_python3 folder, launch the following command:

    ./check_all

## How to dump intermediate values ?
The python implementation supports a "verbosity" level, this is an integer from 0 to 5.

    $ ./drygascon128_hash "" 0
    1EDC77386E20A37C721D6E77ADABB9C4830F199F5ED25284A13C1D84B9FC257A

    $ ./drygascon128_hash "" 2
    Hashing 0 bytes message:
    Padded Message:  01000000000000000000000000000000
    F/G entry 0 (F with DS): padded=1, domain=2, finalize=1
    C[ 0] = 243F6A8885A308D313198A2E03707344243F6A8885A308D313198A2E03707344
    C[ 1] = 243F6A8885A308D3
    X[ 0] = A4093822299F31D0082EFA98EC4E6C89
        R = 00000000000000000000000000000000
        I = 01000000000000000000000000000000
    F/G entry 1 (G):
    C[ 0] = 5A6181623A46FA76D9D2B88D7071294CE76EC1D45CACEAC442098C4E488A1544
    C[ 1] = F93362EBACB4DCC4
    X[ 0] = A4093822299F31D0082EFA98EC4E6C89
        R = 1EDC77386E20A37C721D6E77ADABB9C4
    Final state:
    C[ 0] = 836EBE0D38DC2CFA8DAC5422568C2448413A8871431D60C43E04300BB55C4B70
    C[ 1] = 2B1A3852D5A568AA
    X[ 0] = A4093822299F31D0082EFA98EC4E6C89
        R = 830F199F5ED25284A13C1D84B9FC257A
    Digest: 1EDC77386E20A37C721D6E77ADABB9C4830F199F5ED25284A13C1D84B9FC257A
