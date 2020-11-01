# DryGASCON
DryGASCON is an AEAD and hash algorithm submitted to [NIST lightweight crypto competition](https://csrc.nist.gov/Projects/Lightweight-Cryptography/round-2-candidates)

The [official specification](https://csrc.nist.gov/CSRC/media/Projects/lightweight-cryptography/documents/round-2/spec-doc-rnd2/drygascon-spec-round2.pdf) is hosted by NIST. [Status update](https://csrc.nist.gov/CSRC/media/Projects/lightweight-cryptography/documents/round-2/status-update-sep2020/DryGASCON_20200917-status-update.pdf).

## Implementations
This repository contains several hardware and software implementation. You can find also other implementations on other repositories:
* [DryGASCON128k32 optimized for ARM Cortex-M](https://github.com/sebastien-riou/DryGASCON128k32-arm-cortex-m).
* Rhys Weatherley's [pure C and AVR](https://github.com/rweather/lightweight-crypto/tree/master/src/individual/DryGASCON) implementations supports AEAD and hash.
* Ekawat 'Ice' Homsirikamol's [VHDL / Verilog](https://github.com/sebastien-riou/DryGASCON-LWC-API) implementation supports AEAD and hash, follows the [LWC hardware API](https://cryptography.gmu.edu/athena/index.php?id=LWC)

This repository contains:
* updated files compared to the official submission
* additional files such as build scripts and presentations

Python3 package:
* [read the docs page](https://drygascon.readthedocs.io/en/latest/): To use in your Python code
* [pypi page](https://pypi.org/project/drysponge): Examples to use from command line

## Benchmarks
Benchmark of software implementations:
- https://lwc.las3.de
- https://rweather.github.io/lightweight-crypto
    - [Initial ranking](https://rweather.github.io/lightweight-crypto/performance.html)
    - [Updated results](https://rweather.github.io/lightweight-crypto/performance_phase2.html)

Benchmarks on hardware implementations:
- [GMU_LWC_Round_2_FPGA_Benchmarking](https://cryptography.gmu.edu/athena/LWC/GMU_LWC_Round_2_FPGA_Benchmarking.pdf)

## Academic papers
The following papers mention DryGASCON:
- [distinguishers-for-reduced-round-ascon-drygascon-shamash-lwc2019](https://csrc.nist.gov/CSRC/media/Events/lightweight-cryptography-workshop-2019/documents/papers/distinguishers-for-reduced-round-ascon-drygascon-shamash-lwc2019.pdf)
- [Mode-Level vs. Implementation-Level Physical Security
in Symmetric Cryptography A Practical Guide Through
the Leakage-Resistance Jungle](https://hal.archives-ouvertes.fr/hal-02901380/document)

As DryGASCON core permutation is closely related to ASCON, much of the cryptanalysis work done on ASCON can be adapted to DryGASCON. All it takes is a reordering of the bits and change of few constants.

## Cryptanalysis challenges
To encourage more analysis of DryGASCON, I offer the following challenges:
Cryptanalysis Challenge: for each the reward is a full size bottle of chartreuse - DryGASCON-128 F function: how many rounds in G function can you break- DryGASCON-256 F function: same as above

As DryGASCON is not readily analyzable using classical Cryptanalysis tools, the challenges above may require much more involvement than some of you can afford. For this reason, easier challenges are also offered.
Classical Cryptanalysis Challenges: for each the reward is a 20cl bottle of chartreuse
* DryGASCON-128 G function: assuming you can xor a 128 bit input value with C 128 LSBs, how many rounds can you break by observing R ?
* DryGASCON-256 G function: same as above
* DryGASCON-128 F function, with the assumption that "X" is known to the attacker
Each reward will be attributed to the author of the best result at the time of Round 3 candidates announcement.

## Side channel attack challenges
* Write up a strategy to mount a side channel attack allowing key recovery on DryGASCON: reward is an FPGA board (the board targeted by the FPGA project in this repo)
* Perform a side channel attack on the FPGA project and recover the full key: reward is a full size bottle of chartreuse.

What is "chartreuse" ?
* Answer 1: This is a spirit originally made by monks, from herbs gathered from the Chartreuse mountains which happens to be the place where DryGASCON was designed.
* Answer 2: Something much better than Belgian beers :-p

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
