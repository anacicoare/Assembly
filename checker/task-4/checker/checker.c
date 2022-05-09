#include <stdio.h>

extern void cpu_manufact_id(char *s);
extern void features(int *apic, int *rdrand, int *mpx, int *svm);
extern void l2_cache_info(int *line_size, int *cache_size);

int main(void)
{
	char id[13] = { 0 };
	int mpx = -1, rdrand = -1, apic = -1, svm = -1;
	int line_size = -1, cache_size = -1;

	cpu_manufact_id(id);
	printf("Manufacturer ID: %s\n", id);

	features(&apic, &rdrand, &mpx, &svm);
	printf("APIC: %d, RDRAND: %d, MPX: %d, SVM: %d\n", apic, rdrand, mpx, svm);

	l2_cache_info(&line_size, &cache_size);
	printf("Line size: %d B, Cache Size: %d KB\n", line_size, cache_size);

	return 0;
}