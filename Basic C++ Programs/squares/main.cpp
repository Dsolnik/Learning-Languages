#include <iostream>
#include <math.h>
using namespace std;
int main()
{
	for(int i=0;pow(2.0,i)<=128;i++)
	{
		cout << pow(2.0,i) << " ";
	}
	system("PAUSE");
}