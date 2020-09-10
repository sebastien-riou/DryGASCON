import binascii
import copy

class Gascon(object):
    def __init__(self,nw,rounds):
        assert(1==(nw%2)) #sbox not bijective if nw is even
        assert(nw in [5,9])
        self.__nw = nw
        self.__rounds = rounds
        assert(self.__rounds <= 12)

    @staticmethod
    def sbox(i,nw):
        S = [0]*nw
        for b in range(0,nw):
            S[b] = (i >> b) & 1
        Gascon.sboxes(S,nw)
        r = 0
        for b in range(0,nw):
            r |= (S[b] & 1)<<b
        return r

    @staticmethod
    def __dbg(S,spy=True):
        if spy:
            for i in range(0,len(S)):
                print("%d: %016x"%(i,S[i]))
            print()

    @staticmethod
    def sboxes(S,nw):
        #Gascon.__dbg(S)
        mid = nw//2
        for i in range(0,mid+1):
            dst = 2*i
            src = (nw+dst-1) % nw
            S[dst] ^= S[src]
        #Gascon.__dbg(S)
        T = [(S[i] ^ 0xFFFFFFFFFFFFFFFF) & S[(i+1)%nw] for i in range(nw)]
        #Gascon.__dbg(T)
        for i in range(nw):
            S[i] ^= T[(i+1)%nw]
        #Gascon.__dbg(S)
        for i in range(0,mid+1):
            src = (2*i) % nw
            dst = (src+1) % nw
            S[dst] ^= S[src]
        S[mid] ^= 0XFFFFFFFFFFFFFFFF
        #Gascon.__dbg(S)

    def round(self,S,round,spy=False):
        """
        Gascon core permutation.
        S: Gascon state, a list of nw 64-bit integers
        round: round to perform
        returns nothing, updates S
        """
        assert(round <= 12)
        r = 12-self.__rounds+round
        mid = self.__nw//2
        # --- add round constants ---
        #round_constants = [
        #    0x0000000c0000000c,
        #    0x0000000c00000009,
        #    0x000000090000000c,
        #    0x0000000900000009,
        #    0x0000000c00000006,
        #    0x0000000c00000003,
        #    0x0000000900000006,
        #    0x0000000900000003,
        #    0x000000060000000c,
        #    0x0000000600000009,
        #    0x000000030000000c,
        #    0x0000000300000009
        #    ]
        #S[mid] ^= round_constants[r]
        S[mid] ^= ((0xF-r)<<4) | r
        if spy:
            print("rounds=%u, round=%u, r=%u"%(self.__rounds,round,r))
        self.__dbg(S,spy)
        # --- substitution layer ---
        self.sboxes(S,self.__nw)
        self.__dbg(S,spy)
        # --- linear diffusion layer ---
        S[0] ^= self.rotr64_interleaved(S[0], 19) ^ self.rotr64_interleaved(S[0], 28)
        S[1] ^= self.rotr64_interleaved(S[1], 61) ^ self.rotr64_interleaved(S[1], 38)
        S[2] ^= self.rotr64_interleaved(S[2],  1) ^ self.rotr64_interleaved(S[2],  6)
        S[3] ^= self.rotr64_interleaved(S[3], 10) ^ self.rotr64_interleaved(S[3], 17)
        S[4] ^= self.rotr64_interleaved(S[4],  7) ^ self.rotr64_interleaved(S[4], 40)
        if self.__nw > 5:
            S[5] ^= self.rotr64_interleaved(S[5], 31) ^ self.rotr64_interleaved(S[5], 26)
            S[6] ^= self.rotr64_interleaved(S[6], 53) ^ self.rotr64_interleaved(S[6], 58)
            S[7] ^= self.rotr64_interleaved(S[7],  9) ^ self.rotr64_interleaved(S[7], 46)
            S[8] ^= self.rotr64_interleaved(S[8], 43) ^ self.rotr64_interleaved(S[8], 50)
        #if self.__nw > 9:
        #    S[ 9] ^= self.rotr64_interleaved(S[ 9], ?) ^ self.rotr64_interleaved(S[ 9], ?)
        #    S[10] ^= self.rotr64_interleaved(S[10], ?) ^ self.rotr64_interleaved(S[10], ?)
        #    S[11] ^= self.rotr64_interleaved(S[11], ?) ^ self.rotr64_interleaved(S[11], ?)
        #    S[12] ^= self.rotr64_interleaved(S[12], ?) ^ self.rotr64_interleaved(S[12], ?)
        #    S[13] ^= self.rotr64_interleaved(S[13], ?) ^ self.rotr64_interleaved(S[13], ?)
        #    S[14] ^= self.rotr64_interleaved(S[14], ?) ^ self.rotr64_interleaved(S[14], ?)
        self.__dbg(S,spy)
        #if spy:
        #    exit()

    @staticmethod
    def rotr64(val, r):
        return ((val >> r) ^ (val << (64-r))) % (1 << 64)

    @staticmethod
    def rotr32(val, r):
        return ((val >> r) ^ (val << (32-r))) % (1 << 32)

    @staticmethod
    def rotr64_interleaved(val, r):
        i = [val & 0xFFFFFFFF, val>>32]
        shift2 = r//2
        if r & 1:
            tmp = Gascon.rotr32(i[1],shift2);
            i[1] = Gascon.rotr32(i[0],(shift2+1)%32);
            i[0] = tmp;
        else:
            i[0] = Gascon.rotr32(i[0],shift2);
            i[1] = Gascon.rotr32(i[1],shift2);
        val = (i[1]<<32) | i[0]
        return val


