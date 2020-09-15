drysponge's documentation
#########################

``drysponge`` is the reference package for `DryGASCON <https://github.com/sebastien-riou/DryGASCON>`__.

Other pages (online)

- `project page on GitHub`_
- `Download Page`_ with releases
- This page, when viewed online is at https://drysponge.readthedocs.io/en/latest/

.. _`project page on GitHub`: https://github.com/sebastien-riou/DryGASCON/tree/master/Implementations/drygasconv1_python3
.. _`Download Page`: http://pypi.python.org/pypi/drysponge


Installation
************
This installs a package that can be used from Python (``import drysponge``)
or in command line (``python3 -m drysponge.drygascon128_aead``).

From PyPI
=========
To install for the current user:

.. code-block:: python

    python3 -m pip install --user drysponge

To install for all users on the system, administrator rights (root)
may be required.

.. code-block:: python

    python3 -m pip install drysponge

Examples
========
First you need to create an instance of the cipher you want to use.
If you target 256 bit level, use this:

..
	.. testcode::
	
		print("a\t1");print("b\t2");print("c\t3")
	
	.. testoutput::
	
	    a	1
	    b	2
	    c	3
	
	
	.. testcode::
	
		print("a   1")
	
	.. testoutput::
		:options: +NORMALIZE_WHITESPACE
	
	    a   1
	
	.. testcode::
	
		print("a\t1")
	
	.. testoutput::
		
	    a	1
	
	.. testcode::
	
		print("a\t1")
	
	.. testoutput::
		:options: +NORMALIZE_WHITESPACE
	
	    a	1



.. testcode::

	from drysponge.drygascon import DryGascon
	cipher128 = DryGascon.DryGascon128().instance()

If you target 256 bit level, use that:

.. testcode::

	from drysponge.drygascon import DryGascon
	cipher256 = DryGascon.DryGascon256().instance()

To hash:

.. testcode::

	import binascii
	digest = cipher128.hash("abc".encode('utf-8'))
	print(binascii.hexlify(digest))

.. testoutput::

	b'8883ff9cf556714116390fda08768463cf82b12021d4697250d959d53aaa87cf'

To encrypt:

.. testcode::

	ciphertext = cipher128.encrypt(
		key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
		nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
		message="message".encode('utf-8'),
		associated_data="associated data".encode('utf-8'))
	print(binascii.hexlify(ciphertext))

.. testoutput::

	b'8c49773e01cf469eb668ae9908201262d8f14682800d52'

To decrypt:

.. testcode::

	message = cipher128.decrypt(
		key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
		nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
		ciphertext=ciphertext,
		associated_data="associated data".encode('utf-8'))
	print(message)

.. testoutput::

	bytearray(b'message')

Getting instance's parameter:
=============================

.. testcode::

	print("'small' profile key size:\t", cipher128.key_size())
	print("'fast' profile key size:\t", cipher128.fastkey_size())
	print("'full' profile key size:\t", cipher128.fullkey_size())
	print("nonce size:\t", cipher128.nonce_size())
	print("block size:\t", cipher128.block_size())
	print("tag size:\t", cipher128.tag_size())

.. testoutput::

    'small' profile key size:	 16
    'fast' profile key size:	 32
    'full' profile key size:	 56
    nonce size:	 16
    block size:	 16
    tag size:	 16


Using the SPY
=============
Each instance as an independant verbosity level. By default operations are silent, that's usually what you want if you use the cipher in an application. If you wish to see the internal values, you can set the verbosity level to one of the following values:

- cipher128.SPY_ALG_IO: operation inputs/outputs (min verbosity bar none)
- cipher128.SPY_F_IO: F function's inputs/outputs level
- cipher128.SPY_ROUND_IO: GASCON function's inputs/outputs level
- cipher128.SPY_FULL: all intermediate values (max verbosity)

.. testcode::

	cipher128.Verbose(cipher128.SPY_ALG_IO)
	cipher128.encrypt(
		key=binascii.unhexlify(b'000102030405060708090A0B0C0D0E0F'),
		nonce=binascii.unhexlify(b'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'),
		message="message".encode('utf-8'),
		associated_data="associated data".encode('utf-8'))

.. testoutput::

    Encrypting 7 bytes message with 15 bytes of associated data and 0 bytes of static data 
    Key size: 16 bytes 
       Key:             000102030405060708090A0B0C0D0E0F
       Nonce:           F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF
       Associated data: 6173736F6369617465642064617461
       Message:         6D657373616765
       Padded A. data:  6173736F636961746564206461746101
       Padded Message:  6D657373616765010000000000000000
       CipherText:      8C49773E01CF46
       Tag:             9EB668AE9908201262D8F14682800D52

.. toctree::

Indices and tables
##################

* :ref:`genindex`
* :ref:`search`
