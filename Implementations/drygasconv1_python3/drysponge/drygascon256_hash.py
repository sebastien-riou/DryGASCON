from drysponge.drygascon import DryGascon
from drysponge.hash import hash

if __name__ == "__main__":
    impl = DryGascon.DryGascon256().instance()
    hash(impl)
