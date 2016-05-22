#include <iostream>
#include <string>
using namespace std;
int main()
{
	double year;
	cout << "Enter in birth year" << endl;
	cin >> year;
	if(year<1970)
	{cout << "You qualify for the Juke Box Rally." << endl;
	}
	string fruit;
	cout <<"favorite fruit"<< endl;
	cin >> fruit;
	if(fruit=="strawberry")
	{
		cout << "Strawberry Fields Forever."<<endl;
	}else
	{
		cout << "Bye Bye miss american pie" << endl;
		}
		system("PAUSE");
}