#include<stdio.h>
#include<string.h>

#define MAX_SIZE 256

unsigned int bn_init(unsigned char * x) {
    unsigned int i;
    for (i=0; i<MAX_SIZE; i++)
        x[i] = 0x00;
    return 0;
}
unsigned int bn_byte_size(const unsigned char *x) {
    // calculate the number of bit and round it with 8
    unsigned int ret=MAX_SIZE;
    unsigned int i=0;
    for(i=MAX_SIZE; i>0; i--)
        if(x[i-1] !=0 )
            return ret;
        else
            ret--;
    return ret;
}
int bn_print(unsigned char * x) {
    unsigned int i;
    unsigned int nr_size;
    nr_size = bn_byte_size(x);
    for (i=nr_size; i>0 ;i--)
        printf("%02x", x[i-1]);
    printf("\n");
    return 0;
}
unsigned char char2hex(char hi, char lo) {
    unsigned  char ret = 0;
    if(hi >= 'A' && hi <= 'F') ret = (hi - 'A')+10;
    if(hi >= 'a' && hi <= 'f') ret = (hi - 'a')+10;
    if(hi >= '0' && hi <= '9') ret = (hi - '0');
    ret = ret << 4;
    if(lo >= 'A' && lo <= 'F') ret += (lo - 'A')+10;
    if(lo >= 'a' && lo <= 'f') ret += (lo - 'a')+10;
    if(lo >= '0' && lo <= '9') ret += (lo - '0');
    return ret;
}
int bn_from_string(char * str, unsigned char *x) {
    unsigned int i;
    unsigned int j;
    unsigned int str_size;
    bn_init(x);
    str_size = strlen(str);
    j=0;
    for(i = str_size; i>0; i-=2) {
        if(i==1) {
            x[j] = char2hex('0', str[i-1]);
            j++;
            break;
        } else {
            x[j] = char2hex(str[i-2], str[i-1]);
            j++;
        }
    }
    return j;
}
int bn_mul(const unsigned char* u, const unsigned char *v, unsigned char *w) {
    unsigned int  u_size=0; // the size of the u number
    unsigned int  v_size=0; // the size of the v number
    unsigned int  w_size=0; // the size of the w number

    u_size = bn_byte_size(u); // calculate the size of u
    v_size = bn_byte_size(v); // calculate the size of v
    bn_init(w); // initialize the w

    unsigned int i; // the index in u number
    unsigned int j; // the index in the v number
    unsigned int k; // the index in the w number
    unsigned int l; // carry index for the w[k] number 
    for(k=0; k<u_size+v_size; k++) {
        for(i=0;i<u_size;i++) 
            for(j=0;j<v_size;j++) {
                if(i+j==k) {
                    unsigned int res;
                    res = w[k] + u[i]*v[j];
                    unsigned char hi_res = (unsigned char)((res >> 8) & 0xFF );
                    unsigned char lo_res = (unsigned char)( res       & 0xFF );
                    //printf("i=%d j=%d k=%d a=%02x b=%02x hi=%02x lo=%02x\n",i,j,k, u[i], v[j],  hi_res, lo_res );
                    w[k] = lo_res;
                    for(l=k+1; l<u_size+v_size; l++) {
                        //printf("l=%d hi=%02x w[l]=%02x\n", l, hi_res, w[l]);                       
                        res = w[l] + hi_res;
                        hi_res = (unsigned char)((res >> 8) & 0xFF );
                        lo_res = (unsigned char)( res       & 0xFF );
                        w[l] = lo_res;
                        if (hi_res == 0)
                            break;
                        //printf("Looping ....\n");
                    }
                }
            }
    }
    return 0;
} 
int bn_add(const unsigned char* u, const unsigned char *v, unsigned char *w) {
    unsigned int  u_size=0; // the size of the u number
    unsigned int  v_size=0; // the size of the v number
    unsigned int  w_size=0; // the size of the w number

    u_size = bn_byte_size(u); // calculate the size of u
    v_size = bn_byte_size(v); // calculate the size of v
    bn_init(w); // initialize the w

    unsigned int i; // the index in u number
    unsigned int j; // the index in the v number
    for(i=0; i<(u_size>v_size?u_size:v_size); i++) {
        unsigned int res;
        res = u[i]+v[i] + w[i];
        unsigned char hi_res = (unsigned char)((res >> 8) & 0xFF );
        unsigned char lo_res = (unsigned char)( res       & 0xFF );
        w[i] = lo_res;
        w[i+1] = hi_res;
    }
    return 0;
}


int main() {
    // 8 byte (64bit)
    // 1122334455667788
    // FFFFFFFFFFFFFFFF
    // 16 byte (128 bit)
    // 11223344556677881122334455667788
    // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    // 32 byte (256 bit)
    // 1122334455667788112233445566778811223344556677881122334455667788
    // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    // 64 byte (512 bit)
    // 11223344556677881122334455667788112233445566778811223344556677881122334455667788112233445566778811223344556677881122334455667788
    // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    // 128 byte (1024 bit)
    // 1122334455667788112233445566778811223344556677881122334455667788112233445566778811223344556677881122334455667788112233445566778811223344556677881122334455667788112233445566778811223344556677881122334455667788112233445566778811223344556677881122334455667788
    // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

    unsigned char u[MAX_SIZE]; // BN (Big Number)
    unsigned char v[MAX_SIZE]; // 
    unsigned char w[MAX_SIZE]; // 
    unsigned char ww[MAX_SIZE]; // 


    bn_init(u);
    bn_from_string("FFFFFFFF", u);
    bn_print(u);
    bn_init(v);
    bn_from_string("FFFFFFFF", v);
    bn_print(v);
    bn_mul(u, v, w);
    bn_print(w);
    bn_add(u, v, ww);
    bn_print(ww);
    return 0;
}