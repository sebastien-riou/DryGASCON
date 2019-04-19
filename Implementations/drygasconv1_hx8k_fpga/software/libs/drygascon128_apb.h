#ifndef __DRYGASCON128_APB_H__
#define __DRYGASCON128_APB_H__

#include <stdint.h>

typedef struct {
  volatile uint32_t CTRL;
  volatile uint32_t C;
  volatile uint32_t IO;
  volatile uint32_t X;
} Drygascon128_Regs;

#define DRYGASCON128_ROUNDS_O (0)
#define DRYGASCON128_DS_O (4)
#define DRYGASCON128_START_O (8)
#define DRYGASCON128_IDLE_O (31)

#define DRYGASCON128_START_MASK (1<<DRYGASCON128_START_O)
#define DRYGASCON128_IDLE_MASK (1<<DRYGASCON128_IDLE_O)

static unsigned int drygascon128hw_idle(Drygascon128_Regs *hw){
    return hw->CTRL & DRYGASCON128_IDLE_MASK;
}

static unsigned int drygascon128hw_wait_idle(Drygascon128_Regs *hw){
    while(!drygascon128hw_idle(hw));
}

static void drygascon128hw_start(Drygascon128_Regs *hw, unsigned int ds, unsigned int rounds){
    hw->CTRL = DRYGASCON128_START_MASK | (ds << DRYGASCON128_DS_O) | (rounds<<DRYGASCON128_ROUNDS_O);
}

static void drygascon128hw_set_x(Drygascon128_Regs *hw, const uint32_t *const x){
    hw->X = x[0];
    hw->X = x[1];
    hw->X = x[2];
    hw->X = x[3];
}

static void drygascon128hw_set_io(Drygascon128_Regs *hw, const uint32_t *const i){
    hw->IO = i[0];
    hw->IO = i[1];
    hw->IO = i[2];
    hw->IO = i[3];
}

static void drygascon128hw_get_io(Drygascon128_Regs *hw, uint32_t *const o){
    o[0] = hw->IO;
    o[1] = hw->IO;
    o[2] = hw->IO;
    o[3] = hw->IO;
}

static void drygascon128hw_set_c(Drygascon128_Regs *hw, const uint32_t *const c){
    for(unsigned int i=0;i<10;i++){
        hw->C = c[i];
    }
}

static void drygascon128hw_get_c(Drygascon128_Regs *hw, uint32_t *const c){
    for(unsigned int i=0;i<10;i++){
        c[i] = hw->C;
    }
}

static void drygascon128hw_g(Drygascon128_Regs *hw, uint32_t*const r, unsigned int rounds){
    drygascon128hw_start(hw, 0, rounds);
    drygascon128hw_wait_idle(hw);
    drygascon128hw_get_io(hw,r);
}

static void drygascon128hw_f(Drygascon128_Regs *hw, uint32_t*const r, const uint32_t*const in, uint32_t ds, unsigned int rounds){
    drygascon128hw_set_io(hw,in);
    drygascon128hw_start(hw, ds, rounds);
    drygascon128hw_wait_idle(hw);
    drygascon128hw_get_io(hw,r);
}

//return 0 if success or error code
static unsigned int drygascon128hw_test_ctrl(Drygascon128_Regs *hw){
    if(!drygascon128hw_idle(hw)) return 0x2;
    for(unsigned int i=0;i<256;i++){
        hw->CTRL = i;
        if(i!=(hw->CTRL & ~DRYGASCON128_IDLE_MASK)) return 0x01000000 | i;
    }
    hw->CTRL = 0xFFFFFE00;
    uint32_t z = hw->CTRL & ~DRYGASCON128_IDLE_MASK;
    if(z) return z;
    uint32_t p = 0;
    uint32_t q = 0;
    uint32_t c[10];
    for(unsigned int i=0;i<256;i++){
        for(unsigned int j=0;j<10;j++){
            p = i*16 + j;
            c[j] = p;
        }
        drygascon128hw_set_c(hw,c);
        drygascon128hw_get_c(hw,c);
        for(unsigned int j=0;j<10;j++){
            q = i*16 + j;
            if(c[j] != q) return 0x02000000 | i;
        }
    }
    for(unsigned int i=0;i<256;i++){
        for(unsigned int j=0;j<4;j++){
            p = i*16 + j;
            c[j] = p;
        }
        drygascon128hw_set_io(hw,c);
        drygascon128hw_get_io(hw,c);
        for(unsigned int j=0;j<4;j++){
            q = i*16 + j;
            if(c[j] != q) return 0x03000000 | i;
        }
    }
    //purge the internal state
    drygascon128hw_start(hw, 0, 1);
    drygascon128hw_wait_idle(hw);
    return 0;
}
#endif
