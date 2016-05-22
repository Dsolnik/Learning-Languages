#include <iostream>
using namespace std;
int main()
{
	int age;
	cout << "enter a positive integer" << endl;
	cin >> age;
	if(age%2==1)
	{
	cout << "It's odd" << endl;
	}else{
	cout << "It's even" << endl;
	}
	system("PAUSE");
}