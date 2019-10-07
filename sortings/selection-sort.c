//-------1---------2---------3---------4---------5---------6---------7---------8
//      
// Selection Sort
//
//    Sorts an array by repeatedly finding the  minimum element (ascending 
//    sorting) from the unsorted part and putting it at the beginning. The
//    algorithm maintains two subarrays in a given array:
//      - The subarray which is already sorted 
//      - Remaining subarray which is unsorted
//    example arr  = 12 14 29 17 09 56 98 11 10 06 88 01 
//    The ordered subarray has at first 0 elements and search through the
//    unordered one the minimum which is 01 and swap it the first element in
//    unordered array, here would be 12. Then the array will look:
//      arr = 01  14 29 17 09 56 98 11 10 06 88 12
//    Next iterration would be:
//      arr = 01 06   29 17 09 56 98 11 10 14 88 12
//   and so on ...
//
//

#include  <stdio.h>

unsigned int arr[100]= {01, 14, 29, 17, 9, 56, 98, 11, 10, 06, 88, 12};
unsigned int arr_size = 12;

int main() {
    unsigned int temp;

    int i; // will keep the beginning of the unordered array and with each 
           // iterration the beginning of the unordered array will be moved fwd
    for  (i=0; i< arr_size-1; i++) {
        int min_index  = i; // at this index which contains the minimum in the
                            // unsorted array
        int j;
        // loop through the unsorted array and find the minimum
        for (j = i+1; j<arr_size; j++) {
            if (arr[j] < arr[min_index])
                min_index = j;
        }
        // at the end of the loop above the min_index contains the index of min.
        // swap the first in the unsorted with the min
        temp = arr[i];
        arr[i] = arr[min_index];
        arr[min_index] = temp;
    }
    printf("Sorted: ");
    for (i=0;  i< arr_size; i++) {
        printf(" %02d", arr[i]);
    }
    printf("\n");
    return  0;
}

