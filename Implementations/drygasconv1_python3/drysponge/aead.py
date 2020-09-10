
def aead(impl):
    from drysponge.base import DrySponge
    import sys
    import binascii

    if (len(sys.argv) > 8) | (len(sys.argv) < 6):
        print("ERROR: need at least 5 arguments: operation,key,nonce,message,associatedData,[staticData],[verbosity]")
        print("""
operation:
    e,enc,encrypt
    d,dec,decrypt

verbosity: from 0 to 5

examples:
    no message, no associated data: e 000102030405060708090A0B0C0D0E0F 000102030405060708090A0B0C0D0E0F "" ""
    message, no associated data:    e 000102030405060708090A0B0C0D0E0F 000102030405060708090A0B0C0D0E0F "AABB" ""
    no message, associated data:    e 000102030405060708090A0B0C0D0E0F 000102030405060708090A0B0C0D0E0F "" "AABB"
    message and associated data:    e 000102030405060708090A0B0C0D0E0F 000102030405060708090A0B0C0D0E0F "AABB" "CCDD"
    same with verbose output:       e 000102030405060708090A0B0C0D0E0F 000102030405060708090A0B0C0D0E0F "AABB" "CCDD" 2
        """)
        exit()
    op = sys.argv[1]
    key = binascii.unhexlify(sys.argv[2])
    nonce = binascii.unhexlify(sys.argv[3])
    message = binascii.unhexlify(sys.argv[4])
    associatedData = binascii.unhexlify(sys.argv[5])
    staticData = None
    verbosityIdx = None
    if len(sys.argv) > 6 :
        if len(sys.argv[6]) > 1:
            staticData = binascii.unhexlify(sys.argv[6])
        else:
            assert(len(sys.argv) == 7)
            verbosityIdx = 6
    if len(sys.argv) == 8 :
        assert(verbosityIdx is None)
        verbosityIdx = 7
    if verbosityIdx is not None:
        impl.Verbose(int(sys.argv[verbosityIdx]))
    if op in ['e','enc','encrypt']:
        out = impl.encrypt(key,nonce,message,associatedData,staticData)
    elif op in ['d','dec','decrypt']:
        out = impl.decrypt(key,nonce,message,associatedData,staticData)
    else:
        out = impl.encrypt(key,nonce,message,associatedData,staticData)
        impl.decrypt(key,nonce,out,associatedData,staticData)
    DrySponge.print_bytes_as_hex(out)
