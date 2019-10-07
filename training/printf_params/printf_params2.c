
# include <stdio.h>
// unsigned int values[8] = { 0x11111111, 0x22222222, 0x33333333, 0x44444444,
//                            0x55555555, 0x66666666, 0x77777777, 0x88888888 };

unsigned int var1 = 0x11111111;
unsigned int var2 = 0x22222222;
unsigned int var3 = 0x33333333;
unsigned int var4 = 0x44444444;
unsigned int var5 = 0x55555555;
unsigned int var6 = 0x66666666;
unsigned int var7 = 0x77777777;
unsigned int var8 = 0x88888888;

static char str[] = "vals 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x\n";
int main() {
//    printf(str, values[0], values[1], values[2], values[3],\
//                values[4], values[5], values[6], values[7]);
    printf(str, var1,var2,var3,var4,var5,var6,var7,var8);
    return 0;
}
