//-------1---------2---------3---------4---------5---------6---------7---------8
//      
// Bubble Sort
//
//  It works by repatedly swapping the adjacent elemnts of an array if they are
//  in the old order. This procedure is repeted until in a round no swaps
//  occured, which means that all of the elements are in order.
//


#include  <stdio.h>

typedef enum { false, true } bool;

unsigned int arr[100]= {
     1, 14, 29, 17, 9, 56, 98, 11, 10, 06, 88, 12,
    11, 24, 39, 47, 91, 65, 89, 15, 19, 67, 81, 1
};
unsigned int arr_size = 24;

int main() {

    printf("UnSorted: ");
    int i;
    for(i=0; i<arr_size; i++)
        printf(" %02d", arr[i]);
    printf("\n");


    // do the sorting
    bool dirty=true; // dirty flag which indicates if there were swaps in a round
    while(dirty)  { // check for dirty flag. If set make another round
        dirty = false;  // reset the dirty flag
        for(i =0; i<arr_size-1; i++)
            if(arr[i]>arr[i+1]) {
                unsigned int temp;
                temp = arr[i];
                arr[i] = arr[i+1];
                arr[i+1] = temp;
                dirty = true;
            }
    }

    printf("Sorted:   ");
    for(i=0; i<arr_size; i++)
        printf(" %02d", arr[i]);
    printf("\n");
}