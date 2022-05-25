#include <stdio.h>

extern float do_math(float x, float y, float z);

int main(void)
{
	float ret, x, y, z;

	scanf("%f %f %f\n", &x, &y, &z);
	ret = do_math(x, y, z);

	printf("%.3f\n", ret);
}