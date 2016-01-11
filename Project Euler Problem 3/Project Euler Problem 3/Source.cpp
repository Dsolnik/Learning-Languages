/*
The prime factors of 13195 are 5, 7, 13 and 29.
What is the largest prime factor of the number 600851475143 ?
*/
#include <iostream>
bool isPrime(int);
int main()
{
	int num = 600851475143;
	std::cout << num << std::endl;
	int factor;
	for (int i = num - 1; i >= 1; i--)
	{
		if (num % i == 0)
		{
			std::cout << i << std::endl;
			if (isPrime(i))
			{
				factor = i;
				break;
			}
		}
	}
	std::cout << factor << std::endl;
	system("PAUSE");
}

bool isPrime(int a)
{
	for (int i = a - 1; i > 1; i--)
	{
		if (a%i == 0)
		{
			return false;
		}
	}
	return true;
}