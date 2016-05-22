#include <iostream>
using namespace std;
int main()
{
	double age;
	char name[50];
	cout << "enter in your age" << endl;
	cin >> age;
	cout << "enter in your name" << endl;
	cin >> name;
	if(age>16)
	{
		cout << "It's scary, " << name << " you are old enough to drive!" << endl;
	}else
	{
		cout << "You need to wait " << 16-age << "years before you can drive " << name << endl;
	}
	system("PAUSE");
}