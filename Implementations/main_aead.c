
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#include "bytes_utils.h"

#include "drysponge.h"

void bstr(const unsigned char *data, unsigned long long length){
    for (unsigned long long i = 0; i < length; i++)
		printf("%02X", data[i]);

    printf("\n");
}

int main(int argc, char *argv[]){
    (void)DRYSPONGE_hash;
    (void)DRYSPONGE_dec;
    (void)bytes_utils_remove_unused_warnings;

    if((argc>1) && (argv[1][0]=='i')){
        printf("%u %u %u %u\n",DRYSPONGE_KEYSIZE,DRYSPONGE_NONCESIZE,DRYSPONGE_TAGSIZE,DRYSPONGE_KEYMAXSIZE);
        exit(0);
    }

    if(argc!=6){
        printf("ERROR: need 1 or exactly 5 arguments: operation,key,nonce,message,associatedData\n");
        printf("Single argument is 'i', see below.\n");
        printf("Operations:\n");
        printf("    e: encrypt\n");
        printf("    d: decrypt\n");
        printf("    t: encrypt and check decrypt pass\n");
        printf("    i: print minimum key size, the nonce size and the tag size in bytes\n");
        return -1;
    }

    size_t mlenmax = 0;//high bound for mlen
    for(int i=1;i<argc;i++){
        mlenmax += (strlen(argv[i]))/2;
    }

    //printf("mlenmax=%lu\n",mlenmax);
    uint8_t *msg = malloc(mlenmax);
    if(0==msg){
        printf("ERROR: could not allocate memory (%lu bytes requested)\n",mlenmax);
        return -2;
    }

    uint8_t *m=msg;
    uint8_t*key=0;
    unsigned int keylen=0;
    uint8_t*nonce=0;
    uint8_t*message=0;
    uint8_t*ad=0;
    size_t mlen = 0;
    size_t alen = 0;
    size_t remaining=mlenmax;
    for(int i=2;i<6;i++){
        //printf("remaining=%lu\n",remaining);
        size_t bufsize = strlen(argv[i])+1;
        char *buf = malloc(bufsize);
        if(0==buf){
            printf("ERROR: could not allocate memory (%lu bytes requested)\n",bufsize);
            return -3;
        }
        strcpy(buf,argv[i]);
        size_t nbytes = user_hexstr_to_bytes(m,remaining,buf,bufsize);
        //size_t nbytes = 0;//hexstr_to_bytes(m,remaining,buf);
        switch(i){
            case 2: key = m;keylen=nbytes;assert(nbytes>=DRYSPONGE_KEYSIZE);assert(nbytes<=DRYSPONGE_KEYMAXSIZE);break;
            case 3: nonce = m;assert(nbytes==DRYSPONGE_NONCESIZE);break;
            case 4: message = m;mlen=nbytes;break;
            case 5: ad = m;alen=nbytes;break;
        }
        m+=nbytes;
        remaining-=nbytes;
        free(buf);
    }
    uint8_t *message_copy = malloc(mlen);
    assert(message_copy);
    memcpy(message_copy,message,mlen);
    uint8_t *cbuf = malloc(mlen+32);
    assert(cbuf);
    uint8_t *c=cbuf;
    size_t clen=0;
    unsigned int decrypt=0;
    unsigned int show_dec_result = 1;
    unsigned int check_decrypt=0;
    if(argv[1][0]=='d'){
        decrypt=1;
    }else{
        DRYSPONGE_enc(key,keylen,nonce,message,mlen,ad,alen,c,&clen);
        bstr(c, clen);
        if(argv[1][0]!='e'){
            decrypt=1;//if not e then we do encrypt and then decrypt
            check_decrypt=1;
            show_dec_result=0;
            c=message;
            for(size_t i=0;i<mlen;i++){
                message[i] = ~message[i];//destroy the original message
            }
            message=cbuf;
            mlen=clen;
        }

    }
    if(decrypt){
        clen = mlen-DRYSPONGE_TAGSIZE;
        if(DRYSPONGE_PASS!=DRYSPONGE_dec(key,keylen,nonce,message,mlen,ad,alen,c)){
            printf("ERROR: Forgerie detected!\n");
            free(message_copy);
            free(msg);
            free(cbuf);
            return -4;
        }
        if(check_decrypt){
            if(memcmp(message_copy,c,clen)){
                printf("INTERNAL ERROR: decryption does not recover message!\n");
                show_dec_result=1;
            }
        }
        if(show_dec_result){
            bstr(c, clen);
        }
    }

    free(message_copy);
    free(msg);
    free(cbuf);
    return 0;
}
