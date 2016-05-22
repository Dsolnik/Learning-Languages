#include <iostream>
using namespace std;
int main()
{
	int int1,int2;
	cout << "Enter integer 1" << endl;
	cin>> int1;
	cout << "Enter integer 2" << endl;
	cin>> int2;
	if(int1>int2)
	{
		cout << int2 << " , " << int1 << endl;
	}else if(int2>int1)
	{
		cout << int1 << " , " << int2 << endl;
	}else
	{
		cout << int2 << " and " << int1 << " are equal. "<< endl;
	}
	system("PAUSE");
}