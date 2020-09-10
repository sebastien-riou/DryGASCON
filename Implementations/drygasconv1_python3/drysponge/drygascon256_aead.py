from drysponge.drygascon import DryGascon
from drysponge.aead import aead

if __name__ == "__main__":
    impl = DryGascon.DryGascon256().instance()
    aead(impl)
