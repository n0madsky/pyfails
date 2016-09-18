

public class Swap {

    static void reverse_segment(int[] list, int start, int finish) {
        while(start < finish) {
            int t = list[start];
            list[start] = list[finish];
            list[finish] = t;
            start++;
            finish--;
        }
    }

    static void reverse_swap(int[] list, int len, int pivot) {
        reverse_segment(list, 0, pivot - 1);
        reverse_segment(list, pivot, len - 1);
        reverse_segment(list, 0, len - 1);
    }

    public static void main(String[] args) {
        int len = 10000;
        int[] a = new int[len];
        for(int i = 0; i < len; i++) {
            a[i] = i;
        }
        int pivot = 700;
        int repeats = 10000;
        
        // Let's do it for a bit of times so the JIT warms it up
        for (int i = 0; i < 1000; i++) {
            reverse_swap(a, len, pivot);
        }
        long start = System.nanoTime();
        for (int i = 0; i < repeats; i++) {
            reverse_swap(a, len, pivot);
        }
        long end = System.nanoTime();
	System.out.println(a[0]);
        System.out.printf("Reverse Swap: %f seconds\n", (end - start)/1000000000.0);
    }
}