if __name__ == "__main__":

    def sbox_nw7_equations1(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        a0 = x0 ^ x6
        a1 = x1
        a2 = x2 ^ x1
        a3 = x3
        a4 = x4 ^ x3
        a5 = x5
        a6 = x6 ^ x5

        b0 = (1 ^ a0) & a1
        b1 = (1 ^ a1) & a2
        b2 = (1 ^ a2) & a3
        b3 = (1 ^ a3) & a4
        b4 = (1 ^ a4) & a5
        b5 = (1 ^ a5) & a6
        b6 = (1 ^ a6) & a0

        c0 = a0 ^ b1
        c1 = a1 ^ b2
        c2 = a2 ^ b3
        c3 = a3 ^ b4
        c4 = a4 ^ b5
        c5 = a5 ^ b6
        c6 = a6 ^ b0

        d0 = c0 ^ c6
        d1 = c1 ^ c0
        d2 = c2
        d3 = c3 ^ c2
        d4 = c4
        d5 = c5 ^ c4
        d6 = c6

        y0 = d0
        y1 = d1
        y2 = d2
        y3 = d3 ^ 1
        y4 = d4
        y5 = d5
        y6 = d6

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def sbox_nw7_equations2(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        b0 = ((1 ^ x0 ^ x6) & x1)
        b1 = ((1 ^ x1) & (x2 ^ x1))
        b2 = ((1 ^ x2 ^ x1) & x3)
        b3 = ((1 ^ x3) & (x4 ^ x3))
        b4 = ((1 ^ x4 ^ x3) & x5)
        b5 = ((1 ^ x5) & (x6 ^ x5))
        b6 = ((1 ^ x6 ^ x5) & (x0 ^ x6))

        c0 = x0 ^ x6 ^ (b1)
        c1 = x1 ^ (b2)
        c2 = x2 ^ x1 ^ (b3)
        c3 = x3 ^ (b4)
        c4 = x4 ^ x3 ^ (b5)
        c5 = x5 ^ (b6)
        c6 = x6 ^ x5 ^ (b0)

        d0 = c0 ^ c6
        d1 = c1 ^ c0
        d2 = c2
        d3 = c3 ^ c2
        d4 = c4
        d5 = c5 ^ c4
        d6 = c6

        y0 = d0
        y1 = d1
        y2 = d2
        y3 = d3 ^ 1
        y4 = d4
        y5 = d5
        y6 = d6

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def sbox_nw7_equations3(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        c0 = x0 ^ x6 ^ ((1 ^ x1) & (x2 ^ x1))
        c1 = x1 ^ ((1 ^ x2 ^ x1) & x3)
        c2 = x2 ^ x1 ^ ((1 ^ x3) & (x4 ^ x3))
        c3 = x3 ^ ((1 ^ x4 ^ x3) & x5)
        c4 = x4 ^ x3 ^ ((1 ^ x5) & (x6 ^ x5))
        c5 = x5 ^ ((1 ^ x6 ^ x5) & (x0 ^ x6))
        c6 = x6 ^ x5 ^ ((1 ^ x0 ^ x6) & x1)

        d0 = c0 ^ c6
        d1 = c1 ^ c0
        d2 = c2
        d3 = c3 ^ c2
        d4 = c4
        d5 = c5 ^ c4
        d6 = c6

        y0 = d0
        y1 = d1
        y2 = d2
        y3 = d3 ^ 1
        y4 = d4
        y5 = d5
        y6 = d6

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def sbox_nw7_equations4(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        d0 = x0 ^ x6 ^ ((1 ^ x1) & (x2 ^ x1)) ^ x6 ^ x5 ^ ((1 ^ x0 ^ x6) & x1)
        d1 = x1 ^ ((1 ^ x2 ^ x1) & x3) ^ x0 ^ x6 ^ ((1 ^ x1) & (x2 ^ x1))
        d2 = x2 ^ x1 ^ ((1 ^ x3) & (x4 ^ x3))
        d3 = x3 ^ ((1 ^ x4 ^ x3) & x5) ^ x2 ^ x1 ^ ((1 ^ x3) & (x4 ^ x3))
        d4 = x4 ^ x3 ^ ((1 ^ x5) & (x6 ^ x5))
        d5 = x5 ^ ((1 ^ x6 ^ x5) & (x0 ^ x6)) ^ x4 ^ x3 ^ ((1 ^ x5) & (x6 ^ x5))
        d6 = x6 ^ x5 ^ ((1 ^ x0 ^ x6) & x1)

        y0 = d0
        y1 = d1
        y2 = d2
        y3 = d3 ^ 1
        y4 = d4
        y5 = d5
        y6 = d6

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def sbox_nw7_equations5(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        y0 = x0 ^ x6 ^ ((1 ^ x1) & (x2 ^ x1)) ^ x6 ^ x5 ^ ((1 ^ x0 ^ x6) & x1)
        y1 = x1 ^ ((1 ^ x2 ^ x1) & x3) ^ x0 ^ x6 ^ ((1 ^ x1) & (x2 ^ x1))
        y2 = x2 ^ x1 ^ ((1 ^ x3) & (x4 ^ x3))
        y3 = x3 ^ ((1 ^ x4 ^ x3) & x5) ^ x2 ^ x1 ^ ((1 ^ x3) & (x4 ^ x3)) ^ 1
        y4 = x4 ^ x3 ^ ((1 ^ x5) & (x6 ^ x5))
        y5 = x5 ^ ((1 ^ x6 ^ x5) & (x0 ^ x6)) ^ x4 ^ x3 ^ ((1 ^ x5) & (x6 ^ x5))
        y6 = x6 ^ x5 ^ ((1 ^ x0 ^ x6) & x1)

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def sbox_nw7_equations(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1
        x5 = (i >> 5) & 1
        x6 = (i >> 6) & 1

        y0 = (x6 & x1) ^ x5 ^ (x2 & x1) ^ x2 ^ (x1 & x0) ^ x1 ^ x0
        y1 = x6 ^ (x3 & x2) ^ (x3 & x1) ^ x3 ^ (x2 & x1) ^ x2 ^ x1 ^  x0
        y2 = (x4 & x3) ^ x4 ^ x2 ^ x1
        y3 = (x5 & x4) ^ (x5 & x3) ^ x5 ^ (x4 & x3) ^ x4 ^ x3 ^ x2 ^ x1 ^ 1
        y4 = (x6 & x5) ^ x6 ^ x4 ^ x3
        y5 = (x6 & x0) ^ x6 ^ (x5 & x0) ^ x5  ^ x4 ^ x3 ^ x0
        y6 = (x6 & x1) ^ x6 ^ x5 ^ (x1 & x0) ^ x1

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        o |= y5<<5
        o |= y6<<6
        return o

    def test_nw7_equations():
        nw=7
        for i in range(0,1<<nw):
            r=Gascon.sbox(i,nw)
            o=sbox_nw7_equations(i)
            if(r!=o):
                print("i=%x, r=%x, o=%x"%(i,r,o))
                exit()

    def sbox_nw5_equations(i):
        x0 = (i >> 0) & 1
        x1 = (i >> 1) & 1
        x2 = (i >> 2) & 1
        x3 = (i >> 3) & 1
        x4 = (i >> 4) & 1

        y0 = (x4 & x1) ^ x3 ^ (x2 & x1) ^ x2 ^(x1 & x0) ^ x1 ^ x0
        y1 = x4 ^ (x3 & x2) ^ (x3 & x1) ^ x3 ^ (x2 & x1) ^ x2 ^ x1 ^ x0
        y2 = (x4 & x3) ^ x4 ^ x2 ^ x1 ^  1
        y3 = (x4 & x0) ^ x4 ^ (x3 & x0) ^ x3 ^ x2 ^ x1 ^ x0
        y4 = (x4 & x1) ^ x4 ^ x3 ^ (x1 & x0) ^ x1

        o = y0
        o |= y1<<1
        o |= y2<<2
        o |= y3<<3
        o |= y4<<4
        return o

    def test_bijectivity(nw):
        used = {}
        for i in range(0,1<<nw):
            r=Gascon.sbox(i,nw)
            #print("%4x --> %4x"%(i,r))
            assert(r not in used)
            used[r]=1
        print("nw=%d is bijective"%nw)

    def gen_latex_ref_table(nw):
        for i in range(0,1<<nw):
            r=Gascon.sbox(i,nw)
            if(15==(i%16)):
                print("%02x \\\\"%(r))
            else:
                print("%02x & "%(r),end="")
        print()

    def get_sbox_size(sbox):
        s0 = sbox(0)
        nw=None
        for i in range(1,1<<16):
            if s0==sbox(i):
                nw=i.bit_length()-1
                break
        assert(nw is not None)
        #print(nw)
        return nw

    def gen_raw_table(sbox):
        nw = get_sbox_size(sbox)
        for i in range(0,1<<nw):
            r=sbox(i)
            print("%02x\t"%(r),end="")
        print()

    def gen_bin_table(sbox):
        nw = get_sbox_size(sbox)
        for i in range(0,1<<nw):
            r=sbox(i)
            print("{0:0{width}b} --> {1:0{width}b}".format(i,r,width=nw))
        print()

    def test_cycle(nw):
        s=0
        cnt=0
        while(True):
            n = Gascon.sbox(s,nw)
            s = n
            cnt+=1
            if n==0:
                break
        print("nw= %d: cycle length from 0 = %d"%(nw,cnt))
        return cnt

    def reverse(x,width):
        out = 0
        for i in range(0,width):
            out |= ((x >> i) & 1)<<(width-1-i)
        return out

    def print_reversed_indexes(width):
        [print("0x%02x, "%(reverse(x,width)),end="") for x in range(0,1<<width)]

    def table_to_str(t):
        return '\n'.join([' '.join([str(cell) for cell in row]) for row in t])

    def sub_zeros(str):
        str = str.replace('0', '.')
        return str

    def int_to_color(i):
        if i:
            i = i*4+4
        return "blue!%s"%str(i)

    def table_to_latex_colored(t):
        return ' \\\\\n'.join([' & '.join([" \cellcolor{%s} "%(int_to_color(cell)) for cell in row]) for row in t])

    def table_to_latex(t):
        return ' \\\\\n'.join([' & '.join(["%s"%(cell) for cell in row]) for row in t])+" \\\\\n"

    def table_to_svg_colored(t):
        numrows = len(t)    # 3 rows in your example
        numcols = len(t[0])
        svg = '<svg width="%d" height="%d">\n'%(numcols*10,numrows*10)
  #<rect width="300" height="100" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
        for col in range(0,numcols):
            for row in range(0,numrows):
                b = 255
                r = 255
                if t[row][col]:
                    r = max(0,255-(t[row][col] * 4+4))
                g = r
                svg += '<rect width="10" height="10" x="%d" y="%d" style="fill:rgb(%d,%d,%d)" />\n'%(col*10,row*10,r,g,b)
        svg += "</svg>"
        return svg

    def test_nw5_equations():
        nw=5
        for i in range(0,1<<nw):
            r=Gascon.sbox(i,nw)
            o=sbox_nw5_equations(i)
            if(r!=o):
                print("i=%x, r=%x, o=%x"%(i,r,o))
                exit()

    def bitcount(n):
        count = 0
        while n > 0:
            if (n & 1 == 1): count += 1
            n >>= 1
        return count

    def diff_branch_number(sbox):
        n = get_sbox_size(sbox)
        out = 1<<n
        for x0 in range(0,(1<<n) - 1):
            for x1 in range(x0+1,(1<<n)):
                out = min(out,bitcount(x0^x1)+bitcount(sbox(x0)^sbox(x1)))
        return out

    def lin_branch_number(sbox):
        n = get_sbox_size(sbox)
        out = 1<<n
        c = correlation_coef_table(sbox)
        for a in range(0,(1<<n)):
            for b in range(0,(1<<n)):
                cab = c[a][b]
                if cab:
                    out = min(out,bitcount(a)+bitcount(b))
        return out

    def delta_table(sbox,width):
        dim = (1<<width)
        delta = [ [0] * dim for _ in range(dim)]
        bmax=0
        for x in range(0,dim):
            sx = sbox(x)
            for a in range(0,dim):
                sxa = sbox(x^a)
                b = sx^sxa
                bmax = max(bmax,b)
                delta[a][b] += 1
        #print(bmax)
        return delta

    def correlation_coef_table(sbox):
        n = get_sbox_size(sbox)
        dim = (1<<n)
        out = [ [0] * dim for _ in range(dim)]
        for a in range(0,1<<n):
            for b in range(0,1<<n):
                s=0
                for x in range(0,1<<n):
                    ax = bitcount(a & x) & 1
                    bsx = bitcount(b & sbox(x)) & 1
                    e = ax^bsx
                    if 0==e:
                        s+=1
                    else:
                        s-=1
                out[a][b] = s//2
        return out

    def sbox9(i):
        return Gascon.sbox(i,9)


    #for nw in range(5,9,2):
    #    gen_latex_ref_table(nw)
    #    test_bijectivity(nw)
    #test_nw7_equations()
    test_nw5_equations()
    nw=9
    #gen_latex_ref_table(nw)
    #print(table_to_svg_colored(delta_table(sbox_nw5_equations,5)))
    #gen_raw_table(sbox9)
    gen_bin_table(sbox_nw5_equations)
    #print(diff_branch_number(sbox_nw7_equations))
    #print(sub_zeros(table_to_latex(correlation_coef_table(sbox_nw5_equations))))
    #print(table_to_svg_colored(correlation_coef_table(sbox9)))
    #print(table_to_svg_colored(delta_table(sbox9,9)))
    #print(diff_branch_number(sbox_nw7_equations))
        #test_cycle(nw)
