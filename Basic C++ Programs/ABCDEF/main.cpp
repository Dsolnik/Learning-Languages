#include <iostream>
using namespace std;
int main()
{
	char ch='A';
	for(int i=0;i<=5;i++)
	{
		for(int k=0;k<=i;k++)
		{
			cout << (char)(ch+k);
		}
		cout << endl;
	}
	system("PAUSE");
}