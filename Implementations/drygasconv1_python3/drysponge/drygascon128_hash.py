from drysponge.drygascon import DryGascon
from drysponge.hash import hash

if __name__ == "__main__":
    impl = DryGascon.DryGascon128().instance()
    hash(impl)
