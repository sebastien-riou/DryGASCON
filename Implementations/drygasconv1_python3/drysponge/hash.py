def hash(impl):
    from drysponge.base import DrySponge
    import sys
    import binascii

    messageBytes = binascii.unhexlify(b'')
    for i in range(1,len(sys.argv)):
        if (i==len(sys.argv)-1) & (len(sys.argv[i])%2):
            impl.Verbose(int(sys.argv[i]))
        else:
            messageBytes += binascii.unhexlify(sys.argv[i])
    out = impl.hash(messageBytes)
    DrySponge.print_bytes_as_hex(out)
    return DrySponge.bytes_as_hex(out)
