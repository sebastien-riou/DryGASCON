import binascii
from drysponge.drygascon import DryGascon
cipher = DryGascon.DryGascon128().instance()

#all test vectors are taken from submission of DryGASCON_v1 to NIST's LWC.

print('Compute DryGASCON128 hash')
data = cipher.hash(binascii.unhexlify(b'0001020304050607'))
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'CDE2DEE0235345CBFA51EC2CE57435718EC0133EC2756E035FA404C1CE511E24'))

print('Compute DryGASCON128k16 encryption of null message')
data = cipher.encrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	message=bytearray(),
	associated_data=bytearray())
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'98AF3B3FB2000908C698C3C595FAB6E8'))

#same thing, compact version
data = cipher.encrypt(binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'))
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'98AF3B3FB2000908C698C3C595FAB6E8'))

print('Compute DryGASCON128k16 decryption of null message')
data = cipher.decrypt(binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),binascii.unhexlify(b'98AF3B3FB2000908C698C3C595FAB6E8'))
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b''))

print('Compute DryGASCON128k32 encryption of null message')
data = cipher.encrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	message=bytearray(),
	associated_data=bytearray())
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'363001DCCA220E28470EA42E63C9A2AF'))

print('Compute DryGASCON128k56 encryption of null message')
data = cipher.encrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323334353637'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	message=bytearray(),
	associated_data=bytearray())
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'F1FBA3D719B00A49BF170F832EB7649F'))

print('Compute DryGASCON128k56 encryption of null message equivalent to DryGASCON128k32 encryption')
data = cipher.encrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F000102030405060708090A0B0C0D0E0F0001020304050607101112131415161718191A1B1C1D1E1F'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	message=bytearray(),
	associated_data=bytearray())
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'363001DCCA220E28470EA42E63C9A2AF'))

#enable printing of inputs/outputs
cipher.Verbose(cipher.SPY_ALG_IO)
data = cipher.encrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	message=binascii.unhexlify(b'000102'),
	associated_data=binascii.unhexlify(b'00000000000000000000000000000000'))
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'4F3E61FFD51488453AEE3C5ED5294676E92620'))

print('Compute decryption of previous result')
data = cipher.decrypt(
	key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
	nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
	ciphertext=data,
	associated_data=binascii.unhexlify(b'00000000000000000000000000000000'))
cipher.print_bytes_as_hex(data)
assert(data == binascii.unhexlify(b'000102'))

