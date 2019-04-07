#include <stdio.h>

float factorial_iter(int n) {
	int res = 1;

	for (int i = n; i > 1; i--) {
		res = res * i;
	}
	return res;
}

float factorial_recur(int n){

	if(n == 1 || n == 0){
		return 1;
	}
	else
		return n * factorial_recur(n-1);
}

int main() {

	printf("%.0f\n", factorial_iter(0));
	printf("%.0f\n", factorial_recur(0));

	return 0;
}