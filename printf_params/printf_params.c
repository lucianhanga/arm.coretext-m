
# include <stdio.h>
static char str[] = "value 0x%08x\n";
unsigned int	val1 = 0xffeeddcc;

int main() {
    printf(str, val1);
    return 0;	
}
			