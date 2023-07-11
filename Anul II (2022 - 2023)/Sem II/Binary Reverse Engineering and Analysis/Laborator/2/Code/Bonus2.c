#include <stdio.h>
#include <stdint.h>
int main()
{
	uint64_t secret_value = 0xdeadc0de;
	uint64_t user_input;
	
	scanf("%lld", &user_input);
	user_input ^= 0x1337cafe;
	
	if (user_input == secret_value)
		puts("Correct!");
	else
		puts("Wrong");
	
	return 0;
}