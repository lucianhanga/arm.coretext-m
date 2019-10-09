#include <stdio.h>

void array_reverse(unsigned int *array, 
                   unsigned int array_size) {
    if(array_size > 1) {
        register unsigned int temp;
        temp = array[0];
        array[0] = array[array_size-1];
        array[array_size -1] = temp;
        array_reverse(array+1, array_size-2);
    }
}

unsigned int arr[] = {11,22,33,44,55,66,77,88,99};
unsigned int arr_size = sizeof(arr)/sizeof(unsigned int);

unsigned int arr2[] = {11,22,33,44,55,66,77,88};
unsigned int arr2_size = sizeof(arr2)/sizeof(unsigned int);

int main() {
    int i;
    for (int i=0; i<arr_size; i++)
        printf("%02d  ", arr[i]);
    printf("\n");
    array_reverse(arr, arr_size);
    for (int i=0; i<arr_size; i++)
        printf("%02d  ", arr[i]);
    printf("\n");

    for (int i=0; i<arr2_size; i++)
        printf("%02d  ", arr2[i]);
    printf("\n");
    array_reverse(arr2, arr2_size);
    for (int i=0; i<arr2_size; i++)
        printf("%02d  ", arr2[i]);
    printf("\n");

    return 0;
}