#include <iostream>
#include <string>
using namespace std;
int main()
{
	double age;
	cout <<"what is your age" << endl;
	cin >> age;
	if(age<5)
	{
		cout << "it's free to enter the art museum; ";
	}else if(age<65)
	{
		
	cout << "it costs 2.50 to enter the art museum";
	}else
	{
		cout << "it costs 1.50 to enter the art museum";
	}
	system("PAUSE");
}