#include <stdio.h>

extern void replace_marco(const char *in_file, const char *out_file);

int main(int argc, void **argv)
{
	replace_marco(argv[1], argv[2]);

	return 0;
}