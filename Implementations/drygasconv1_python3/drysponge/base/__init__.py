# DrySponge: Sponge that does not leak
# Sebastien Riou, January 5th 2019
# Convention:
#  width means length in bits
#  size means length in bytes
import sys
import binascii
import os
import copy
import random

class DrySponge(object):

    SPY_NONE = 0
    SPY_ALG_IO = 1
    SPY_F_IO = 2
    SPY_ROUND_IO = 3
    SPY_FULL = 4

    DS_S = 2
    DS_D = 1
    DS_A = 2
    DS_M = 3

    def __init__(self,params):
        assert(0==(params.MinKeyWidth%8))
        assert(0==(params.RateWidth%8))
        assert(0==(params.CapacityWidth%8))
        self.params = params
        self.__VerboseLevel = 0
        self.__MinKeyWidth = params.MinKeyWidth
        self.__NonceWidth = params.NonceWidth
        self.__RateWidth = params.RateWidth
        self.__XWidth = params.xwords*32
        self.__CapacityWidth = params.CapacityWidth
        self.__MixPhase = params.MixPhase
        self.__InitRounds = params.InitRounds
        self.__Rounds = params.Rounds
        #self.__FinalRounds = params.FinalRounds
        self.__CoreRound = params.CoreRound
        self.__DomainSeparator = params.DomainSeparator
        self.__AccumulateFactor = params.AccumulateFactor
        self.__BLOCKSIZE = params.RateWidth // 8
        self.__CL_SBOUND = 0
        self.__CL_EBOUND = self.__BLOCKSIZE
        self.__CH_SBOUND = self.__CL_EBOUND
        self.__CH_EBOUND = self.__CH_SBOUND + self.__BLOCKSIZE
        self.__C_EBOUND = params.CapacityWidth // 8
        self.__X_SBOUND  = self.__C_EBOUND
        self.__X_EBOUND  = self.__X_SBOUND + params.xwords*4

        self.__R_SBOUND  = self.__X_EBOUND
        self.__R_EBOUND  = self.__R_SBOUND + self.__BLOCKSIZE

        self.__StateWidth = params.RateWidth + params.CapacityWidth + params.xwords*32
        self.__CST_H = DrySponge.int_to_bytes(0x243F6A8885A308D313198A2E03707344A4093822299F31D0082EFA98EC4E6C89452821E638D01377BE5466CF34E90C6CC0AC29B7C97C50DD3F84D5B5B54709179216D5D98979FB1BD1310BA698DFB5AC2FFD72DBD01ADFB7B8E1AFED6A267E96BA7C9045F12C7F9924A19947B3916CF70801F2E2858EFC16636920D871574E69,1024)
        self.__CST_H.reverse()
        #for i in range(0,len(self.__CST_H)//8):
        #    w=DrySponge.bytes_to_int(self.__CST_H[8*i:8*(i+1)])
        #    print("0x%016x,"%w)
        #for i in range(0,len(self.__CST_H)//8):
        #    for j in range(0,8):
        #        print("0x%02x,"%self.__CST_H[i*8+j],end="")
        #    print()
        #things that shall be initialized by __init()
        self.__State = None
        self.__fcnt = None

    def __init(self):
        self.__State = DrySponge.int_to_bytes(0,self.__StateWidth)
        self.__fcnt = 0

    def __c(self):
        return copy.deepcopy(self.__State[self.__CL_SBOUND:self.__C_EBOUND])

    def __clh(self):
        return copy.deepcopy(self.__State[self.__CL_SBOUND:self.__CH_EBOUND])

    def __cl(self):
        return copy.deepcopy(self.__State[self.__CL_SBOUND:self.__CL_EBOUND])

    def __ch(self):
        return copy.deepcopy(self.__State[self.__CH_SBOUND:self.__CH_EBOUND])

    def __x(self):
        return copy.deepcopy(self.__State[self.__X_SBOUND:self.__X_EBOUND])

    def __r(self):
        return copy.deepcopy(self.__State[self.__R_SBOUND:self.__R_EBOUND])

    @staticmethod
    def limit_len(data,length):
        if len(data) > length:
            data = copy.deepcopy(data[0:length])
        return data

    def __set_c(self,val):
        self.__State[self.__CL_SBOUND:self.__C_EBOUND] = self.limit_len(val,self.__CapacityWidth//8)

    def __set_x(self,val):
        self.__State[self.__X_SBOUND:self.__X_EBOUND] = self.limit_len(val,self.__XWidth//8)

    def __set_r(self,val):
        self.__State[self.__R_SBOUND:self.__R_EBOUND] = self.limit_len(val,self.__RateWidth//8)

    def Verbose(self,level=None):
        if level is not None:
            self.__VerboseLevel = level
            self.params.spy = (self.SPY_FULL<=level)
            self.params.spy_all = (self.SPY_FULL<level)
        return self.__VerboseLevel

    @staticmethod
    def bytes_as_hex(block, end=""):
        out=""
        for b in block:
            out += "%02X"%b
        out += end
        return out

    @staticmethod
    def print_bytes_as_hex(block, end="\n"):
        print(DrySponge.bytes_as_hex(block,end),end="")

    def __print_state(self, msg=None, level=0):
        if self.__VerboseLevel >= level:
            if msg is not None:
                print(msg)
            linesize = max(32,self.__BLOCKSIZE)
            for i in range(0,(self.__CapacityWidth//8+linesize-1) // linesize):
                self.__print("   C[%2d] ="%i,self.__c()[i*linesize:(i+1)*linesize],level)
            for i in range(0,(self.__XWidth//8+linesize-1) // linesize):
                self.__print("   X[%2d] ="%i,self.__x()[i*linesize:(i+1)*linesize],level)
            self.__print("       R =",self.__r(),level)

    def __print(self, msg=None, data=None, level=0):
        if self.__VerboseLevel >= level:
            data_str = ""
            if data is not None:
                data_str = self.bytes_as_hex(data)
            if msg is None:
                msg = data_str
            else:
                msg = msg + " " + data_str
            print(msg)

    @staticmethod
    def int_to_bytes(a,width=8):
        return bytearray(a.to_bytes((width+7)//8, byteorder='little'))

    @staticmethod
    def bytes_to_int(a):
        if 0 == len(a):
            return 0
        return int.from_bytes(a, byteorder='little', signed=False)

    def __rotr32(self,val, r):
        return ((val >> r) ^ (val << (32-r))) % (1 << 32)

    def __xor(self,a,b):
        return bytearray(bytes([ (x ^ y) for (x,y) in zip(a, b) ]))

    @staticmethod
    def swap32(a,b,s):
        for i in range(0,4):
            tmp=s[a+i]
            s[a+i]=s[b+i]
            s[b+i]=tmp

    def __set_key(self,key):
        minkeysize = self.__MinKeyWidth // 8;
        xsize = self.__XWidth//8
        xwords = self.__XWidth // 32
        csize = self.__CapacityWidth//8
        midkeysize = minkeysize+xsize;
        fullkeysize = csize+xsize
        assert(len(key)>=minkeysize)
        assert(len(key)<=fullkeysize)
        k = copy.deepcopy(key)
        if fullkeysize==len(key):
            self.__set_c(k[:csize])
            self.__set_x(k[csize:])
        else:
            kc = copy.deepcopy(k[:minkeysize])
            while len(kc) < csize:
                kc += copy.deepcopy(kc)
            self.__set_c(kc[:csize])
            if midkeysize==len(key):
                self.__set_x(k[minkeysize:])
            else:
                assert(minkeysize==len(key))
                self.__print_state("   Key setup entry:",self.SPY_ROUND_IO)
                self.__set_c(self.__CoreRound(self.__c(),0))
                modified=1
                cnt=1
                while modified:
                    modified=0
                    c = self.__c()
                    for i in range(0,xwords-1):
                        for j in range(i+1,xwords):
                            if c[i*4:i*4+4] == c[j*4:j*4+4]:
                                self.__print_state("   X fixup entry %d:"%cnt,self.SPY_ROUND_IO)
                                self.__set_c(self.__CoreRound(self.__c(),0))
                                modified=1
                                cnt+=1
                                break
                        if modified:
                            break
                self.__set_x(c[:xsize])
                assert(len(key)>=xsize)
                c[:xsize] = copy.deepcopy(key[:xsize])
                self.__set_c(c)
        x = self.__x()
        for i in range(0,xwords-1):
            for j in range(i+1,xwords):
                assert(x[i*4:i*4+4] != x[j*4:j*4+4])


    def __g(self,caller_is_F=0):
        if 0==caller_is_F:
            self.__print_state("   F/G entry %d (G):"%self.__fcnt,self.SPY_F_IO)
        self.__fcnt += 1
        self.__set_r(DrySponge.int_to_bytes(0,self.__BLOCKSIZE*8))
        blocksize32 = (self.__BLOCKSIZE+3)//4 #rounded up
        for j in range(0,self.params.rounds):
            self.__print_state("   CoreRound entry %d:"%j,self.SPY_ROUND_IO)
            self.__set_c(self.__CoreRound(self.__c(),j))
            r = self.__r()
            self.__print_state("   Accumulate entry %d:"%j,self.SPY_FULL)
            for k in range(0,self.__AccumulateFactor):
                cpart = self.__c()[k*4*blocksize32:]
                cpart = cpart[0:self.__BLOCKSIZE]
                cpart2 = cpart[k*4:] + cpart[0:k*4]
                self.__print("accumulate in[%d] ="%k,cpart2,self.SPY_FULL)
                r = self.__xor(r,cpart2)
            self.__set_r(r)
        return self.__r()

    def __f(self,i,padded=None,domain=None,finalize=None):
        assert(len(i)==self.__BLOCKSIZE)
        if padded is not None:
            self.__DomainSeparator(padded,domain,finalize)
            self.__print_state("   F/G entry %d (F with DS): padded=%d, domain=%d, finalize=%d"%(self.__fcnt,padded,domain,finalize),self.SPY_F_IO)
        else:
            self.__print_state("   F/G entry %d (F):"%(self.__fcnt),self.SPY_F_IO)

        self.__print("       I =",i,self.SPY_F_IO)
        (c,x)=self.__MixPhase(self.__c(),self.__x(),i)
        self.__set_c(c)
        self.__set_x(x)
        self.__print_state("   After mix phase:",self.SPY_ROUND_IO)
        return self.__g(1)

    def __padding(self,lastblock):
        padded = 0
        pad = binascii.unhexlify(b'01')
        for i in range(len(lastblock),self.__BLOCKSIZE):
            lastblock += pad
            pad = binascii.unhexlify(b'00')
            padded = 1
        return padded

    def key_size(self):
        return self.__MinKeyWidth // 8

    def fastkey_size(self):
        return (self.__MinKeyWidth+self.__XWidth) // 8

    def fullkey_size(self):
        return (self.__CapacityWidth+self.__XWidth) // 8

    def block_size(self):
        return self.__BLOCKSIZE

    def nonce_size(self):
        return self.__NonceWidth // 8

    def tag_size(self):
        return self.__MinKeyWidth // 8

    def __swap32(self,a,b):
        c=self.__c()
        for i in range(0,4):
            tmp = c[a*4+i]
            c[a*4+i] = c[b*4+i]
            c[b*4+i] = tmp
        self.__set_c(c)

    def __absorb_only(self,ad,domain,final,paddedmsg):
        alen = len(ad)
        a = (alen + self.__BLOCKSIZE -1) // self.__BLOCKSIZE

        if a>0:
            lastblock = bytearray(copy.deepcopy(ad[(a-1)*self.__BLOCKSIZE:]))
        else:
            a=1
            lastblock = bytearray(b'')

        apad = self.__padding(lastblock)
        if apad:
            self.__print(paddedmsg,ad[:(a-1)*self.__BLOCKSIZE]+lastblock,self.SPY_ALG_IO)

        for i in range(0,a-1):
            ai = ad[i*self.__BLOCKSIZE:(i+1)*self.__BLOCKSIZE]
            self.__f(ai)

        self.__f(lastblock,apad,domain,final)

    def hash(self,message):
        self.__print("Hashing %d bytes message:"%len(message),message,self.SPY_ALG_IO)
        self.__init()
        self.params.rounds = self.params.Rounds
        self.__set_key(self.__CST_H[:(self.__MinKeyWidth+self.__XWidth)//8])
        self.__absorb_only(message,self.DS_S,1,"   Padded Message: ")
        out = self.__r()
        for i in range(1,2*((self.__MinKeyWidth + self.__RateWidth -1 ) // self.__RateWidth) ):
            out += self.__g()
        out = out[:2*self.__MinKeyWidth // 8]
        self.__print_state("   Final state:",self.SPY_F_IO)
        self.__print("   Digest:",out,self.SPY_ALG_IO)
        return out

    def encrypt(self,key,nonce,message=None,associated_data=None,static_data=None):
        self.params.rounds = self.params.Rounds
        if message is None:
            message = bytearray(binascii.unhexlify(b''))
        if associated_data is None:
            associated_data = bytearray(binascii.unhexlify(b''))
        if static_data is None:
            static_data = bytearray(binascii.unhexlify(b''))
        self.__print(
            "Encrypting %d bytes message with %d bytes of associated data and %d bytes of static data"%(len(message),len(associated_data),len(static_data)),
            None,self.SPY_ALG_IO)
        self.__print(
            "Key size: %d bytes"%(len(key)),
            None,self.SPY_ALG_IO)
        self.__print("   Key:            ",key,self.SPY_ALG_IO)
        self.__print("   Nonce:          ",nonce,self.SPY_ALG_IO)
        if len(static_data):
            self.__print("   Static data:    ",static_data,self.SPY_ALG_IO)
        if len(associated_data):
            self.__print("   Associated data:",associated_data,self.SPY_ALG_IO)
        if len(message):
            self.__print("   Message:        ",message,self.SPY_ALG_IO)
        self.__init()
        self.__set_key(key)
        #assert(0==(len(nonce)%self.block_size()))
        assert(12<=len(nonce))
        final=0
        if (0==len(message)) & (0==len(associated_data)):
            final=1

        #static data
        if len(static_data):
            self.__absorb_only(static_data,self.DS_S,final,"   Padded S. data: ")
            final=0
            sdk = self.__r()
            for i in range(1,(self.__CapacityWidth + self.__RateWidth -1 )// self.__RateWidth):
                sdk += self.__g()
            self.__set_c(sdk)

        self.params.rounds = self.params.InitRounds
        #diversification
        if self.__NonceWidth > self.__RateWidth:
            self.__f(nonce[0:self.__BLOCKSIZE],0,self.DS_D,final)
            for i in range(1,self.__NonceWidth//self.__RateWidth):
                self.__f(nonce[i*self.__BLOCKSIZE:(i+1)*self.__BLOCKSIZE])
        else:
            block = bytearray(binascii.unhexlify(b'00')*self.block_size())
            block[0:self.nonce_size()] = nonce
            self.__f(block,0,self.DS_D,final)

        self.params.rounds = self.params.Rounds

        #associated data
        if len(associated_data):
            final = 0==len(message)
            self.__absorb_only(associated_data,self.DS_A,final,"   Padded A. data: ")

        mlen = len(message)
        m = (mlen + self.__BLOCKSIZE -1) // self.__BLOCKSIZE
        mpad = 0

        out = bytearray(binascii.unhexlify(b''))

        if m>0:
            mlastblock = bytearray(copy.deepcopy(message[(m-1)*self.__BLOCKSIZE:]))
            mpad = self.__padding(mlastblock)
            if mpad:
                self.__print("   Padded Message: ",message[:(m-1)*self.__BLOCKSIZE]+mlastblock,self.SPY_ALG_IO)

            for i in range(0,m-1):
                pi = message[i*self.__BLOCKSIZE:(i+1)*self.__BLOCKSIZE]
                out += self.__xor(self.__r(),pi)
                self.__f(pi)

            out += self.__xor(self.__r(),mlastblock)
            out = out[:len(message)]
            self.__f(mlastblock,mpad,self.DS_M,1)

        tag = self.__r()
        for i in range(1,(self.__MinKeyWidth + self.__RateWidth -1 )// self.__RateWidth):
            tag += self.__g()
        tag = tag[:self.__MinKeyWidth // 8]
        self.__print_state("   Final state:",self.SPY_F_IO)
        self.__print("   CipherText:     ",out,self.SPY_ALG_IO)
        self.__print("   Tag:            ",tag,self.SPY_ALG_IO)
        #self.__print("   CipherText|Tag: ",out+tag,self.SPY_ALG_IO)
        return out+tag

    def decrypt(self,key,nonce,ciphertext,associated_data=None,static_data=None):
        self.params.rounds = self.params.Rounds
        self.__init()
        if associated_data is None:
            associated_data = bytearray(binascii.unhexlify(b''))
        if static_data is None:
            static_data = bytearray(binascii.unhexlify(b''))
        self.__print(
            "Decrypting %d bytes ciphertext with %d bytes of associated data and %d bytes of static data"%(len(ciphertext),len(associated_data),len(static_data)),
            None,self.SPY_ALG_IO)
        self.__print(
            "Key size: %d bytes"%(len(key)),
            None,self.SPY_ALG_IO)
        message = ciphertext[:-self.tag_size()]
        expected_tag = ciphertext[-self.tag_size():]
        self.__print("   Key:            ",key,self.SPY_ALG_IO)
        self.__print("   Nonce:          ",nonce,self.SPY_ALG_IO)
        if len(static_data):
            self.__print("   Static data:    ",static_data,self.SPY_ALG_IO)
        if len(associated_data):
            self.__print("   Associated data:",associated_data,self.SPY_ALG_IO)
        if len(message):
            self.__print("   CipherText Msg: ",message,self.SPY_ALG_IO)
        self.__print("   CipherText Tag: ",expected_tag,self.SPY_ALG_IO)
        assert(len(key)>=self.key_size())
        self.__set_key(key)
        #assert(0==(len(nonce)%self.block_size()))
        assert(96>=len(nonce))
        final=0
        if (0==len(message)) & (0==len(associated_data)):
            final=1

        #static data
        if len(static_data):
            self.__absorb_only(static_data,self.DS_S,final,"   Padded S. data: ")
            final=0
            sdk = self.__r()
            for i in range(1,(self.__CapacityWidth + self.__RateWidth -1 )// self.__RateWidth):
                sdk += self.__g()
            self.__set_c(sdk)

        self.params.rounds = self.params.InitRounds
        #diversification
        if self.__NonceWidth > self.__RateWidth:
            nloops = (self.__NonceWidth + self.__RateWidth -1)//self.__RateWidth
            for i in range(0,nloops-1):
                self.__f(nonce[i*self.__BLOCKSIZE:(i+1)*self.__BLOCKSIZE])
            self.__f(nonce[(nloops-1)*self.__BLOCKSIZE:nloops*self.__BLOCKSIZE],0,self.DS_D,final)
        else:
            block = bytearray(binascii.unhexlify(b'00')*self.block_size())
            block[0:self.nonce_size()] = nonce
            self.__f(block,0,self.DS_D,final)
        self.params.rounds = self.params.Rounds

        #associated data
        if len(associated_data):
            final = 0==len(message)
            self.__absorb_only(associated_data,self.DS_A,final,"   Padded A. data: ")

        mlen = len(message)
        m = (mlen + self.__BLOCKSIZE -1) // self.__BLOCKSIZE
        mpad = 0
        out = bytearray(binascii.unhexlify(b''))

        if m>0:
            mlastblock = bytearray(copy.deepcopy(message[(m-1)*self.__BLOCKSIZE:]))
            for i in range(0,m-1):
                ci = message[i*self.__BLOCKSIZE:(i+1)*self.__BLOCKSIZE]
                pi = self.__xor(self.__r(),ci)
                out += pi
                self.__f(pi)

            mlastblock = self.__xor(self.__r(),mlastblock)
            mpad = self.__padding(mlastblock)
            out += mlastblock
            if mpad:
                self.__print("   Padded Message: ",out,self.SPY_ALG_IO)
            out = out[:len(message)]
            self.__DomainSeparator(mpad,self.DS_M,1)
            self.__f(mlastblock)

        tag = self.__r()
        for i in range(1,(self.__MinKeyWidth + self.__RateWidth -1 )//self.__RateWidth):
            tag += self.__g()
        tag = tag[:self.__MinKeyWidth // 8]
        self.__print_state("   Final state:",self.SPY_F_IO)
        if tag != expected_tag:
            raise ValueError('authentication tags different')
        self.__print("   Message:        ",out,self.SPY_ALG_IO)
        return out
