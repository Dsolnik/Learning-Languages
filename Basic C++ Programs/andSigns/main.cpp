#include <iostream>
using namespace std;
int main()
{
	for(int i=7;i>=1;i=i-2)
	{
		for(int p=0;p<(7-i)/2;p++)
		{
			cout << " ";
		}
		for(int p=0;p<i;p++)
		{
			cout << "&";
		}
		for(int p=0; p<(7-i)/2;p++)
		{
			cout << " ";
		}
		cout << endl;
	}
	system("PAUSE");
}