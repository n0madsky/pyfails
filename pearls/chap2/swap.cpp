#include <time.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" {

void reverse_segment(int *list, int start, int finish) {
    while(start < finish) {
        int t = list[start];
        list[start] = list[finish];
        list[finish] = t;
        start++;
        finish--;
    }
}

void reverse_swap(int *list, int len, int pivot) {
    reverse_segment(list, 0, pivot - 1);
    reverse_segment(list, pivot, len - 1);
    reverse_segment(list, 0, len - 1);
}

// Shamelessly stolen from Wikipedia
int gcd(int u, int v)
{
    int shift;

    /* Let shift := lg K, where K is the greatest power of 2
     *         dividing both u and v. */
    for (shift = 0; ((u | v) & 1) == 0; ++shift) {
        u >>= 1;
        v >>= 1;
    }

    while ((u & 1) == 0)
        u >>= 1;

    /* From here on, u is always odd. */
    do {
        /* remove all factors of 2 in v -- they are not common */
        /*   note: v is not zero, so while will terminate */
        while ((v & 1) == 0)  /* Loop X */
            v >>= 1;

        /* Now u and v are both odd. Swap if necessary so u <= v,
         * then set v = v - u (which is even). For bignums, the
         * swapping is just pointer movement, and the subtraction
         * can be done in-place. */
        if (u > v) {
            int t = v; v = u; u = t;}  // Swap u and v.
        v = v - u;                       // Here v >= u.
    } while (v != 0);

    /* restore common factors of 2 */
    return u << shift;
}

void juggle_swap(int *list, int len, int pivot) {
    int loopTo = gcd(len, pivot);
    for (int i = 0; i < loopTo; i++) {
        int t = list[i];
        int prev = i;
        while (true) {
            int next = (prev + pivot) % len;
            if (next == i) {
                break;
            }
            list[prev] = list[next];
            prev = next;
        }
        list[prev] = t;
    }
}


timespec diff(timespec start, timespec end)
{
    timespec temp;
    if ((end.tv_nsec-start.tv_nsec)<0) {
        temp.tv_sec = end.tv_sec-start.tv_sec-1;
        temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
    } else {
        temp.tv_sec = end.tv_sec-start.tv_sec;
        temp.tv_nsec = end.tv_nsec-start.tv_nsec;
    }
    return temp;
}

timespec profile(void (*fn)(int*, int, int), int *list, int len, int pivot, int repeats) {
    timespec time1, time2;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time1);
    for(int i = 0; i < repeats; i++) {
        fn(list, len, pivot);
    }
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time2);
    timespec timetaken = diff(time1, time2);
    return timetaken;
}

void print_array(int *a, int len) {
    for (int i = 0; i < len; i++) {
        printf("%d, ", a[i]);
    }
    puts("\n");
}

int main(int argc, char **argv) {
    if (argc != 4) {
        printf("4 arguments needed: length, pivot, repeats\n");
        exit(1);
    }
    int len = atoi(argv[1]);
    int *a = (int*)malloc(sizeof(int) * len);
    for (int i = 0; i < len; i++) {
        a[i] = i;
    }
    int pivot = atoi(argv[2]);
    int repeats = atoi(argv[3]);
    printf("Length: %d, Pivot: %d, Repeats: %d\n", len, pivot, repeats);
    
#ifdef swap
    timespec timetaken = profile(reverse_swap, a, len, pivot, repeats);
    printf("Reverse Swap: %ld.%06ld seconds\n", timetaken.tv_sec, timetaken.tv_nsec / 1000);
#endif
#ifdef juggle
    timespec juggle_time = profile(juggle_swap, a, len, pivot, repeats);
    printf("Juggle Swap: %ld.%06ld seconds\n", juggle_time.tv_sec, juggle_time.tv_nsec / 1000);
#endif
    printf("%d\n", a[9]);// so we dont' get DEA'd
    free(a);
}

}
